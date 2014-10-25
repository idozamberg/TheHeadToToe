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
    [self insertNavBarWithScreenName:SCREEN_DOCUMENTS];
    
    [_tblSystem reloadData];
    // Do any additional setup after loading the view.
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
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
}

- (void) didClickNavBarRightButton
{
    
   // SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
   // searchController.dataSourceArray = [[AppData sharedInstance] flattenedFilesArray];
    //[self.navigationController pushViewController:searchController animated:YES];
    
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
            // Creating view controller
            SuperViewController* vcList = [[FileListViewController alloc] viewFromStoryboard];
            
            // Setting current ciew controller
         //   currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:vcList];
            
            
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].filesList objectForKey:currentSystem];
            
            // Setting file's list
            [((FileListViewController*)vcList) setFilesList:files];
            
            [[AppData sharedInstance].currNavigationController pushViewController:vcList animated:YES];

        }
        else
        {
            // Creating view controller
            SuperViewController* vcList = [[HTTVideoViewController alloc] viewFromStoryboard];
            
            // Setting current ciew controller
            //currentController = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:vcList];
            
            // Getting files list
            NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:currentSystem];
            
            // Setting system name
            ((HTTVideoViewController*)vcList).system = currentSystem;
            
            // Setting file's list
            [((HTTVideoViewController*)vcList) setFilesList:files];
            
            [[AppData sharedInstance].currNavigationController pushViewController:vcList animated:YES];
            
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
        
        [UIView commitAnimations];
        
        
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

@end
