//
//  AddViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "AddViewController.h"
#import "NewsItemData.h"
#import "AddHeaderView.h"
#import "SearchViewController.h"

@interface AddViewController ()

@end

@implementation AddViewController

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
    
    [self insertNavBarWithScreenName:SCREEN_ADD];
    
    arrNews = [[NSMutableArray alloc] init];
    
    NSMutableArray * arr1 = [[NSMutableArray alloc] init];
    [arr1 addObject:[[NewsItemData alloc] initWithName:@"The Verge" subs:109654 photo:@"add_news1"]];
    [arr1 addObject:[[NewsItemData alloc] initWithName:@"Fast Company" subs:75492 photo:@"add_news2"]];
    [arr1 addObject:[[NewsItemData alloc] initWithName:@"Forbes" subs:64907 photo:@"add_news3"]];
    [arr1 addObject:[[NewsItemData alloc] initWithName:@"Wired" subs:183160 photo:@"add_news4"]];
    [arrNews addObject:arr1];
    
    NSMutableArray * arr2 = [[NSMutableArray alloc] init];
    [arr2 addObject:[[NewsItemData alloc] initWithName:@"500px" subs:109654 photo:@"add_recommend1"]];
    [arr2 addObject:[[NewsItemData alloc] initWithName:@"The Daily Beast" subs:75492 photo:@"add_recommend2"]];
    [arrNews addObject:arr2];
    
    
    if (gDeviceType != DEVICE_IPAD) {
        CGRect frm = tblList.frame;
        frm.origin.y = self.navBarView.frame.size.height - 20;
        frm.size.height = gScreenSize.height - self.navBarView.frame.size.height + 20;
        [tblList setFrame:frm];
    }
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
    CGRect frm = self.navigationController.view.frame;
    frm.origin.x = 254;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    [self.navigationController.view setFrame:frm];
    [self setEnable:NO];
    
    [UIView commitAnimations];
}


- (void) didClickNavBarRightButton
{
    SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
    [self.navigationController pushViewController:searchController animated:YES];
}


#pragma mark -- UITableViewDelegate, UITableViewDataSource --

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [arrNews count];
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    AddHeaderView * headerView = nil;
    
    headerView = (AddHeaderView *)[[AddHeaderView alloc] viewFromStoryboard];
    [headerView setTitle:(section == 0) ? @"NEWS" : @"RECOMMENDED"];
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 56;
}


-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 71;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[arrNews objectAtIndex:section] count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
	AddContentCell * cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"AddContentCell"];
    
    if ( cell == nil )
    {
        cell = [[AddContentCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"AddContentCell"];
    }
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setAddContentCellWith:[[arrNews objectAtIndex:indexPath.section] objectAtIndex:indexPath.row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}




#pragma mark -- 
#pragma mark -- AddContentCellDelegate -- 

- (void) willAddFeed:(AddContentCell *)acc
{
//    NSIndexPath * indexPath = [tblList indexPathForCell:acc];
}

@end
