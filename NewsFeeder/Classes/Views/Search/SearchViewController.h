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

@interface SearchViewController : CustomNavViewController <UITableViewDataSource,UITableViewDelegate>
{
    IBOutlet UIView * viewSearchbar;
    IBOutlet UITextField * txtfldKeyword;
    IBOutlet UIButton * btnCancel;
    
    NSMutableArray* filteredArray;
}

@property (strong,nonatomic) NSMutableArray* dataSourceArray;
@property (weak, nonatomic) IBOutlet UITableView *tblList;

@end
