//
//  SuperView.m
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperView.h"


@implementation SuperView



- (SuperView *) viewFromStoryboard
{
    return [SuperView viewFromStoryboard:NSStringFromClass([self class])];
}

+ (id)viewFromStoryboard:(NSString *)storyboardID
{
	UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:storyboardID];
	
	SuperView * vw = (SuperView *)(controller.view);
    [vw initialize];
	return vw;
}


- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code.
    }
    return self;
}

- (void) initialize
{
    ;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code.
}
*/

- (void) resize
{
    ;
}


@end
