//
//  AppDelegate.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppData.h"
#import "NavigationControllerIOS6.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate> {
    // For Strings of interfaces
}

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) NSMutableDictionary * stringDicData;


- (void) getAllStrings;
- (NSInteger) getAllNumberOfSystems;

- (NSString *) getStringInScreen:(NSString *)screenName strID:(NSString *)strID;

- (NSString *) getResourcePathWithFilename:(NSString *) filename withExt:(NSString *)ext;
- (NSString *) getResourcePathWithFilename:(NSString *) filename;
- (NSString *) getDocumentPathWithFilename:(NSString *) filename withExt:(NSString *)ext;
- (NSString *) getDocumentPathWithFilename:(NSString *) filename;


- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                   receiver:(id)receiver
          cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtons:(NSArray *)titles;


- (float) getRealWidthFrom:(float)height
                   content:(NSString *)content
                  fontname:(NSString *)fontname
                  fontsize:(float)fontsize
             lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (float) getRealHeightFrom:(float)width
                    content:(NSString *)content
                   fontname:(NSString *)fontname
                   fontsize:(float)fontsize
              lineBreakMode:(NSLineBreakMode)lineBreakMode;

- (float) getRealWidthFrom:(float)height content:(NSString *)content
                      font:(UIFont *)font
             lineBreakMode:(NSLineBreakMode)lineBreakMode;
- (float) getRealHeightFrom:(float)width content:(NSString *)content
                       font:(UIFont *)font
              lineBreakMode:(NSLineBreakMode)lineBreakMode;

@property (strong, nonatomic) NavigationControllerIOS6* NavigationControllerObj;

@property (nonatomic, retain) NSString *strOrientation;

@property (nonatomic, readwrite) int intiPhone5;

@property (nonatomic, readwrite) int intIOS7;


@end
