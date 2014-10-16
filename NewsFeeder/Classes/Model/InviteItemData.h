//
//  InviteItemData.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface InviteItemData : NSObject {
    
}
@property (nonatomic, strong) NSString * strName;
@property (nonatomic, strong) NSString * strAddr;
@property (nonatomic, strong) NSString * strPhoto;

- (id) initWithName:(NSString *)name addr:(NSString *)addr photo:(NSString *)photo;


@end
