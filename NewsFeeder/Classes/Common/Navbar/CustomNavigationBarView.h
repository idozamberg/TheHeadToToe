//
//  CustomNavigationBarView.h
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>


#import "SuperView.h"

@protocol CustomNavBarViewDelegate;

@interface CustomNavigationBarView : SuperView {
	IBOutlet UIImageView * bgImageView;
	
	IBOutlet UILabel *lblTitle;
}

@property (nonatomic, assign) id<CustomNavBarViewDelegate> delegate;

@property (nonatomic, retain) IBOutlet UIImageView * bgImageView;
@property (nonatomic, retain) IBOutlet UILabel * lblTitle;
@property (nonatomic, retain) IBOutlet UIButton * rightButton;
@property (nonatomic, retain) IBOutlet UIButton * leftButton;
@property (weak, nonatomic) IBOutlet UIButton *middleButton;
@property (weak, nonatomic) IBOutlet UIButton *farLeftMiddleButton;

- (IBAction) navbarButton_Click:(id)sender;
- (IBAction) middleButtonClicked:(id)sender;
- (IBAction)farLeftMiddleButtonClicked:(id)sender;

+ (id)viewFromStoryboard;

- (void) showRightButton:(BOOL)bShow;
- (void) showLeftButton:(BOOL)bShow;
- (void) showMiddleButton:(BOOL)bShow;
- (void) showfarLeftMiddleButton:(BOOL)bShow;


@end

@protocol CustomNavBarViewDelegate <NSObject>

@optional

- (void) didClickNavBarRightButton;
- (void) didClickNavBarLeftButton;
- (void) didClickNavBarMiddleButton;
- (void) didClickNavBarFarLeftMiddleButton;


@end