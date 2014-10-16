//
//  CustomNavViewController.h
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SuperViewController.h"
#import "CustomNavigationBarView.h"

@interface CustomNavViewController : SuperViewController<CustomNavBarViewDelegate> {
	CustomNavigationBarView * navBarView;
    
    NSString *navBGFile;
}

@property (nonatomic, retain) CustomNavigationBarView * navBarView;

- (void) insertNavBarWithScreenName:(NSString *)screen;
- (void) setContentWithDicName:(NSString *)dicName;

- (void) resetElementsForMode:(BOOL)isPortrait;

- (void) moveToMainView;

@end
