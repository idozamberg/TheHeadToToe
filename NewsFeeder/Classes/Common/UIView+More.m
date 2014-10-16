//
//  UIView+More.m
//  MansionEscape
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/16/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "UIView+More.h"
#import <QuartzCore/QuartzCore.h>

@implementation UIView(More)

- (void) setRoundedCornersWithRadius:(float)radius
                         borderWidth:(float)borderWidth
                         borderColor:(UIColor *)borderColor
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderWidth = borderWidth;
    self.layer.borderColor = borderColor.CGColor;
}

@end
