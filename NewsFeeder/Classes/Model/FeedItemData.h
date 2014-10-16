//
//  FeedItemData.h
//  NewsFeeder
//
//  Created by Cristian Ronaldo on 10/7/13.
//  Copyright (c) 2013 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FeedItemData : NSObject {
    ;
}
@property (nonatomic, strong) NSString * strName;
@property (nonatomic, strong) NSString * strDesc;
@property (nonatomic, strong) NSString * strPhoto;

- (id) initWithName:(NSString *)name desc:(NSString *)desc photo:(NSString *)photo;

@end
