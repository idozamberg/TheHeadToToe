//
//  InviteViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "InviteViewController.h"

@interface InviteViewController ()

@end

@implementation InviteViewController

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
    
    arrFBs = [[NSMutableArray alloc] init];
    [arrFBs addObject:[[InviteItemData alloc] initWithName:@"Kristen Wilkenson" addr:@"New York" photo:@"invite_example1"]];
    [arrFBs addObject:[[InviteItemData alloc] initWithName:@"Kristen Wilkenson" addr:@"New York" photo:@"invite_example1"]];
    [arrFBs addObject:[[InviteItemData alloc] initWithName:@"Kristen Wilkenson" addr:@"New York" photo:@"invite_example1"]];
    [arrFBs addObject:[[InviteItemData alloc] initWithName:@"Kristen Wilkenson" addr:@"New York" photo:@"invite_example1"]];
    
    arrTWs = [[NSMutableArray alloc] init];
    [arrTWs addObject:[[InviteItemData alloc] initWithName:@"Shandra Sven" addr:@"Chicaco" photo:@"invite_example1"]];
    [arrTWs addObject:[[InviteItemData alloc] initWithName:@"Shandra Sven" addr:@"Chicaco" photo:@"invite_example1"]];
    [arrTWs addObject:[[InviteItemData alloc] initWithName:@"Shandra Sven" addr:@"Chicaco" photo:@"invite_example1"]];
    [arrTWs addObject:[[InviteItemData alloc] initWithName:@"Shandra Sven" addr:@"Chicaco" photo:@"invite_example1"]];
    
    [self button_click:btnOptionFB];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnOptionFB]) {
        [imgvwOptionCursor setFrame:CGRectMake( 57, 110, 15, 10 )];
        [imgvwOptionCursor setImage:[UIImage imageNamed:@"invite_fb_cursor"]];
        
        fbSelected = TRUE;
    }
    else if ([sender isEqual:btnOptionTW]) {
        [imgvwOptionCursor setFrame:CGRectMake( 57 + 128, 110, 15, 10 )];
        [imgvwOptionCursor setImage:[UIImage imageNamed:@"invite_tw_cursor"]];
        
        fbSelected = FALSE;
    }
    else if ([sender isEqual:btnRefresh]) {
        // Refresh
        ;
    }
    
    [tblList reloadData];
}


#pragma mark -- 
#pragma mark -- InviteCellDelegate -- 

- (void) didChooseFriend:(InviteCell *)ic
{
//    NSIndexPath * index = [tblList indexPathForCell:ic];
}



#pragma mark -- UITableViewDelegate, UITableViewDataSource --

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
	return 58;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return fbSelected ? [arrFBs count] : [arrTWs count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = indexPath.row;
	InviteCell * cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"InviteCell"];
    
    if ( cell == nil )
    {
        cell = [[InviteCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"InviteCell"];
    }
    cell.delegate = self;
    
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    [cell setInviteCellWith:fbSelected ? [arrFBs objectAtIndex:row] : [arrTWs objectAtIndex:row]];
    
    return cell;
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath*)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:TRUE];
}



@end
