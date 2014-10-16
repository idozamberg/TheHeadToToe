//
//  UIView+Framing.h
//  365Scores
//
//  Created by Asaf Shveki on 9/10/12.
//  Copyright (c) 2012 for-each. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Framing) <UIGestureRecognizerDelegate>



- (void) setWidth:(NSInteger) width;
- (void) setHeight:(NSInteger) height;
- (void) setXPosition:(NSInteger) x;
- (void) setYPosition:(NSInteger) y;
- (void) setPoint:(CGPoint) point;
- (void) setSize:(CGSize)size;



@end
