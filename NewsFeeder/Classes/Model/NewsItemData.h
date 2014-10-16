//
//  NewsItemData.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsItemData : NSObject {
    
}
@property (nonatomic, strong) NSString * strName;
@property (nonatomic) int subscribers;
@property (nonatomic, strong) NSString * strPhoto;

- (id) initWithName:(NSString *)name subs:(int)subs photo:(NSString *)photo;

@end
