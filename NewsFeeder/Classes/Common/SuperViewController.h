//
//  SuperViewController.h
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "Global.h"
#import "AppData.h"

@interface SuperViewController : UIViewController<UIAlertViewDelegate> {
    ;
}

- (SuperViewController *) viewFromStoryboard;
+ (SuperViewController *) viewFromStoryboard:(NSString *)storyboardID;


- (void) setEnable:(BOOL)enable;

- (void) resize;

@property (nonatomic)        viewMode        currentViewMode;

@end
