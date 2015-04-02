//
//  HTTVideoViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTVideoViewController.h"
#import "YouTubeVideoFile.h"
#import "SearchViewController.H"

@interface HTTVideoViewController ()

@end

@implementation HTTVideoViewController
@synthesize filesList = _filesList,system = _system;
@synthesize tblVideos = _tblVideos;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Setting navigation
    [self insertNavBarWithScreenName:SCREEN_VIDEOS];
    [self.tblVideos reloadData];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.tblVideos.delegate = self;
    self.tblVideos.dataSource = self;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.tblVideos.delegate = Nil;
    self.tblVideos.dataSource = Nil;
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
        cell.delegate = Nil;
    }
   
    // Setting cell's properties
    cell.lblTitle.text = [NSString stringWithFormat:@"Système %@",_system];
    cell.lblDescription.text = currFile.fileDescription;
    cell.cellModel = currFile;
    [cell loadThumbnailWithIdentifier:currFile.name];
    cell.delegate = self;
    
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


- (void) didClickNavBarRightButton
{
    
    // Getting first view controller
    UIViewController* viewController = [[self.navigationController viewControllers] objectAtIndex:0];
    
    // Disabling animation transition
    self.navigationController.delegate = Nil;
    
    // Setting parameters
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"FilesListView",@"Father View", nil];
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Search view showed" Category:@"Views" Label:@"FilesListView"];
    
    // Showing search screen
    SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
    searchController.dataSourceArray = [[AppData sharedInstance] flattenedSearchArray];
    
    // Setting navigation mode and showing screen
    searchController.currentViewMode = viewModeInNavigation;
    [self.navigationController pushViewController:searchController animated:YES];
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) playClickedInVideoCellWithVideoPlayer : (XCDYouTubeVideoPlayerViewController*) youtubeController
{
    [youtubeController.moviePlayer play];
    
    
    [self.view.window.rootViewController presentMoviePlayerViewControllerAnimated:youtubeController];
}

- (BOOL) shouldAutorotate
{
    return NO;
}
@end
