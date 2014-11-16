//
//  QuestionsHeader.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuperView.h"

@protocol headerDelegate <NSObject>

- (void) moreButtonClickedWithSection : (NSInteger) section;
- (void) videoButtonClickedWithSection : (NSInteger) section;

@end

@interface QuestionsHeader : SuperView
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UIButton *btnMore;
@property (assign, nonatomic) id <headerDelegate> delegate;
@property (nonatomic)       BOOL isMore;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;

- (void) setTitle:(NSString *)title;
- (IBAction)moreClicked:(id)sender;
- (IBAction)videoClicked:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnVideoPage;

@end
