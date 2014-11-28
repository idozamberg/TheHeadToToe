//
//  AdmissionViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "AdmissionViewController.h"
#import "HTTListTableViewCell.h"
#import "AppData.h"
#import "QuestionsHeader.h"
#import "UIView+Framing.h"
#import "PDFManager.h"

#define DEFAULT_CELL_SIZE 45
#define HEADER_HEIGHT 45
#define SECTION_AG 0
#define SECTION_APS 1
#define SECTION_EX 2

@interface AdmissionViewController ()

@end

@implementation AdmissionViewController
{
    NSInteger currentSectionToReload;
    NSMutableArray* rowsForSection;
    NSMutableArray* innerRowsForSection;
    BOOL            isInFilterMode;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    isInFilterMode = NO;
    self.dataSource = [AppData sharedInstance].questionsList
                                             ;
    
    // Setting exapndable table
    currentSectionToReload = -1;
    rowsForSection  = [NSMutableArray new];
    innerRowsForSection = [NSMutableArray new];
    
    NSInteger sectionCounter = 0;
    
    // Going throught all section and making sure they are closed
    for (NSString* key in [self.dataSource allKeys])
    {
        // Closing current section
        [rowsForSection addObject:[NSNumber numberWithInt:0]];
        
        NSMutableDictionary* currentDictionary;
        
        if (sectionCounter == SECTION_AG)
        {
            currentDictionary = [self.dataSource objectForKey:@"Anamnèse Générale"];
        }
        else if (sectionCounter == SECTION_APS)
        {
            currentDictionary = [self.dataSource objectForKey:@"Anamnèse par système"];
        }
        else
        {
            currentDictionary = [self.dataSource objectForKey:@"Examen Physique"];
        }
        
        NSMutableArray* currentRowsForSection = [NSMutableArray new];
        
        // Going through all inner sections and setting number of rows
        for (NSString* currKey in [currentDictionary allKeys])
        {
            [currentRowsForSection addObject:[NSNumber numberWithInt:0]];
        }
        
        // Setting opening state of orws for section
        [innerRowsForSection setObject:currentRowsForSection atIndexedSubscript:sectionCounter];
        
        sectionCounter += 1;

    }
    
    // Opening first section
    [rowsForSection setObject:[NSNumber numberWithInt:1] atIndexedSubscript:0];
    
    // Setting table variables
    self.tblAdmission.allowsSelection = NO;
    [self.tblAdmission reloadData];
    
    // Define navigation bar
    [self insertNavBarWithScreenName:SCREEN_ADMISSION];

    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.tblAdmission addGestureRecognizer:tgr]; // or [self.view addGestureRecognizer:tgr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heightChangedEvent:) name:@"PlusClickedInInnerTable" object:Nil];
    

}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
   //  [self.tblAdmission setHeight:self.view.frame.size.height - self.navBarView.frame.size.height];
}

- (void)viewTapped:(UITapGestureRecognizer *)tgr
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewTapped" object:Nil];
    // remove keyboard
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UITextField class]]) {
        NSLog(@"User tapped on UITextField");
    }
    return YES; // do whatever u want here
}

- (void) didClickNavBarRightButton
{
    NSString* typeOfPdf = isInFilterMode ? @"Filtered":@"Full";
    
    // Setting parameteres
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:typeOfPdf,@"Type Of PDF", nil];
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Admission PDF Created" Category:@"Admission" Label:typeOfPdf];
    
    // Creating and getting file's path
    NSString* path = [[PDFManager sharedInstance] createPdfFromDictionary:self.dataSource andShouldFilter:isInFilterMode];

    // Showing file
    [self ShowPDFReaderWithName:path];
}


- (void) didClickNavBarLeftButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSLog(@"sECTION : %i ,PROUT : %i",section,[[rowsForSection objectAtIndex:section] integerValue]);
    return [[rowsForSection objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    //return 2;
    return [self.dataSource allKeys].count;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    HTTListTableViewCell* cell = nil;
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"HTTListTableViewCell"];
    
    if ( cell == nil )
    {
        cell = [[HTTListTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HTTListTableViewCell"];
    }
    
    NSMutableDictionary* currentDictionary;
    
    if (indexPath.section == SECTION_AG)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse Générale"];
        cell.part = @"Anamnèse Générale";
    }
    else if (indexPath.section == SECTION_APS)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse par système"];
        cell.part = @"Anamnèse par système";
    }
    else
    {
        currentDictionary = [self.dataSource objectForKey:@"Examen Physique"];
        cell.part = @"Examen Physique";
    }
    
    // Setting cell
    cell.rowsForSection = [NSMutableArray new];

    
    if (innerRowsForSection.count > indexPath.section)
    {
        cell.rowsForSection = [innerRowsForSection objectAtIndex:indexPath.section];
    }
    else
    {
        [innerRowsForSection setObject:cell.rowsForSection atIndexedSubscript:indexPath.section];
        
        for (NSString* key in [currentDictionary allKeys])
        {
            [cell.rowsForSection addObject:[NSNumber numberWithInt:0]];
        }
    }
    
    // Setting question list for cell
  //  [cell setQuestionList:currentDictionary];
    [cell setQuestionList:currentDictionary WithHeight:[self calculateCellSizeForSection:currentDictionary andSection:indexPath.section]];
    
    // Setting tag for cell
    cell.tag = indexPath.section;
    
    [cell.tblQuestions reloadData];
    
    //[cell.tblQuestions setHeight:[self calculateCellSizeForSection:currentDictionary andSection:indexPath.section]];
    
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}

