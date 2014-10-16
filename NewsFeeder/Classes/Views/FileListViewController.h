//
//  FileListViewController.h
//  NewsFeeder
//
//  Created by ido zamberg on 10/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "CustomNavViewController.h"


@interface FileListViewController : CustomNavViewController <UITableViewDataSource,UITableViewDelegate>

// Outlets
@property (weak, nonatomic) IBOutlet UITableView *tblFileList;

// Properties
@property (nonatomic,strong) NSMutableArray* filesList;
@end
