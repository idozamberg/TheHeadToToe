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


@implementation HTTListTableViewCell
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
    
    if ([[[_questionList allValues] objectAtIndex:section] isKindOfClass:[NSArray class]])
    {
        if ([[rowsForSection objectAtIndex:section] boolValue])
        {
            NSArray* category =
                [[_questionList allValues] objectAtIndex:section];
            
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return ([_questionList allKeys].count);
}

// Row display. Implementers should *always* try to reuse cells by setting each cell's reuseIdentifier and querying for available reusable cells with dequeueReusableCellWithIdentifier:
// Cell gets various attributes set automatically based on table (separators) and data source (accessory views, editing controls)

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    QuestionCell* cell = nil;
    
    // Getting current category
    NSArray* category =
    [[_questionList allValues] objectAtIndex:indexPath.section];
    
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
    
    headerView =    [SuperView viewFromStoryboard:@"QuestionHeaderSimple"];//(QuestionsHeader *)[[QuestionsHeader alloc] viewFromStoryboard];
    [headerView setTitle:[[_questionList allKeys] objectAtIndex:section]];
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
        NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:[[_questionList allKeys] objectAtIndex:section]];
        
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
    [self.tblQuestions reloadSections:[NSIndexSet indexSetWithIndex:section] withRowAnimation:UITableViewRowAnimationFade];
  //  [self.tblQuestions reloadData];
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
    NSMutableArray* files = [[AppData sharedInstance].youTubeFilesList objectForKey:[[_questionList allKeys] objectAtIndex:section]];
    
    // Setting system name
    ((HTTVideoViewController*)vcList).system = [[_questionList allKeys] objectAtIndex:section];
    
    // Setting file's list
    [((HTTVideoViewController*)vcList) setFilesList:files];
    
    [[AppData sharedInstance].currNavigationController pushViewController:vcList animated:YES];
}

@end
