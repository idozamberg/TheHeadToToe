//
//  MenuViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuItemCell.h"
#import "FeedViewController.h"
#import "UICustomNavigationController.h"
#import "SettingViewController.h"
#import "AddViewController.h"
#import "FileListViewController.h"
#import "AdmissionViewController.h"
#import "LabValuesViewController.h"
#import "HTTVideoViewController.h"
#import "SystemsViewController.h"
#import "SearchViewController.h"

@interface MenuViewController ()

@end

@implementation MenuViewController
{
    NSString* currentSystem;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    currentSystem = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideSideMenu) name:@"LeftSideBarButtonClicked" object:Nil];
    
    currentMenuMode = menuModeMain;
    
    // Setting current view
    currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[SystemsViewController alloc] viewFromStoryboard]];
    [AppData sharedInstance].currNavigationController = (UICustomNavigationController*)currentController;
    
    CGRect frm = self.view.frame;
    frm.origin.x = 0;
    [currentController.view setFrame:frm];
    [self.view addSubview:currentController.view];
    
    
    [imgvwPhoto setRoundedCornersWithRadius:22
                                borderWidth:0
                                borderColor:[UIColor clearColor]];
    [lblName setText:@"My Name"];
    [lblEmail setText:@"aaa@email.com"];
    
    viewBottom.delegate = self;
    [viewBottom setTitle:@"Layout" color:THEME_COLOR_TYPE_RED];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchClicked:(id)sender {
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Search view showed" Category:@"Views" Label:@"Menu"];
    
    SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
    
    // Setting standalone mode
    searchController.currentViewMode = viewModeStandAlone;
    
    // Setting current ciew controller
    currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:searchController];
    
    searchController.dataSourceArray = [[AppData sharedInstance] flattenedSearchArray];
    
    [self showCurrentController];
}

- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnSetting]) {
        SettingViewController * controller = (SettingViewController *)[[SettingViewController alloc] viewFromStoryboard];
        [self presentViewController:controller
                           animated:YES
                         completion:^{
                             ;
                         }
         ];
    }
    else if ([sender isEqual:btnAdd]) {
        
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"View selected from menu" Category:@"Views" Label:@"Admission"];
        
        // Showing admission
        currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[AdmissionViewController alloc] viewFromStoryboard]];
        [AppData sharedInstance].currNavigationController = (UICustomNavigationController*)currentController;
        [self showCurrentController];
    }
    else if ([sender isEqual:self.btnLabo])
    {
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"View selected from menu" Category:@"Views" Label:@"Laboratoire"];
        
        // Sowing labo screen
        currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[LabValuesViewController alloc] viewFromStoryboard]];
        [self showCurrentController];

    }
    else if ([sender isEqual:self.btnSystems]) {
        
        if (currentMenuMode == menuModeMain)
        {
            currentMenuMode = menuModeClosed;
            [tblMenu reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];

        }
        else
        {
            // Setting up main mode
            currentMenuMode = menuModeMain;
            NSString* title = @"Systems";
            
            // Setting image background
            [self.imgSystemsIcon setImage:[UIImage imageNamed:@"lungs-50.png"]];
            self.lblSystemsHeader.text = title;
            
            [tblMenu reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
            

        }
    }
}