- (void) calculateAndSetTableHeight
{
    NSInteger totalHeight = 0;
    
    // Going through all sections and calculating size
    for (NSInteger sectionCounter=0;sectionCounter < [self.dataSource allKeys].count;sectionCounter++)
    {
        NSMutableDictionary* currentDictionary;
        
        if (sectionCounter == SECTION_AG)
        {
            currentDictionary = [self.dataSource objectForKey:@"Anamnèse Générale"];
        }
        else if (sectionCounter == SECTION_APS)
        {
            currentDictionary = [self.dataSource objectForKey:@"Anamnèse par système"];
        }
        else
        {
            currentDictionary = [self.dataSource objectForKey:@"Examen Physique"];
        }
        
        // Calculating current section size
        totalHeight += [self calculateCellSizeForSection:currentDictionary andSection:sectionCounter];
    }
    
    //[self.tblAdmission setHeight:totalHeight];
}


- (NSInteger) calculateCellSizeForSection : (NSMutableDictionary*) sectionDictionary andSection :(NSInteger) section
{
    NSInteger cellSize = 0;
    NSInteger sectionCounter = 0;
    
    // Going through all seciontion
    for (NSString* key in [sectionDictionary allKeys])
    {
        // If sections is open
        if (innerRowsForSection.count > section)
        {
            // If sections is open
            if ([[[innerRowsForSection objectAtIndex:section] objectAtIndex:sectionCounter]boolValue])
            {
                if ([[sectionDictionary objectForKey:key] isKindOfClass:[NSArray class]])
                {
                    // Calculating current category size
                    NSArray* category = [sectionDictionary objectForKey:key];
                    cellSize += DEFAULT_CELL_SIZE * category.count;
                }
                else
                {
                    cellSize += DEFAULT_CELL_SIZE;
                }
            }
        }
        
        sectionCounter += 1;
        
        // Adding header size
        cellSize += HEADER_HEIGHT;
    }
    
    NSLog(@"HEIGHT : %i", cellSize);
    
    return cellSize;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title;
    
    if (section == SECTION_AG)
    {
        title = @"Anamnèse Générale";
    }
    else if (section == SECTION_APS)
    {
        title = @"Anamnèse par système";
    }
    else
    {
        title = @"Examen Physique";
    }
    
    // Setting header properties
    QuestionsHeader * headerView = nil;
    headerView = (QuestionsHeader *)[[QuestionsHeader alloc] viewFromStoryboard];
    [headerView setTitle:title];
    headerView.backgroundColor = gThemeColor;
    headerView.lblTitle.textColor = [UIColor whiteColor];
    
    headerView.delegate = self;
    headerView.tag = section;
    
    // Setting header image
    if ([[rowsForSection objectAtIndex:section] integerValue] == 0)
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Plus"]];
    }
    else
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Minus"]];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* currentDictionary;
    
    // Getting currect dictionary
    if (indexPath.section == SECTION_AG)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse Générale"];
    }
    else if (indexPath.section == SECTION_APS)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse par système"];
    }
    else
    {
        currentDictionary = [self.dataSource objectForKey:@"Examen Physique"];
    }
    
    return [self calculateCellSizeForSection:currentDictionary andSection:indexPath.section];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* currentDictionary;
    
    if (indexPath.section == SECTION_AG)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse Générale"];
    }
    else if (indexPath.section == SECTION_APS)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse par système"];
    }
    else
    {
        currentDictionary = [self.dataSource objectForKey:@"Examen Physique"];
    }
    
    return [self calculateCellSizeForSection:currentDictionary andSection:indexPath.section];
}

- (void) moreButtonClickedWithSection:(NSInteger)section
{
    NSInteger rows;
    
    if ([[rowsForSection objectAtIndex:section] integerValue] == 0)
    {
        rows = 1;
        
        // Closing other part of the app
        for (NSInteger currSection = 0; currSection < rowsForSection.count ; currSection++)
        {
            if (currSection != section)
            {
                //[rowsForSection replaceObjectAtIndex:currSection withObject:[NSNumber numberWithInteger:0]];
            }
        }
    }
    else
    {
        rows = 0;
    }
    
    // Reloading table
    [rowsForSection replaceObjectAtIndex:section withObject:[NSNumber numberWithInteger:rows]];
    currentSectionToReload = section;
    
 //   [self.tblAdmission reloadData];
    //
    [self.tblAdmission beginUpdates];
    [self.tblAdmission reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tblAdmission endUpdates];

   // [self.tblAdmission reloadSections:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, 3)] withRowAnimation:UITableViewRowAnimationNone];
    //[self calculateAndSetTableHeight];
}


- (void)heightChangedEvent:(NSNotification *)notification {
    NSInteger section = [[[notification userInfo] valueForKey:@"section"] integerValue];
    
    // Reloading table view
    [self.tblAdmission beginUpdates];
    [self.tblAdmission reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tblAdmission endUpdates];
}

- (void) didClickNavBarMiddleButton
{
    if (isInFilterMode)
    {
        [self.navBarView.middleButton setImage:[UIImage imageNamed:@"filter-50.png"]
                                      forState:UIControlStateNormal];
    }
    else
    {
        [self.navBarView.middleButton setImage:[UIImage imageNamed:@"filter_filled-50.png"]
                                      forState:UIControlStateNormal];
    }
    
    isInFilterMode = !isInFilterMode;
    
}

- (void) didClickNavBarFarLeftMiddleButton
{
    self.dataSource = [[AppData sharedInstance] clearQuestions];
                       
    [_tblAdmission reloadData];
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
