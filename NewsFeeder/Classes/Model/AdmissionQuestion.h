//
//  AdmissionQuestion.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdmissionQuestion : NSObject

@property (nonatomic,strong) NSString* text;
@property (nonatomic)        BOOL      wasChecked;
@property (nonatomic,strong) NSString* comment;

@end
