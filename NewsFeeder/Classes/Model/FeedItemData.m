//
//  FeedItemData.m
//  NewsFeeder
//
//  Created by Cristian Ronaldo on 10/7/13.
//  Copyright (c) 2013 Cristian Ronaldo. All rights reserved.
//

#import "FeedItemData.h"

@implementation FeedItemData


- (id) initWithName:(NSString *)name desc:(NSString *)desc photo:(NSString *)photo
{
    if ((self = [super init])) {
        _strName = name;
        _strDesc = desc;
        _strPhoto= photo;
    }
    
    return self;
}


@end
