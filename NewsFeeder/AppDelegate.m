//
//  AppDelegate.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "AppDelegate.h"
#import "Global.h"

@implementation AppDelegate
@synthesize stringDicData,intIOS7,intiPhone5,strOrientation;
#import "NavigationControllerIOS6.h"


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    // Override point for customization after application launch.
    // Initialize Global variables
    gScreenSize = self.window.frame.size;
    
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) {
        gDeviceType = DEVICE_IPAD;
    }
    else if (self.window.frame.size.height == 568) {
        gDeviceType = DEVICE_IPHONE_40INCH;
    }
    else if ((self.window.frame.size.height == 1024) || (self.window.frame.size.height == 768)) {
        gDeviceType = DEVICE_IPAD;
    }
    else {
        gDeviceType = DEVICE_IPHONE_35INCH;
    }
    
    
    float iosversion = [[[UIDevice currentDevice] systemVersion] floatValue];
    
    if ( iosversion >= 7.0f) {
        gIOSVersion = IOS_7;
    }
    else if (iosversion >= 6.0f && iosversion < 7.0f) {
        gIOSVersion = IOS_6;
    }
    else if (iosversion >= 5.0f && iosversion < 6.0f) {
        gIOSVersion = IOS_5;
    }
    else if (iosversion >= 4.0f && iosversion < 5.0f) {
        gIOSVersion = IOS_4;
    }
    
    if (gIOSVersion != IOS_7) {
        gStatusBarHeight = 20;
    }
    
    gDeviceOrientation = UIInterfaceOrientationPortrait;
    
    [self getAllStrings];
    
    gAppDelegate = self;
    
    [[AppData sharedInstance] performStartupOperations];
    
    NSString * resourcePath = [[NSBundle mainBundle] resourcePath];
    
    
    NSString * documentsPath = [resourcePath stringByAppendingPathComponent:@"Resources/PDF/UDREM/Anatomie/"];
    
    
    NSError * error;
    NSArray * directoryContents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:documentsPath error:&error];
    
    self.intiPhone5=88;
    self.intIOS7=20;
    
    appDelObj.strOrientation = @"Portrait";
    appDelObj = (AppDelegate*)[[UIApplication sharedApplication] delegate];
    
    return YES;
}

- (NSInteger) getAllNumberOfSystems
{
    return [[stringDicData objectForKey:SCREEN_MENU] allKeys].count;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


#pragma mark --
#pragma mark -- GET REAL PATH OF FILE --

/*================================================================================
 *
 *	Get resource path
 * ---------------------
 *
 *	@description:
 *		Get Resource path of file
 *
 *	@parameters:
 *		NSString * filename : file name
 *		NSString * ext		: extension of file
 *
 *	@return: NSString *
 *		resource path string
 *
 ==================================================================================*/
- (NSString *) getResourcePathWithFilename:(NSString *) filename withExt:(NSString *)ext
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:ext];
	
	return [filePath copy];
}



/*================================================================================
 *
 *	Get resource path
 * ---------------------
 *
 *	@description:
 *		Get Resource path of file
 *
 *	@parameters:
 *		NSString * filename : file name ( including extension )
 *
 *	@return: NSString *
 *		resource path string
 *
 ==================================================================================*/
- (NSString *) getResourcePathWithFilename:(NSString *) filename
{
	NSString *filePath = [[NSBundle mainBundle] pathForResource:filename ofType:nil];
	
	return [filePath copy];
}



/*================================================================================
 *
 *	Get document path
 * ---------------------
 *
 *	@description:
 *		Get document path of file
 *
 *	@parameters:
 *		NSString * filename : file name
 *		NSString * ext		: extension of file
 *
 *	@return: NSString *
 *		document path string
 *
 ==================================================================================*/
- (NSString *) getDocumentPathWithFilename:(NSString *) filename withExt:(NSString *)ext
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *rootPath = (NSString*)[pathArray objectAtIndex:0];
	NSString *filePath = [rootPath stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.%@", filename, ext]];
	
	return [filePath copy];
}