#pragma mark --
#pragma mark -- UITableViewDelegate Method --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (currentMenuMode == menuModeMain)
    {
        return [gAppDelegate getAllNumberOfSystems];
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


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 47;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSInteger cellRow = [indexPath row];
    
	MenuItemCell * cell = nil;
    NSString *cellid = @"MenuItemCell";
    cell = [tableView dequeueReusableCellWithIdentifier:cellid];
    
    if (cell == nil) {
        cell = [[MenuItemCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellid];
        [cell setSelectionStyle:UITableViewCellSelectionStyleBlue];
    }
    
    if (currentMenuMode == menuModeMain)
    {
        // Setting cell content
        [cell setCellContentWith:cellRow];
    }
    else
    {
        if (indexPath.row == 0)
        {
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].filesList objectForKey:currentSystem];
            
            // Setting cell name and number of entities
            [cell setCellContentWithLabel:[NSString stringWithFormat: @"Documents (%li)",files.count] andImageName:@"menu_cell_icon_pager"];
        }
        else
        {
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:currentSystem];
            
            // Setting cell name and number of entities
            [cell setCellContentWithLabel:[NSString stringWithFormat: @"Videos (%li)",files.count]andImageName:@"menu_cell_icon_pager"];
        }
    }
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselecting row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger cellRow = [indexPath row];
    
    if (currentController) {
        [currentController.view removeFromSuperview];
        currentController = nil;
    }
    
    
    // Submenu  handeling
    if (currentMenuMode == menuModeSubMenu)
    {
        if (indexPath.row == 0)
        {
            // Sending analytics
            [AnalyticsManager sharedInstance].sendToFlurry = YES;
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Files view showed" Category:@"Views" Label:@"Menu"];
            
            // Creating view controller
            SuperViewController* vcList = [[FileListViewController alloc] viewFromStoryboard];
            
            // Setting standalone mode
            ((FileListViewController*)vcList).currentViewMode = viewModeStandAlone;
            
            // Setting current ciew controller
            currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:vcList];
            
            
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].filesList objectForKey:currentSystem];
            
            // Setting file's list
            [((FileListViewController*)vcList) setFilesList:files];
            
            [self showCurrentController];
        }
        else
        {
            // Sending analytics
            [AnalyticsManager sharedInstance].sendToFlurry = YES;
            [[AnalyticsManager sharedInstance] sendEventWithName:@"Videos view showed" Category:@"Views" Label:@"Menu"];

            
            // Creating view controller
            SuperViewController* vcList = [[HTTVideoViewController alloc] viewFromStoryboard];
            
            // Setting standalone mode
            ((FileListViewController*)vcList).currentViewMode = viewModeStandAlone;
            
            // Setting current ciew controller
            currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:vcList];
            
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:currentSystem];
            
            // Setting system name
            ((HTTVideoViewController*)vcList).system = currentSystem;
         
            // Setting file's list
            [((HTTVideoViewController*)vcList) setFilesList:files];
            
            [self showCurrentController];
        }

    }
    else
    {
        // Setting up sub menu mode
        currentMenuMode = menuModeSubMenu;
        NSString* title = [gAppDelegate getStringInScreen:SCREEN_MENU
                                                    strID:[NSString stringWithFormat:@"CELL_ROW%li", indexPath.row] ];
        
         // Setting image background
        [self.imgSystemsIcon setImage:[UIImage imageNamed:@"navbar_back.png"]];
        // [self.btnSystems setImage: forState:UIControlStateNormal];
         self.lblSystemsHeader.text = title;

        // Saving current system
        currentSystem = title;
        
        [UIView commitAnimations];

    
        [tableView reloadSections:[NSIndexSet indexSetWithIndex:0] withRowAnimation:UITableViewRowAnimationFade];
    }
    
}


- (void) showCurrentController
{
    if (currentController == nil) {
        return;
    }
    
    if ([currentController isKindOfClass:[UINavigationController class]]) {
        [AppData sharedInstance].currNavigationController = (UICustomNavigationController*)currentController;
    }
    
    CGRect frm = self.view.frame;
    frm.origin.x = 254;
    [currentController.view setFrame:frm];
    [self.view addSubview:currentController.view];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    currentController.view.transform = CGAffineTransformMakeTranslation( -254, 0 );
    [currentController.view setUserInteractionEnabled:YES];
    
    [UIView commitAnimations];
}

- (void) slideSideMenu
{
    if (currentController == nil) {
        return;
    }
    
    // Handling closing and opening view controller
    if (currentController.view.frame.origin.x > 0)
    {
        CGRect frm = currentController.view.frame;
        frm.origin.x = 0;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        
        [currentController.view setFrame:frm];
        
        [UIView commitAnimations];
    }
    else
    {
        CGRect frm = currentController.view.frame;
        frm.origin.x = 254;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        
        [currentController.view setFrame:frm];
        
        [UIView commitAnimations];
    }
}




#pragma mark -- 
#pragma mark -- MenuColorSelectViewDelegate --

- (void) didSelectColor:(MenuColorSelectView *)msv color:(THEME_COLOR_TYPE)color
{
    [viewHeader setBackgroundColor:gThemeColor];
    [vwDocumentsHeader setBackgroundColor:gThemeColor];
    [vwLabHeader setBackgroundColor:gThemeColor];
    
    if (currentController) {
        [currentController viewWillAppear:YES];
    }
}

- (BOOL) shouldAutorotate
{
    return NO;
}
- (IBAction)homeClicked:(id)sender {

    currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[SystemsViewController alloc] viewFromStoryboard]];
    [AppData sharedInstance].currNavigationController = (UICustomNavigationController*)currentController;
    
    [self showCurrentController];
}
@end
