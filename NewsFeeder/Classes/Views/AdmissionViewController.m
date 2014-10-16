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

#define DEFAULT_CELL_SIZE 71
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dataSource = [AppData sharedInstance].questionsList;
    [self.tblAdmission reloadData];
    
    // Setting exapndable table
    currentSectionToReload = -1;
    rowsForSection  = [NSMutableArray new];
    for (NSString* key in [self.dataSource allKeys])
    {
        [rowsForSection addObject:[NSNumber numberWithInt:0]];
    }
    
    // Opening first section
    [rowsForSection setObject:[NSNumber numberWithInt:1] atIndexedSubscript:0];
    
    // Define navigation bar
    [self insertNavBarWithScreenName:SCREEN_ADMISSION];
    self.tblAdmission.allowsSelection = NO;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewTapped:)];
    tgr.delegate = self;
    [self.tblAdmission addGestureRecognizer:tgr]; // or [self.view addGestureRecognizer:tgr];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(heightChangedEvent:) name:@"PlusClickedInInnerTable" object:Nil];
    
    innerRowsForSection = [NSMutableArray new];
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
    return [[rowsForSection objectAtIndex:section] integerValue];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;//[self.dataSource allKeys].count;
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
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse General"];
    }
    else if (indexPath.section == SECTION_APS)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse par sytème"];
    }
    
    // Setting cell
    cell.rowsForSection = [NSMutableArray new];
    
    // Keeping track of cells size
   // if (![innerRowsForSection containsObject:cell.rowsForSection])
    //{
       // [innerRowsForSection addObject:cell.rowsForSection];
    
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
    
  //  }
    
    [cell setQuestionList:currentDictionary];
    cell.tag = indexPath.section;
    
    [cell.tblQuestions setHeight:[self calculateCellSizeForSection:currentDictionary andSection:indexPath.section]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
}


- (NSInteger) calculateCellSizeForSection : (NSMutableDictionary*) sectionDictionary andSection :(NSInteger) section
{
    NSInteger cellSize = 0;
    NSInteger sectionCounter = 0;
    // Going through
    for (NSString* key in [sectionDictionary allKeys])
    {
        if (innerRowsForSection.count > section)
        {
            if ([[[innerRowsForSection objectAtIndex:section] objectAtIndex:sectionCounter]boolValue])
            {
                if ([[sectionDictionary objectForKey:key] isKindOfClass:[NSArray class]])
                {
                    NSArray* category = [sectionDictionary objectForKey:key];
                    cellSize = +DEFAULT_CELL_SIZE * category.count;
                }
                else
                {
                    cellSize += DEFAULT_CELL_SIZE;
                }
            }
        }
        
        sectionCounter += 1;
        
        cellSize += 56;
    }
    
    return cellSize;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title;
    
    if (section == SECTION_AG)
    {
        title = @"Anamnèse General";
    }
    else if (section == SECTION_APS)
    {
        title = @"Anamnèse par sytème";
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
    return 56;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSMutableDictionary* currentDictionary;
    
    if (indexPath.section == SECTION_AG)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse General"];
    }
    else if (indexPath.section == SECTION_APS)
    {
        currentDictionary = [self.dataSource objectForKey:@"Anamnèse par sytème"];
    }
    
    return [self calculateCellSizeForSection:currentDictionary andSection:indexPath.section];
}


- (void) moreButtonClickedWithSection:(NSInteger)section
{
    NSInteger rows;
    
    if ([[rowsForSection objectAtIndex:section] integerValue] == 0)
    {
        rows = 1;
    }
    else
    {
        rows = 0;
    }
    
    // Reloading table
    [rowsForSection replaceObjectAtIndex:section withObject:[NSNumber numberWithInteger:rows]];
    currentSectionToReload = section;
    [self.tblAdmission reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
}


- (void)heightChangedEvent:(NSNotification *)notification {
    NSInteger section = [[[notification userInfo] valueForKey:@"section"] integerValue];
    
    [self.tblAdmission reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];

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
