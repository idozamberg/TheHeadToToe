//
//  HTTFavoriteFile.m
//  
//
//  Created by ido zamberg on 25/11/14.
//
//

#import "HTTFavoriteFile.h"

@implementation HTTFavoriteFile
@synthesize numberOfTimesFileWasOpened = _numberOfTimesFileWasOpened;

- (id) init
{
    self = [super init];
    
    if (self)
    {
        _numberOfTimesFileWasOpened = [NSNumber numberWithInteger:0];
    }
    
    return self;
}

- (id) initWithFile : (HTTFile*) file
{
    self = [super init];
    
    if (self)
    {
        self.name = file.name;
        self.system = file.system;
        self.fileDescription = file.fileDescription;
        _numberOfTimesFileWasOpened = [NSNumber numberWithInteger:1];
    }
    
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [super encodeWithCoder:aCoder];
    
    // Encoding objects
    [aCoder encodeObject:self.numberOfTimesFileWasOpened forKey:@"numberOfTimesFileWasOpened"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    
    if (self)
    {
        self.numberOfTimesFileWasOpened = [aDecoder decodeObjectForKey:@"numberOfTimesFileWasOpened"];
    }
    
    return self;
}
@end
