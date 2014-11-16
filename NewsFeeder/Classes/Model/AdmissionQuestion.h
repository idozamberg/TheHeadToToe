//
//  AdmissionQuestion.h
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdmissionQuestion : NSObject <NSCopying>

@property (nonatomic,strong) NSString* text;
@property (nonatomic,strong) NSString* nonCheckedText;
@property (nonatomic,strong) NSString* checkedText;
@property (nonatomic)        BOOL      wasChecked;
@property (nonatomic,strong) NSString* comment;
@property (nonatomic,strong) NSString* questionSection;
@end
