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
#import "HTTFavoriteFile.h"

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
    
    [self showSplashWithDuration:2];
    
    [self.view.window setRootViewController:self];
    
    currentSystem = @"";
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(slideSideMenu) name:@"LeftSideBarButtonClicked" object:Nil];
    
    currentMenuMode = menuModeMain;
    
    SystemsViewController* vcSystems = (SystemsViewController*)[[SystemsViewController alloc] viewFromStoryboard];
    vcSystems.currentMenuMode = menuModeMain;
    
    // Setting current navigation controller
    currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:vcSystems];
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

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [tblMenu reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)searchClicked:(id)sender {
    
    if (currentController) {
        [currentController.view removeFromSuperview];
        currentController = nil;
    }
    
    // Setting parameters
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"Menu",@"Father View", nil];
    
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
        
        if (currentController) {
            [currentController.view removeFromSuperview];
            currentController = nil;
        }
        
        // Setting parameters
        [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"Admission",@"View Name", nil];
        
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
        if (currentController) {
            [currentController.view removeFromSuperview];
            currentController = nil;
        }
        
        // Setting parameters
        [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"Laboratoire",@"View Name", nil];
        
        
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"View selected from menu" Category:@"Views" Label:@"Laboratoire"];
        
        // Sowing labo screen
        currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[LabValuesViewController alloc] viewFromStoryboard]];
        [self showCurrentController];

    }
    else if ([sender isEqual:self.btnSystems]) {
        
        
        [self homeClicked:self];
       /* if (currentMenuMode == menuModeMain)
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
            

        }*/
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
    if ([AppData sharedInstance].favoriteFilesList.count >= 10)
    {
        return  10;
    }
    else
    {
        return [AppData sharedInstance].favoriteFilesList.count;
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
    
    HTTFavoriteFile* favorite = [[AppData sharedInstance].favoriteFilesList objectAtIndex:indexPath.row];
    
    // Setting cell name
    [cell setCellContentWithLabel:favorite.name  andImageName:@"star-50-black.png"];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselecting row
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    NSInteger cellRow = [indexPath row];
    
    if (currentController) {
        //[currentController.view removeFromSuperview];
        //currentController = nil;
    }
    
    HTTFavoriteFile* favorite = [[AppData sharedInstance].favoriteFilesList objectAtIndex:indexPath.row];

    [self homeClicked:self];
    
    CustomNavViewController* currentNav = (CustomNavViewController*)[((UICustomNavigationController*)currentController).viewControllers objectAtIndex:0];
    [currentNav ShowPDFReaderWithFile:favorite];
    
 //  [self ShowPDFReaderWithFile:favorite];
 
   // [AppData sharedInstance].currNavigationController show;
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
    
    [tblMenu reloadData];
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

    if (currentController) {
        [currentController.view removeFromSuperview];
        currentController = nil;
    }
    
    currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[SystemsViewController alloc] viewFromStoryboard]];
    [AppData sharedInstance].currNavigationController = (UICustomNavigationController*)currentController;
    
    [self showCurrentController];
}

- (void)showSplashWithDuration:(CGFloat)duration
{
    // add splash screen subview ...
    
    UIImage *image          = [UIImage imageNamed:@"minisplashbig.png"];
    UIImageView *splash     = [[UIImageView alloc] initWithImage:image];
    splash.frame            = self.view.window.bounds;
    splash.autoresizingMask = UIViewAutoresizingNone;
    [self.view.window addSubview:splash];
    
    
    // block thread, so splash will be displayed for duration ...
    
    CGFloat fade_duration = (duration >= 0.5f) ? 0.5f : 0.0f;
    [NSThread sleepForTimeInterval:duration - fade_duration];
    
    
    // animate fade out and remove splash from superview ...
    
    [UIView animateWithDuration:fade_duration animations:^ {
        splash.alpha = 0.0f;
    } completion:^ (BOOL finished) {
        [splash removeFromSuperview];
    }];
}
@end
