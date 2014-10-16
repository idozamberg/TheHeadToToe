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
#import "ReaderViewController.h"
#import "SearchViewController.h"

@interface FileListViewController ()
{
    BOOL isShowingFile;
    ReaderViewController *readerViewController;
}

@end

@implementation FileListViewController

@synthesize tblFileList = _tblFileList;
@synthesize filesList   = _filesList;

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

    if (isShowingFile)
    {
        [self.navigationController popViewControllerAnimated:YES];
        isShowingFile = NO;
    }
    else
    {
        /*CGRect frm = self.navigationController.view.frame;
        frm.origin.x = 254;
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:0.3f];
        [UIView setAnimationDelegate:self];
        
        [self.navigationController.view setFrame:frm];
        //[self setEnable:NO];
        
        [UIView commitAnimations];*/
        
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }

}

- (void) didClickNavBarRightButton
{
    if (isShowingFile)
    {
        [readerViewController pushActionBar];
    }
    else
    {
        SearchViewController * searchController = (SearchViewController *)[[SearchViewController alloc] viewFromStoryboard];
        searchController.dataSourceArray = _filesList;
        [self.navigationController pushViewController:searchController animated:YES];
    }
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
    HTTFile* currentFile = [_filesList objectAtIndex:indexPath.row];
    
    [self pushShowPDFReaderWithName:currentFile.name];
    
}

-(void)pushShowPDFReaderWithName : (NSString*) name
{
    // Setting up file name
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];

    NSString *documentsPath = [pathURL path];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsPath error:NULL];
    NSString *fileName = [fileList firstObject]; // Presume that the first file is a PDF
    NSString *filePath = [documentsPath stringByAppendingPathComponent:name];
    
    // Configuring screen
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    CustomNavigationBarView* navigation = [CustomNavigationBarView viewFromStoryboard];
    
    [navigation setFrame:CGRectMake( 0, 0, 320, 50 )];
    [navigation setBackgroundColor:THEME_COLOR_RED];
    [navigation showRightButton:YES];
    [navigation.lblTitle setText:@""];
    [navigation.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                forState:UIControlStateNormal];
    
    [navigation.rightButton setImage:[UIImage imageNamed:@"Arrow up"]
                            forState:UIControlStateNormal];
    
    
    navigation.delegate = self;
    
    [readerViewController.view addSubview:navigation];

    //[self.navigationController presentViewController:readerViewController animated:YES completion:Nil];
    
    [self.navigationController pushViewController:readerViewController animated:YES];
    
    isShowingFile = YES;
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
