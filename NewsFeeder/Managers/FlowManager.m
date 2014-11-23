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

@end
