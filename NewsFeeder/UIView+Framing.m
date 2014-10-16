//
//  UIView+Framing.m
//  365Scores
//
//  Created by Asaf Shveki on 9/10/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import "UIView+Framing.h"
#import <objc/runtime.h>


@implementation UIView (Framing) 
- (void) setSize:(CGSize)size
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, size.width, size.height)];
}

- (void) setPoint:(CGPoint) point
{
    [self setFrame:CGRectMake(point.x, point.y, self.frame.size.width, self.frame.size.height)];
}

- (void) setYPosition:(NSInteger) y
{
    [self setFrame:CGRectMake(self.frame.origin.x, y, self.frame.size.width, self.frame.size.height)];
}

- (void) setXPosition:(NSInteger) x
{
    [self setFrame:CGRectMake(x, self.frame.origin.y, self.frame.size.width, self.frame.size.height)];
}

- (void) setHeight:(NSInteger) height
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, self.frame.size.width, height)];
}

- (void) setWidth:(NSInteger) width
{
    [self setFrame:CGRectMake(self.frame.origin.x, self.frame.origin.y, width, self.frame.size.height)];
}



@end
