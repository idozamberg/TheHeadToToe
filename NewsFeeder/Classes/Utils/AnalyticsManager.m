//
//  AnalyticsManager.m
//  365Scores
//
//  Created by ido zamberg on 4/5/13.
//  Copyright (c) 2013 for-each. All rights reserved.
//

#import "AnalyticsManager.h"


@implementation AnalyticsManager
@synthesize googleParameters,flurryParameters,sendToFlurry,sendToGoogle,sendToUserVod;

static AnalyticsManager* theManager = nil;

+ (AnalyticsManager*) sharedInstance
{
    @synchronized (theManager)
    {
        if (theManager== nil)
        {
            theManager = [[AnalyticsManager alloc] init];
            [theManager setUpAnalyticsCollectors];
        }
    }
    
    return theManager;
}

- (void) setUpAnalyticsCollectors
{
    
    [Flurry setCrashReportingEnabled:YES];
    
    // If it's production
    // 2ZD3DGCZQKDSPYPZNSB3
       //2ZD3DGCZQKDSPYPZNSB3
    // Testing
    //NXJWC6WPMXSDZ6YYRQ49
    // Replace YOUR_API_KEY with the api key in the downloaded package
    [Flurry startSession:@"GJFDRF24GDTF4ZBWZHHS"];
    //
    //PTRVWW6XGBKCHSTN78WM - ADHD
    // 2ZD3DGCZQKDSPYPZNSB3 - PROD
  
}


// Functions clears all parameters - should be invoked after each time we use the glass
// in order for the next use will be with correct parameters
- (void) ClearAllParameters
{
    flurryParameters = Nil;
    googleParameters = Nil;
    sendToGoogle = NO;
    sendToUserVod = NO;
    sendToFlurry = NO;
}

// cooladata even is screen_name with property defining the actual name which is based on the category
-(void) CreateCoolaDataEventFromCategory:(NSString*)category WithName:(NSString*)name
{
   }

- (void) sendEventWithName : (NSString*) eventName Category : (NSString*) category Label: (NSString*) label
{
    
    if (sendToFlurry)
    {
        // Sending event to flurry
        if (!flurryParameters)
        {
            [Flurry logEvent:[NSString stringWithFormat:@"%@ %@", category ,eventName]];
        }
        else
        {
            // Sending with parameters
            [Flurry logEvent:[NSString stringWithFormat:@"%@ %@", category ,eventName] withParameters:flurryParameters];
        }
        
        NSLog(@"\n[FLURRY] CATEGORY: %@\t EVENT: %@", category ,eventName);
        
    }
    
    [self ClearAllParameters];
}

@end
