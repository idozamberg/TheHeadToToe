//
//  SettingViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SettingViewController.h"
#import "SettingHeaderView.h"
#import "SettingCell.h"
#import "SettingOptionCell.h"
#import "SettingPersonCell.h"

@interface SettingViewController ()

@end

@implementation SettingViewController

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
    
    [self insertNavBarWithScreenName:SCREEN_SETTING];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark -- Set navigationBar --

- (void) didClickNavBarLeftButton
{
    [self dismissViewControllerAnimated:YES
                             completion:^{
                                 ;
                             }
     ];
}


- (void) didClickNavBarRightButton
{
    ;
}


#pragma mark -- UITableViewDelegate, UITableViewDataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return 3;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SettingHeaderView * headerView = nil;
    
    if ( section != 0 ) {
        headerView = (SettingHeaderView *)[[SettingHeaderView alloc] viewFromStoryboard];
        [headerView setTitle:(section == 1) ? @"PRIMARY" : @"ALL"];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return (section == 0) ? 0 : 45;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return (indexPath.section == 0) ? 80 : 42;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int rows = 0;
    
    if (section == 0) {
        rows = 1;
    }
    else if (section == 1) {
        rows = 2;
    }
    else if (section == 2) {
        rows = 5;
    }
    
    return rows;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	UITableViewCell * cell = nil;
    
    // Set Cell Content
    if ( indexPath.section == 2 ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingCell"];
        
        if ( cell == nil )
        {
            cell = [[SettingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingCell"];
        }
        
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if ( indexPath.row == 0 ) {
            [((SettingCell *)cell) setCellContentWithTitle:@"Sync Editions" style:SETTING_CELL_STYLE_CHECK];
        }
        else if ( indexPath.row == 1 ) {
            [((SettingCell *)cell) setCellContentWithTitle:@"Layout" style:SETTING_CELL_STYLE_ORDER];
        }
        else if ( indexPath.row == 2 ) {
            [((SettingCell *)cell) setCellContentWithTitle:@"Share" style:SETTING_CELL_STYLE_ORDER];
        }
        else if ( indexPath.row == 3 ) {
            [((SettingCell *)cell) setCellContentWithTitle:@"Terms of Service" style:SETTING_CELL_STYLE_ORDER];
        }
        else if ( indexPath.row == 4 ) {
            [((SettingCell *)cell) setCellContentWithTitle:@"Translate" style:SETTING_CELL_STYLE_INDICATOR];
        }
    }
    else if ( indexPath.section == 1 ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingOptionCell"];
        
        if ( cell == nil )
        {
            cell = [[SettingOptionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingOptionCell"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        
        if ( indexPath.row == 0 ) {
            [((SettingOptionCell *)cell) setCellContentWithTitle:@"Open links in Safari" on:YES];
        }
        else if ( indexPath.row == 1 ) {
            [((SettingOptionCell *)cell) setCellContentWithTitle:@"Play Sounds" on:YES];
        }
    }
    else if ( indexPath.section == 0 ) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"SettingPersonCell"];
        
        if ( cell == nil )
        {
            cell = [[SettingPersonCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"SettingPersonCell"];
        }
        [cell setSelectionStyle:UITableViewCellSelectionStyleGray];
        
        if ( indexPath.row == 0 ) {
            [((SettingPersonCell *)cell) setCellContentWith:@"Erika Jones"
                                                       mail:@"e.jones@gmail.com"
                                                      photo:@"menu_example1"];
        }
    }
    
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}



@end
