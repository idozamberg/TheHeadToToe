//
//  SearchViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SearchViewController.h"
//#import "ReaderViewController.h"
#import "QuestionsHeader.h"
#import "UIView+Framing.h"
#import "AnalyticsManager.h"
#import "PDFManager.h"
@interface SearchViewController ()
{
   // ReaderViewController* readerViewController;
    UIActivityIndicatorView* activity ;
    NSOperationQueue *myQueue;
}

@end

@implementation SearchViewController

@synthesize dataSourceArray = _dataSourceArray;
@synthesize tblList         = _tblList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void) setDataSourceArray:(NSMutableArray *)dataSourceArray
{
    // Setting data
    _dataSourceArray = dataSourceArray;
    
    [_tblList reloadData];
    
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self insertNavBarWithScreenName:SCREEN_SEARCH];
    
    myQueue = [[NSOperationQueue alloc] init];
    myQueue.name = @"Search Queue";
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navBarView.leftButton setHeight:28];
    [self.navBarView.leftButton setWidth:28];
    
    if (self.currentViewMode == viewModeStandAlone)
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"menu-50"]
                                    forState:UIControlStateNormal];

    }
    else if (self.currentViewMode == viewModeFromHomeScreen)
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"cancel-48"]
                                    forState:UIControlStateNormal];
        [self.navBarView.leftButton setHeight:20];
        [self.navBarView.leftButton setWidth:20];
    }
    else
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                    forState:UIControlStateNormal];
    }
    
    self.navigationController.delegate = Nil;
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [txtfldKeyword resignFirstResponder];
}

- (void) filterArrayByText :(NSString*) text
{
    
    [activity stopAnimating];
    [activity removeFromSuperview];
   // [myQueue cancelAllOperations];
    [self cancelMyOperationsInMainQueue];


    filteredArray = [NSMutableArray new];
    
    // Creating predicate for files and videos
    NSPredicate *filePredicate =
    [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.fileDescription contains[cd] %@) OR (SELF.system contains[cd] %@)" ,text,text,text];
    
    // Creating predicate for lab values
    NSPredicate *labPredicate =
    [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.value contains[cd] %@)",text,text];
    
    // Filtering the array
    filteredArrayFiles = [[NSMutableArray alloc] initWithArray:
    [[_dataSourceArray objectAtIndex:0] filteredArrayUsingPredicate:filePredicate]];
    
    filteredArrayVideos = (NSMutableArray*)[[_dataSourceArray objectAtIndex:2] filteredArrayUsingPredicate:filePredicate];
    filteredArrayLab = (NSMutableArray*)[[_dataSourceArray objectAtIndex:1] filteredArrayUsingPredicate:labPredicate];
    
//    
//    if (text.length > 3)
//    {
//        [activity stopAnimating];
//        [activity removeFromSuperview];
//        activity = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
//        
//        [activity setYPosition:self.navBarView.lblTitle.frame.origin.y];
//        [activity setXPosition:self.view.frame.size.width - 30];
//        [activity startAnimating];
//        [self.navBarView addSubview:activity];
//        
//        // Canceling all operations
//        //[myQueue cancelAllOperations];
//        [self cancelMyOperationsInMainQueue];
//        
//        // Creating operation
//        //SearchOperation* operation = [[SearchOperation alloc] initWithSearchString:text];
//        //operation.delegate = self;
//        //[myQueue addOperation:operation];
//        
//        // Searching
//        [myQueue addOperationWithBlock: ^ {
//            
//            // Scanning pdf files
//            NSMutableArray* scanResults = [[PDFManager sharedInstance] findStringInPdfLibrary:text];
//            // Adding result from files scanner
//            [filteredArrayFiles addObjectsFromArray:scanResults];
//            
//            // Update UI on the main thread.
//            [[NSOperationQueue mainQueue] addOperationWithBlock: ^ {
//                [self.tblList reloadData];
//                [activity stopAnimating];
//
//            }];
//            
//        }];
//        
//       /* dispatch_queue_t myQueue = dispatch_queue_create("My Queue",NULL);
//        dispatch_async(myQueue, ^{
//            // Perform long running process
//            // Scanning pdf files
//            NSMutableArray* scanResults = [[PDFManager sharedInstance] findStringInPdfLibrary:text];
//            // Adding result from files scanner
//            [filteredArrayFiles addObjectsFromArray:scanResults];
//            dispatch_async(dispatch_get_main_queue(), ^{
//                // Update the UI
//                
//            [self.tblList reloadData];
//                
//                
//            });
//        });*/
//        
//        
//    }
//    
    [filteredArray addObject:filteredArrayFiles];
    [filteredArray addObject:filteredArrayLab];
    [filteredArray addObject:filteredArrayVideos];

}

-(void)cancelMyOperationsInMainQueue {
    for (NSOperation* o in [myQueue operations]) {
        if ([o isKindOfClass:[SearchOperation class]]) {
            [o cancel];
        }
    }
}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnCancel]) {
        // Cancel to search
        [txtfldKeyword setText:@""];
        [self handleSearch:txtfldKeyword.text];
    }
}


