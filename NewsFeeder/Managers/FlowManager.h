//
//  FlowManager.h
//  HeadToToe
//
//  Created by ido zamberg on 23/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AppData.h"

@interface FlowManager : NSObject

+ (FlowManager*) sharedInstance;
- (void) showDataVCForSystem : (NSString*) system;
- (void) showFavoriteFileListViewControllerWithFilelist : (NSMutableArray*) list;
@end
