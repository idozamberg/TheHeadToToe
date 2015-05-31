//
//  HTTListTableViewCell.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTListTableViewCell.h"
#import "QuestionCell.h"
#import "AdmissionQuestion.h"
#import "SuperViewController.h"
#import "HTTVideoViewController.h"
#import "UIView+Framing.h"


@implementation HTTListTableViewCell
{
    NSMutableArray* sortedKeys;
    NSMutableDictionary* sortedDictionary;
}
@synthesize rowsForSection;

@synthesize questionList = _questionList;

- (void)awakeFromNib {
    // Initialization code
    rowsForSection = [NSMutableArray new];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    
    // Getting correct key
    NSString* key = [sortedKeys objectAtIndex:section];
    
    // Getting current category
    NSArray* category =
    [sortedDictionary objectForKey:key];
    
    if ([category isKindOfClass:[NSArray class]])
    {
        if ([[rowsForSection objectAtIndex:section] boolValue])
        {
            //NSArray* category =
              //  [[_questionList allValues] objectAtIndex:section];
            
            return category.count;
        }
        else
        {
            return 0;
        }
    }
    else
    {
        return 0;
    }
}

- (void) setQuestionList:(NSMutableDictionary *)questionList
{
    _questionList = questionList;
    

    [_tblQuestions reloadData];
}

- (NSArray*) getSortedKeysArrayForDictionary :(NSDictionary*) dict
{
    NSArray *arr =  [[dict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    return arr;
}

- (void) sortDictionaryKeys
{
    // Getting sorted keys
    NSArray* keys = [self getSortedKeysArrayForDictionary:_questionList];
    
    sortedKeys = [NSMutableArray new];
    sortedDictionary = [NSMutableDictionary new];
    
    // Going thourgh keys and splitting the number
    for (NSString* currKey in keys)
    {
        // Removing number from key
        NSArray* splitQuestionKey = [currKey componentsSeparatedByString:@"."];
        NSString* splittedKey = [splitQuestionKey objectAtIndex:1];
        
        // Adding key to local array
        [sortedKeys addObject:splittedKey];
        
        [sortedDictionary setObject:[_questionList objectForKey:currKey] forKey:splittedKey];
    }
}

- (void) setQuestionList:(NSMutableDictionary *)questionList WithHeight : (NSInteger) height
{
    _questionList = questionList;
    
    // Getting sorted keys array
    [self sortDictionaryKeys];
    
    [_tblQuestions setHeight:height];
    [_tblQuestions reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([_questionList allKeys].count);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell* cell = nil;
    
    // Getting correct key
    NSString* key = [sortedKeys objectAtIndex:indexPath.section];
    
    // Getting current category
    NSArray* category =
    [sortedDictionary objectForKey:key];
    
    // Getting current question
    AdmissionQuestion* currentQuestion = [category objectAtIndex:indexPath.row];
    
    cell = [tableView dequeueReusableCellWithIdentifier:@"QuestionCell"];
    
    if ( cell == nil )
    {
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"QuestionCell"];
    }
    
    // Setting Cell Model
    cell.cellModel = currentQuestion;
    
    // Setting cell's properties
    cell.lblQuestion.text = currentQuestion.text;
    cell.txtComment.enabled = YES;
    [cell setIsChecked:currentQuestion.wasChecked];
    cell.tag = indexPath.section;
    
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    QuestionsHeader * headerView = nil;
    
    headerView =  [SuperView viewFromStoryboard:@"QuestionHeaderSimple"];
    [headerView setTitle:[sortedKeys objectAtIndex:section]];
    headerView.tag = section;
    headerView.delegate = self;
    
    // Setting image
    if ([[rowsForSection objectAtIndex:section] integerValue] == 0)
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Plus_black"]];
    }
    else
    {
        [headerView.imgIcon setImage:[UIImage imageNamed:@"Minus_black"]];
    }
    
    headerView.btnVideoPage.hidden = YES;
    
    // Check if we should show the video part
    if ([self.part isEqualToString:@"Examen Physique"])
    {
        // Getting files list
        NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:[sortedKeys objectAtIndex:section]];
        
        // If there are videos
        if (files.count > 0)
        {
            headerView.btnVideoPage.hidden = NO;
        }
    }
    
    return headerView;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 45;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 45;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
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
    
    [self.tblQuestions beginUpdates];
    [self.tblQuestions reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationNone];
    [self.tblQuestions endUpdates];

    
    if (rows > 0)
    {
        [self.tblQuestions scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section]
                                   atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }

    
    NSDictionary* dict = [NSDictionary dictionaryWithObject:
                          [NSNumber numberWithInteger:self.tag]
                                                     forKey:@"section"];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"PlusClickedInInnerTable"
                                                        object:self
                                                      userInfo:dict];
    
}

- (void) videoButtonClickedWithSection:(NSInteger)section
{
    // Setting parameters
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:@"Home",@"Father View", nil];
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Videos view showed" Category:@"Views" Label:@"Home"];
    
    // Creating view controller
    SuperViewController* vcList = [[HTTVideoViewController alloc] viewFromStoryboard];
    
    // Setting view mode
    vcList.currentViewMode = viewModeInNavigation;
    
    // Getting files list
    NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:[sortedKeys objectAtIndex:section]];
    
    // Setting system name
    ((HTTVideoViewController*)vcList).system = [sortedKeys objectAtIndex:section];
    
    // Setting file's list
    [((HTTVideoViewController*)vcList) setFilesList:files];
    
    [[AppData sharedInstance].currNavigationController pushViewController:vcList animated:YES];
}

@end
