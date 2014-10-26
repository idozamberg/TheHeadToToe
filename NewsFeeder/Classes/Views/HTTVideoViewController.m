//
//  HTTVideoViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTVideoViewController.h"
#import "HTTVideoTableViewCell.h"
#import "YouTubeVideoFile.h"


@interface HTTVideoViewController ()

@end

@implementation HTTVideoViewController
@synthesize filesList = _filesList,system = _system;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setting navigation
    [self insertNavBarWithScreenName:SCREEN_VIDEOS];
    [self.tblVideos reloadData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setFilesList:(NSMutableArray *)filesList
{
    _filesList = filesList;
    
    [_tblVideos reloadData];
}

#pragma mark tableview

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filesList.count;
}

- (void) didClickNavBarLeftButton
{
    if (self.currentViewMode == viewModeInNavigation)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }
}


// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTTVideoTableViewCell * cell = nil;
    YouTubeVideoFile* currFile = [_filesList objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"HTTVideoTableViewCell"];
    
    if ( cell == nil )
    {
        cell = [[HTTVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HTTVideoTableViewCell"];
    }
    else
    {
        [cell.videoPlayerViewController.moviePlayer stop];
        cell.lblTitle.text = @"";
        cell.lblDescription.text = @"";
        cell.imgThumb.image = Nil;
    }
    // Setting cell's properties
    [cell loadThumbnailWithIdentifier:currFile.name];
    cell.lblTitle.text = [NSString stringWithFormat:@"System %@",_system];
    cell.lblDescription.text = currFile.fileDescription;
    cell.cellModel = currFile;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
   // HTTVideoTableViewCell* cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    
    //[cell playMovie];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 268;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
