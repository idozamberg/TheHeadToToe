//
//  FileListViewController.m
//  NewsFeeder
//
//  Created by ido zamberg on 10/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "FileListViewController.h"
#import "FileCell.h"
#import "HTTFile.h"
//#import "ReaderViewController.h"
#import "SearchViewController.h"
#import "AnalyticsManager.h"


@interface FileListViewController ()
{
    BOOL isShowingFile;
   // ReaderViewController *readerViewController;
}

@end

@implementation FileListViewController


@synthesize tblFileList = _tblFileList;
@synthesize filesList   = _filesList;
@synthesize currentViewMode = _currentViewMode;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_DOCUMENTS];
    
    if (gDeviceType != DEVICE_IPAD) {
        CGRect frm = _tblFileList.frame;
        frm.origin.y = self.navBarView.frame.size.height - 20;
        frm.size.height = gScreenSize.height - self.navBarView.frame.size.height + 20;
        [_tblFileList setFrame:frm];
    }

    isShowingFile = NO;
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = Nil;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setFilesList:(NSMutableArray *)filesList
{
    _filesList = filesList;
    
    [_tblFileList reloadData];
}

- (void) didClickNavBarLeftButton
{
    if (self.currentViewMode == viewModeInNavigation)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }
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



# pragma mark TableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _filesList.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileCell * cell = nil;
    HTTFile* currentFile = [_filesList objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"FileCell"];
    
    if ( cell == nil )
    {
        cell = [[FileCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"FileCell"];
    }

    // Setting cell's properties
    cell.lblFileName.text        = currentFile.name;
    cell.lblFileDescription.text = currentFile.fileDescription;
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Deselecting row
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
  
    HTTFile* currentFile = [_filesList objectAtIndex:indexPath.row];
    
    // Setting parameters
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ - %@",currentFile.system,currentFile.name],@"File Name", nil];
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"PDF File opended" Category:@"Files" Label:[NSString stringWithFormat:@"%@ - %@",currentFile.system,currentFile.name]];
    
    // Showing file
    [self ShowPDFReaderWithName:currentFile.name];
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 71;
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
