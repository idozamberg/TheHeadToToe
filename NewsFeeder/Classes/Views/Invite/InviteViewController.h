//
//  InviteViewController.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperViewController.h"
#import "InviteCell.h"

@interface InviteViewController : SuperViewController<InviteCellDelegate> {
    IBOutlet UIView * viewMenu;
    IBOutlet UILabel * lblTitle;
    IBOutlet UIButton * btnOptionFB;
    IBOutlet UIButton * btnOptionTW;
    IBOutlet UIImageView  *imgvwOptionCursor;
    
    IBOutlet UITableView * tblList;
    IBOutlet UIButton * btnRefresh;
    
    BOOL fbSelected;
    
    // Data
    NSMutableArray * arrFBs;
    NSMutableArray * arrTWs;
}

- (IBAction) button_click:(id)sender;

@end
