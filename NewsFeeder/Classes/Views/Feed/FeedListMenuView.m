//
//  FeedListMenuView.m
//  NewsFeeder
//
//  Created by Cristian Ronaldo on 10/27/13.
//  Copyright (c) 2013 Cristian Ronaldo. All rights reserved.
//

#import "FeedListMenuView.h"

@implementation FeedListMenuView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/


- (IBAction) button_click:(id)sender
{
    int index = [arrMenus indexOfObject:sender];
    
    if (index != NSNotFound) {
        if ([self.delegate respondsToSelector:@selector(didClickFeedListMenu:index:)]) {
            [self.delegate didClickFeedListMenu:self index:index];
        }
        
        [self hide];
    }
}

- (void) showWithTitles:(NSArray *)arrTitles
{
    if (arrMenus == nil) {
        arrMenus = [[NSMutableArray alloc] init];
    }
    else {
        for ( int i = 0; i < [arrMenus count]; i++ ) {
            UIButton * btn = [arrMenus objectAtIndex:i];
            [btn removeFromSuperview];
        }
        [arrMenus removeAllObjects];
    }
    
    
    if (arrTitles == nil || [arrTitles count] == 0) {
        return;
    }
    
    for ( int i = 0; i < [arrTitles count]; i++ ) {
        UIButton * btn = [UIButton buttonWithType:UIButtonTypeCustom];
        
        [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [btn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
        [btn setTitle:[arrTitles objectAtIndex:i] forState:UIControlStateNormal];
        [btn.titleLabel setFont:[UIFont fontWithName:@"Helvetica" size:20.0f]];
        [btn addTarget:self action:@selector(button_click:) forControlEvents:UIControlEventTouchUpInside];
        [btn setFrame:CGRectMake( 0, 49 * i, 320, 49 )];
        
        [self addSubview:btn];
        [arrMenus addObject:btn];
    }
    
    CGRect rt = self.frame;
    rt.size.height = 49 * [arrTitles count];
    [self setFrame:rt];
    
    [self show];
}


- (void) show
{
    CGRect frm = self.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    frm.origin.y = 64;
    [self setFrame:frm];
    
    [UIView commitAnimations];
}


- (void) hide
{
    CGRect frm = self.frame;
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    frm.origin.y = -1024;
    [self setFrame:frm];
    
    [UIView commitAnimations];

}


@end
