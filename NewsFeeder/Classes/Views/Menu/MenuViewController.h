//
//  MenuViewController.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperViewController.h"
#import "MenuColorSelectView.h"



@interface MenuViewController : SuperViewController<MenuColorSelectViewDelegate> {
    IBOutlet UIView * viewTop;
    IBOutlet UIImageView * imgvwPhoto;
    IBOutlet UILabel * lblName;
    IBOutlet UILabel * lblEmail;
    IBOutlet UIButton * btnSetting;
    IBOutlet UIView * viewHeader;
    IBOutlet UIButton * btnAdd;
    __weak IBOutlet UIView *vwDocumentsHeader;
    IBOutlet UITableView * tblMenu;
    IBOutlet MenuColorSelectView * viewBottom;
    __weak IBOutlet UIView *vwLabHeader;
    
    SuperViewController * currentController;
    menuMode currentMenuMode;
}

- (IBAction)homeClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnSystems;
@property (weak, nonatomic) IBOutlet UIButton *btnLabo;
@property (weak, nonatomic) IBOutlet UILabel *lblSystemsHeader;
@property (weak, nonatomic) IBOutlet UIImageView *imgSystemsIcon;
- (IBAction)searchClicked:(id)sender;

- (IBAction) button_click:(id)sender;

@end
