//
//  SearchViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SearchViewController.h"
#import "ReaderViewController.h"
@interface SearchViewController ()
{
    ReaderViewController* readerViewController;
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
    
}

- (void) filterArrayByText :(NSString*) text
{
    NSPredicate *sPredicate =
    [NSPredicate predicateWithFormat:@"SELF.name contains[cd] %@",text];
    
    // Filtering the array
    filteredArray = [_dataSourceArray filteredArrayUsingPredicate:sPredicate];
    
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
    [self.navigationController popViewControllerAnimated:YES];
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

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return filteredArray.count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FileCell * cell = nil;
    HTTFile* currentFile = [filteredArray objectAtIndex:indexPath.row];
    
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
    HTTFile* currentFile = [filteredArray objectAtIndex:indexPath.row];
    
    [self ShowPDFReaderWithName:currentFile.name];
}

-(void)pushShowPDFReaderWithName : (NSString*) name
{
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    
    NSFileManager *fileManager = [NSFileManager new];
    
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsPath error:NULL];
    
    NSString *fileName = [fileList firstObject]; // Presume that the first file is a PDF
    
    NSString *filePath = [documentsPath stringByAppendingPathComponent:name];
    
    // NSString *filePath = [[NSBundle mainBundle] pathForResource:name ofType:@"pdf"];
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    
    readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    //readerViewController.delegate = self;
    
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
    
   // isShowingFile = YES;
}

- (void) didClickNavBarRightButton
{
    [readerViewController pushActionBar];
}


@end
