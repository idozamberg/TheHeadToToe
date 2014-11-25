//
//  HTTFavoriteFile.h
//  
//
//  Created by ido zamberg on 25/11/14.
//
//

#import <Foundation/Foundation.h>
#import "HTTFile.h"

@interface HTTFavoriteFile : HTTFile <NSCoding>
@property (nonatomic,strong) NSNumber* numberOfTimesFileWasOpened;
- (id) initWithFile : (HTTFile*) file;

@end
