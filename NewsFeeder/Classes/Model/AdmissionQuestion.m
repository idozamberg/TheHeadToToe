//
//  AdmissionQuestion.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "AdmissionQuestion.h"

@implementation AdmissionQuestion

@synthesize text,comment,wasChecked;

- (id)copyWithZone:(NSZone *)zone
{
    AdmissionQuestion* newQuestion = [AdmissionQuestion new];
    newQuestion.text = [self.text copyWithZone:zone];
    newQuestion.comment = [self.text copyWithZone:zone];
    newQuestion.wasChecked = NO;
    
    return newQuestion;
}

@end
