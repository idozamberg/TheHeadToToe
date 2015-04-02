//
//  Global.h
//
//
//  Created by Harski Technology Holdings Pty. Ltd. on 1/20/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "AppDelegate.h"
#import "UIImageView+More.h"
#import "UIView+More.h"

typedef enum {
    DEVICE_IPHONE_35INCH,
    DEVICE_IPHONE_40INCH,
    DEVICE_IPAD,
} DEVICE_TYPE;


typedef enum {
    IOS_7 = 3,
    IOS_6 = 2,
    IOS_5 = 1,
    IOS_4 = 0,
} IOS_VERSION;

int gStatusBarHeight;

IOS_VERSION gIOSVersion;

DEVICE_TYPE gDeviceType;
CGSize gScreenSize;

UIInterfaceOrientation gDeviceOrientation;

AppDelegate * gAppDelegate;

UIColor * gThemeColor;
#define THEME_COLOR_GREEN [UIColor colorWithRed:151/255.0f green:227/255.0f blue:101/255.0f alpha:1.0f]
#define THEME_COLOR_RED   [UIColor colorWithRed:231/255.0f green: 76/255.0f blue: 60/255.0f alpha:1.0f]
#define THEME_COLOR_BLUE  [UIColor colorWithRed: 65/255.0f green:178/255.0f blue:236/255.0f alpha:1.0f]
#define THEME_COLOR_BLACK [UIColor colorWithRed: 49/255.0f green: 48/255.0f blue: 49/255.0f alpha:1.0f]


#define SCREEN_MENU @"SCREEN_MENU"
#define SCREEN_FEED	@"SCREEN_FEED"
#define SCREEN_SEARCH @"SCREEN_SEARCH"
#define SCREEN_SETTING @"SCREEN_SETTING"
#define SCREEN_ADD @"SCREEN_ADD"
#define SCREEN_DOCUMENTS @"SCREEN_DOCUMENTS"
#define SCREEN_ADMISSION @"SCREEN_ADMISSION"
#define SCREEN_LABORATOIRE @"SCREEN_LABORATOIRE"
#define SCREEN_VIDEOS @"SCREEN_VIDEOS"
#define SCREEN_HTT @"SCREEN_HTT"
#define SCREEN_WEBVIDEO @"SCREEN_WEBVIDEO"

#define STR_NAVTITLE @"NAV_TITLE"