#pragma mark --
#pragma mark -- Set navigationBar --

- (void) didClickNavBarLeftButton
{
    
    [txtfldKeyword resignFirstResponder];

    if (self.currentViewMode == viewModeStandAlone)
    {
        self.navigationController.delegate = Nil;
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }
    else
    {
        self.navigationController.delegate = [[self.navigationController viewControllers] objectAtIndex:[self.navigationController viewControllers].count-2];
        [self.navigationController popViewControllerAnimated:YES];
    }
    
}


#pragma mark --
#pragma mark -- UITextfieldDelegate --

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    [self handleSearch:textField.text];
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
    // Add search feature
    [self handleSearch:textField.text];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    
    return YES;
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    // Add search feature
    [self handleSearch:textField.text];
    
    return YES;
}



#pragma mark -- 
#pragma mark -- Handle Search -- 

- (void) handleSearch:(NSString *)keyword
{
    [self filterArrayByText:keyword];
    
    [_tblList reloadData];
}

#pragma mark tableview

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return filteredArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray* array = [filteredArray objectAtIndex:section];
    
    return (array.count);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    NSMutableArray* currentArray = [filteredArray objectAtIndex:indexPath.section];
    
    if(indexPath.section == FILES_SECTION)
    {
        FileCell * cell = nil;
        HTTFile* currentFile = [currentArray objectAtIndex:indexPath.row];
        
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
    else if(indexPath.section == LAB_SECTION)
    {
        LabValueCell * cell = nil;
        LabValue* currentValue = [currentArray objectAtIndex:indexPath.row];
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"LabCell"];
        
        if ( cell == nil )
        {
            cell = [[LabValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LabCell"];
        }
        
        // Setting cell's properties
        cell.lblName.text        = currentValue.name;
        cell.lblValue.text = currentValue.value;
        
        return cell;
    }
    else
    {
        HTTVideoTableViewCell* cell = nil;
        YouTubeVideoFile* currentFile = [currentArray objectAtIndex:indexPath.row];
        
        
        cell = [tableView dequeueReusableCellWithIdentifier:@"VideoCell"];
        
        if ( cell == nil )
        {
            cell = [[HTTVideoTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"VideoCell"];
        }
        else
        {
            [cell.videoPlayerViewController.moviePlayer stop];
            cell.lblTitle.text = @"";
            cell.lblDescription.text = @"";
            cell.imgThumb.image = Nil;
            cell.delegate = self;
        }
       
        // Setting cell's properties
        [cell loadThumbnailWithIdentifier:currentFile.name];
        // Setting cell's properties
        cell.lblDescription.text = currentFile.fileDescription;
        cell.lblTitle.text = currentFile.system;
        cell.cellModel = currentFile;

        return cell;
    }
    
    return Nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    if (indexPath.section == FILES_SECTION)
    {
        // Getting current file
        HTTFile* currentFile = [[filteredArray objectAtIndex:FILES_SECTION] objectAtIndex:indexPath.row];
        
        // Setting parameters
        [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ - %@",currentFile.system,currentFile.name],@"File Name", nil];
        
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"PDF File opended" Category:@"Files" Label:[NSString stringWithFormat:@"%@ - %@",currentFile.system,currentFile.name]];
        
        // Showing file
        [self ShowPDFReaderWithFile:currentFile];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == LAB_SECTION) {
        return 50;
    }
    
    return 71;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if ([[filteredArray objectAtIndex:section] count] > 0)
    {
        return 45;
    }
    
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title;
    
    if(section == FILES_SECTION)
    {
        title = @"Documents";
    }
    else if(section == LAB_SECTION)
    {
        title = @"Laboratoire";
    }
    else
    {
        title = @"Videos";
    }
    
    // Setting header properties
    QuestionsHeader * headerView = nil;
    headerView = (QuestionsHeader *)[[QuestionsHeader alloc] viewFromStoryboard];
    [headerView setTitle:title];
    headerView.backgroundColor = gThemeColor;
    headerView.lblTitle.textColor = [UIColor whiteColor];
    headerView.imgIcon.hidden = YES;
    
    return headerView;
}

- (void) didClickNavBarRightButton
{
    //[readerViewController pushActionBar];
}

#pragma mark search protocol
- (void) searchDidFinishedWithArray : (NSMutableArray*) array
{
    [filteredArrayFiles addObjectsFromArray:array];
    [self.tblList reloadData];
    [activity stopAnimating];

}

- (void) playClickedInVideoCellWithVideoPlayer : (XCDYouTubeVideoPlayerViewController*) youtubeController
{
    [self.view.window.rootViewController presentMoviePlayerViewControllerAnimated:youtubeController];
    
    //[self.navigationController pushViewController:youtubeController animated:YES];
    [youtubeController.moviePlayer play];
}


@end
