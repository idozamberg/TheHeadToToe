//
//  LabValuesViewController.h
//  HeadToToe
//
//  Created by ido zamberg on 10/14/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavViewController.h"
#import "QuestionsHeader.h"

@interface LabValuesViewController : CustomNavViewController <UITableViewDataSource,UITableViewDelegate,headerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblValues;

@end
