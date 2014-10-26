//
//  SystemsViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 10/24/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "SystemsViewController.h"
#import "MenuItemCell.h"
#import "FileListViewController.h"
#import "AppData.h"
#import "HTTVideoViewController.h"
#import "ATCAnimatedTransitioning.h"
#import "SearchViewController.h"
@interface SystemsViewController ()

@end

@implementation SystemsViewController
{
    menuMode currentMenuMode;
    NSString* currentSystem;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    currentMenuMode = menuModeMain;
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_HTT];
    
    [_tblSystem reloadData];
    // Do any additional setup after loading the view.
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (currentMenuMode == menuModeMain)
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"menu-50"]
                                    forState:UIControlStateNormal];
    }
    else
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                    forState:UIControlStateNormal];
    }
    
    self.navigationController.delegate = Nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentMenuMode == menuModeMain)
    {
        return 9;
    }
    else if (currentMenuMode == menuModeSubMenu)
    {
        return 2;
    }
    else
    {
        return 0;
    }
}

- (void) didClickNavBarLeftButton
{
    if (currentMenuMode == menuModeSubMenu)
    {
        // Reloading table
        currentMenuMode = menuModeMain;
        [_tblSystem reloadData];
        
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"menu-50.png"]
                                    forState:UIControlStateNormal];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }
}

- (void) didClickNavBarRightButton
{
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Search view showed" Category:@"Views" Label:@"Home"];
    
    // Showing search view
    SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
    searchController.dataSourceArray = [[AppData sharedInstance] flattenedSearchArray];
    searchController.currentViewMode = viewModeFromHomeScreen;
    
    self.navigationController.delegate = self;

    [self.navigationController pushViewController:searchController animated:YES];
    
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger cellRow = [indexPath row];
    
    MenuItemCell * cell = nil;
    NSString *cellid = @"SystemItemCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    if (currentMenuMode == menuModeMain)
    {
        // Setting cell content
        [cell setCellContentWith:cellRow andImageName:@"more_then-50"];
    }
    else
    {
        if (indexPath.row == 0)
        {
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].filesList objectForKey:currentSystem];
            
            // Setting cell name and number of entities
            [cell setCellContentWithLabel:[NSString stringWithFormat: @"Documents (%li)",files.count] andImageName:@"more_then-50"];
        }
        else
        {
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:currentSystem];
            
            // Setting cell name and number of entities
            [cell setCellContentWithLabel:[NSString stringWithFormat: @"Videos (%li)",files.count]andImageName:@"more_then-50"];
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselecting row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger cellRow = [indexPath row];
    
    
    // Submenu  handeling
    if (currentMenuMode == menuModeSubMenu)
    {
        if (indexPath.row == 0)
        {
            // Sending analytics
            [AnalyticsManager sharedInstance].sendToFlurry = YES;
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Files view showed" Category:@"Views" Label:@"Home"];
            
            // Creating view controller
            SuperViewController* vcList = [[FileListViewController alloc] viewFromStoryboard];
            
            // Setting view mode
            vcList.currentViewMode = viewModeInNavigation;
            
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].filesList objectForKey:currentSystem];
            
            // Setting file's list
            [((FileListViewController*)vcList) setFilesList:files];
            
            [self.navigationController pushViewController:vcList animated:YES];

        }
        else
        {
            // Sending analytics
            [AnalyticsManager sharedInstance].sendToFlurry = YES;
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Videos view showed" Category:@"Views" Label:@"Home"];
            
            // Creating view controller
            SuperViewController* vcList = [[HTTVideoViewController alloc] viewFromStoryboard];
            
            // Setting view mode
            vcList.currentViewMode = viewModeInNavigation;

            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:currentSystem];
            
            // Setting system name
            ((HTTVideoViewController*)vcList).system = currentSystem;
            
            // Setting file's list
            [((HTTVideoViewController*)vcList) setFilesList:files];
            
           [self.navigationController pushViewController:vcList animated:YES];
            
        }
        
    }
    else
    {
        // Setting up sub menu mode
        currentMenuMode = menuModeSubMenu;
        NSString* title = [gAppDelegate getStringInScreen:SCREEN_MENU
                                                    strID:[NSString stringWithFormat:@"CELL_ROW%li", indexPath.row] ];

        // Saving current system
        currentSystem = title;
        
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                    forState:UIControlStateNormal];
        
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (id<UIViewControllerAnimatedTransitioning>)navigationController:(UINavigationController *)navigationController
                                  animationControllerForOperation:(UINavigationControllerOperation)operation
                                               fromViewController:(UIViewController *)fromVC
                                                 toViewController:(UIViewController *)toVC
{
    self.animator = nil;
    
    self.transitionClassName = @"ATCAnimatedTransitioningFloat";

    
    if (NSClassFromString(self.transitionClassName)) {
        
        Class aClass = NSClassFromString(self.transitionClassName);
        self.animator = [[aClass alloc] init];
    }
    // only for KWTransition
    
    if (self.animator) {
        
        [self setupAnimatorForOperation:operation];
    }
    
    return self.animator;
}


// =============================================================================
#pragma mark - Private

// setup for each OSS
- (void)setupAnimatorForOperation:(UINavigationControllerOperation)operation
{
    // HUAnimator
    if ([self.animator isKindOfClass:[ATCAnimatedTransitioning class]]) {
        
        [self.animator setIsPush:YES];
        [self.animator setDuration:0.4];
        [self.animator setDismissal:(operation == UINavigationControllerOperationPop)];
        
        if (operation == UINavigationControllerOperationPush) {
            
            [(ATCAnimatedTransitioning *)self.animator setDirection:ATCTransitionAnimationDirectionRight];
        }
        else {
            [(ATCAnimatedTransitioning *)self.animator setDirection:ATCTransitionAnimationDirectionLeft];
        }
    }
    // ADTransition
    
}


@end
