//
//  SuperView.h
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Global.h"

@interface SuperView : UIView<UIAlertViewDelegate> {
    
}

- (SuperView *) viewFromStoryboard;
+ (id)viewFromStoryboard:(NSString *)storyboardID;

- (void) initialize;

- (void) resize;

@end
