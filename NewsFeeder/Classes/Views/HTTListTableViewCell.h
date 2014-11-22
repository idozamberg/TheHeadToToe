//
//  HTTListTableViewCell.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "QuestionsHeader.h"


@interface HTTListTableViewCell : UITableViewCell <UITableViewDataSource,UITableViewDelegate,headerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblQuestions;
@property (strong,nonatomic) NSMutableDictionary* questionList;
@property (strong,nonatomic) NSMutableArray* rowsForSection;
@property (strong,nonatomic) NSString* part;

- (void) setQuestionList:(NSMutableDictionary *)questionList WithHeight : (NSInteger) height;


@end
