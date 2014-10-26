//
//  AnalyticsManager.h
//  365Scores
//
//  Created by ido zamberg on 4/5/13.
//  Copyright (c) 2013 for-each. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Flurry.h"

@interface AnalyticsManager : NSObject

@property (nonatomic,strong) NSDictionary* flurryParameters;
@property (nonatomic,strong) NSNumber*     googleParameters;
@property (nonatomic)        BOOL          sendToGoogle;
@property (nonatomic)        BOOL          sendToFlurry;
@property (nonatomic)        BOOL          sendToUserVod;


+ (AnalyticsManager*) sharedInstance;

- (void) setUpAnalyticsCollectors;

- (void) sendEventWithName : (NSString*) eventName Category : (NSString*) category Label: (NSString*) label;

- (void) ClearAllParameters;


// Cool Data methods

@end


