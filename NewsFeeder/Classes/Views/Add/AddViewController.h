//
//  AddViewController.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "CustomNavViewController.h"
#import "AddContentCell.h"

@interface AddViewController : CustomNavViewController<AddContentCellDelegate> {
    IBOutlet UITableView * tblList;
    
    NSMutableArray * arrNews;
}

@end
