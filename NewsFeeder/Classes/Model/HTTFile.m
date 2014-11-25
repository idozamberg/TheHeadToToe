//
//  HTTFile.m
//  HeadToToe
//
//  Created by ido zamberg on 10/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTFile.h"

@implementation HTTFile

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    // Encoding objects
    [aCoder encodeObject:self.system forKey:@"system"];
    [aCoder encodeObject:self.fileDescription forKey:@"fileDescription"];
    [aCoder encodeObject:self.name forKey:@"name"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    
    if (self)
    {
        self.name            = [aDecoder decodeObjectForKey:@"name"];
        self.fileDescription = [aDecoder decodeObjectForKey:@"fileDescription"];
        self.system          = [aDecoder decodeObjectForKey:@"system"];
    }
    
    return self;
}

@end
