//
//  NewsItemData.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "NewsItemData.h"

@implementation NewsItemData

- (id) initWithName:(NSString *)name subs:(int)subs photo:(NSString *)photo
{
    if ((self = [super init])) {
        _strName = name;
        _strPhoto = photo;
        _subscribers = subs;
    }
    
    return self;
}

@end