/*================================================================================
 *
 *	Get document path
 * ---------------------
 *
 *	@description:
 *		Get document path of file
 *
 *	@parameters:
 *		NSString * filename : file name ( including extension )
 *
 *	@return: NSString *
 *		document path string
 *
 ==================================================================================*/
- (NSString *) getDocumentPathWithFilename:(NSString *) filename
{
	NSArray *pathArray = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *rootPath = (NSString*)[pathArray objectAtIndex:0];
	NSString *filePath = [rootPath stringByAppendingPathComponent:filename];
	
	return [filePath copy];
}



#pragma mark --
#pragma mark -- Get String data --

/*================================================================================
 *
 *	Get strings
 * ----------------------------------
 *
 *	@description:
 *		Get all strings from dic file
 *
 *	@return: none
 *
 ==================================================================================*/
- (void) getAllStrings
{
	// Load stringDic data
	NSString * realFileName = [NSString stringWithFormat:@"%@", @"strings"];
	stringDicData = [[NSMutableDictionary alloc] initWithContentsOfFile:[self getResourcePathWithFilename:realFileName withExt:@"plist"]];
}



/*================================================================================
 *
 *	Get string
 * ----------------------------------
 *
 *	@description:
 *		Get string of specified id, specified screen
 *
 *	@parameters:
 *		NSString * screenName : screen ID
 *		NSString * strID	  : string ID
 *
 *	@return: NSString *
 *		string
 *
 ==================================================================================*/
- (NSString *) getStringInScreen:(NSString *)screenName strID:(NSString *)strID
{
	NSString * value = @"";
	
	if (stringDicData != nil) {
		NSMutableDictionary * dicForScreen = [stringDicData objectForKey:screenName];
		
		value = [[dicForScreen objectForKey:strID] copy];
	}
	
	return value;
}




#pragma mark --
#pragma mark -- Alert View --

- (void) showAlertWithTitle:(NSString *)title
                    message:(NSString *)message
                   receiver:(id)receiver
          cancelButtonTitle:(NSString *)cancelButtonTitle
               otherButtons:(NSArray *)titles
{
	UIAlertView * alertview = [[UIAlertView alloc] initWithTitle:title
														 message:message
														delegate:receiver
											   cancelButtonTitle:cancelButtonTitle
											   otherButtonTitles:nil];
	if (titles) {
		for (int i = 0; i < [titles count]; i++) {
			[alertview addButtonWithTitle:[titles objectAtIndex:i]];
		}
	}
	
	[alertview show];
}


#pragma mark --
#pragma mark -- Utility Methods to get Height or Width of Text --

- (float) getRealWidthFrom:(float)height
                   content:(NSString *)content
                  fontname:(NSString *)fontname
                  fontsize:(float)fontsize
             lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	UIFont *textFont = [UIFont fontWithName:fontname size:fontsize];
	
	return [self getRealWidthFrom:height content:content font:textFont lineBreakMode:lineBreakMode];
}



- (float) getRealHeightFrom:(float)width
                    content:(NSString *)content
                   fontname:(NSString *)fontname
                   fontsize:(float)fontsize
              lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	UIFont *textFont = [UIFont fontWithName:fontname size:fontsize];
	
	return [self getRealHeightFrom:width content:content font:textFont lineBreakMode:lineBreakMode];
}


- (float) getRealWidthFrom:(float)height
                   content:(NSString *)content
                      font:(UIFont *)font
             lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	CGSize size = CGSizeMake(320, height);
//	CGSize textSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:lineBreakMode];
	
    NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGSize textSize = [content boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attributesDictionary
                                            context:nil].size;
	return textSize.width;
}


- (float) getRealHeightFrom:(float)width
                    content:(NSString *)content
                       font:(UIFont *)font
              lineBreakMode:(NSLineBreakMode)lineBreakMode
{
	CGSize size = CGSizeMake(width, 1000);
    
	NSDictionary *attributesDictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                          font, NSFontAttributeName,
                                          nil];
    CGSize textSize = [content boundingRectWithSize:size
                                            options:NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading
                                         attributes:attributesDictionary
                                            context:nil].size;
	
	return textSize.height;
}


@end
