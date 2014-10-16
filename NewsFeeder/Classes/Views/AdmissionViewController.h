//
//  AdmissionViewController.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomNavViewController.h"
#import "QuestionsHeader.h"


@interface AdmissionViewController : CustomNavViewController <UITableViewDataSource,UITableViewDelegate,UIGestureRecognizerDelegate,headerDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tblAdmission;
@property (nonatomic,strong) NSMutableDictionary* dataSource;
@end
