//
//  InviteItemData.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "InviteItemData.h"

@implementation InviteItemData

- (id) initWithName:(NSString *)name addr:(NSString *)addr photo:(NSString *)photo
{
    if ((self = [super init])) {
        _strName = name;
        _strAddr = addr;
        _strPhoto= photo;
    }
    
    return self;
}


@end
