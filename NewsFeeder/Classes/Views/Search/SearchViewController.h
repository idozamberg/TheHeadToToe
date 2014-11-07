//
//  SearchViewController.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "CustomNavViewController.h"
#import "HTTFile.h"
#import "FileCell.h"
#import "HTTVideoTableViewCell.h"
#import "LabValueCell.h"
#import "LabValue.h"
#import "YouTubeVideoFile.h"
#import "SearchOperation.h"

#define FILES_SECTION 0
#define LAB_SECTION 1
#define VIDEOS_SECTION 2

@interface SearchViewController : CustomNavViewController <UITableViewDataSource,UITableViewDelegate,searchProtocol>
{
    IBOutlet UIView * viewSearchbar;
    IBOutlet UITextField * txtfldKeyword;
    IBOutlet UIButton * btnCancel;
    
    NSMutableArray* filteredArray;
    NSMutableArray* filteredArrayFiles;
    NSMutableArray* filteredArrayLab;
    NSMutableArray* filteredArrayVideos;
}

@property (strong,nonatomic) NSMutableArray* dataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *tblList;

@end
