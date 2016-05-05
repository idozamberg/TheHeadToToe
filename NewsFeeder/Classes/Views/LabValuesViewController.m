//
//  LabValuesViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 10/14/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "LabValuesViewController.h"
#import "LabValue.h"
#import "AppData.h"
#import "LabValueCell.h"
#import "QuestionsHeader.h"

@interface LabValuesViewController ()

@end

@implementation LabValuesViewController
{
    NSMutableDictionary* valueList;
    NSArray* valueListKeys;
    NSMutableArray* rowsForSection;

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    valueList = [AppData sharedInstance].labValues;
    
    // Getting sorted keys
    valueListKeys = [UIHelper getSortedKeysArrayForDictionary:[AppData sharedInstance].labValues];
    
    [self.tblValues reloadData];
    
    // Setting navigation
    [self insertNavBarWithScreenName:SCREEN_LABORATOIRE];
    
    // Disabling selection
    self.tblValues.allowsSelection = NO;
    
    // Setting up collapse mechanism
    rowsForSection  = [NSMutableArray new];
    for (NSString* key in [valueList allKeys])
    {
        [rowsForSection addObject:[NSNumber numberWithInt:0]];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



# pragma mark TableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [valueList allKeys].count;
}// Default is 1 if not implemented


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    if ([[rowsForSection objectAtIndex:section] boolValue])
    {
        // Getting key
        NSString* key = [valueListKeys objectAtIndex:section];
        
        // Returning value
        NSArray* examTypeArray = [valueList objectForKey:key];
        
        return examTypeArray.count;
    }
    
    return 0 ;
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    LabValueCell * cell = nil;
    
    // Getting current key
    NSString* key = [valueListKeys objectAtIndex:indexPath.section];
    
    // Getting current lab value
    LabValue* currentValue = [[valueList objectForKey:key] objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"LabValueCell"];
    
    if ( cell == nil )
    {
        cell = [[LabValueCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"LabValueCell"];
    }
    
    // Setting cell's properties
    cell.lblName.text        = currentValue.name;
    cell.lblValue.text = currentValue.value;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title = [valueListKeys objectAtIndex:section];
    
    // Removing number from key
    NSArray* splitLabKey = [title componentsSeparatedByString:@"."];
    title = [splitLabKey objectAtIndex:1];
    
    // Setting header properties
    QuestionsHeader * headerView = nil;
    headerView = (QuestionsHeader *)[[QuestionsHeader alloc] viewFromStoryboard];
    [headerView setTitle:title];
    headerView.backgroundColor = gThemeColor;
    headerView.lblTitle.textColor = [UIColor whiteColor];
    
    headerView.delegate = self;
    headerView.tag = section;
    
    // Setting header image
    if (![[rowsForSection objectAtIndex:section] boolValue])
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Plus"]];
    }
    else
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Minus"]];
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 50;
}
- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (void) moreButtonClickedWithSection : (NSInteger) section
{
    {
        NSInteger rows;
        
        if (![[rowsForSection objectAtIndex:section] boolValue])
        {
            rows = 1;
        }
        else
        {
            rows = 0;
        }
        
        // Reloading table
        [rowsForSection replaceObjectAtIndex:section withObject:[NSNumber numberWithInteger:rows]];
        [self.tblValues reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    }
    

}


- (void) didClickNavBarLeftButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
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
