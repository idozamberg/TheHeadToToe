//
//  SearchOperation.h
//  HeadToToe
//
//  Created by ido zamberg on 06/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol searchProtocol <NSObject>

- (void) searchDidFinishedWithArray : (NSMutableArray*) array;

@end

@interface SearchOperation : NSOperation

- (id) initWithSearchString : (NSString*) string;

@property (nonatomic,assign) id <searchProtocol> delegate;

@end
