//
//  UIHelper.m
//  HeadToToe
//
//  Created by ido zamberg on 10/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "UIHelper.h"

@implementation UIHelper

+ (NSMutableDictionary*) dictionaryFromPlistWithName : (NSString*) plistName
{
    // Getting files's path
    NSString *dataPath = [[NSBundle mainBundle] pathForResource:plistName ofType:@"plist"];
    
    // Getting data from plist
    NSMutableDictionary* data = [NSMutableDictionary dictionaryWithContentsOfFile:dataPath];
    
    return data;
}

+ (NSArray*) seprateStringsWithString : (NSString*) stringToSeparate
{
    NSArray* strings = [stringToSeparate componentsSeparatedByString:@","];
    
    return strings;
}

@end
