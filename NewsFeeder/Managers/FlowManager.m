//
//  FlowManager.m
//  HeadToToe
//
//  Created by ido zamberg on 23/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "FlowManager.h"
#import "FileListViewController.h"
#import "SystemsViewController.h"
#import "LabValuesViewController.h"

@implementation FlowManager

static FlowManager* sharedManager;


+ (FlowManager*) sharedInstance
{
    if (!sharedManager)
    {
        sharedManager = [FlowManager new];
    }
    
    return sharedManager;
}

- (void) showDataVCForSystem : (NSString*) system
{
    // Creating the systems vc
    SystemsViewController* vcSystems = (SystemsViewController*)[[SystemsViewController alloc] viewFromStoryboard];
    
    vcSystems.currentSystem = system;
    vcSystems.currentMenuMode = menuModeSubMenu;
    vcSystems.currentViewMode = viewModeInNavigation;
    [vcSystems.tblSystem reloadData];
    
    [[AppData sharedInstance].currNavigationController pushViewController:vcSystems animated:YES];
}

- (void) showFavoriteFileListViewControllerWithFilelist : (NSMutableArray*) list
{
    // Creating view controller
    SuperViewController* vcList = [[FileListViewController alloc] viewFromStoryboard];
    
    // Setting view mode
    vcList.currentViewMode = viewModeStandAlone;
    
    // Setting file's list
    [((FileListViewController*)vcList) setFilesList:list];
    
    // Push vc
    [[AppData sharedInstance].currNavigationController pushViewController:vcList animated:YES];
}

- (void) showLabValuesViewController
{
    LabValuesViewController* labVC = (LabValuesViewController*)[[LabValuesViewController alloc] viewFromStoryboard];
    
    [[AppData sharedInstance].currNavigationController pushViewController:labVC animated:YES];
}

@end
