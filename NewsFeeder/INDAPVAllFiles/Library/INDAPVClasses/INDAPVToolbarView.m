
/********************************************************************************\
 *
 * File Name       INDAPVToolbarView.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVToolbarView.h"

#import <QuartzCore/QuartzCore.h>

@implementation INDAPVToolbarView

#pragma mark UIXToolbarView class methods

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

#pragma mark UIXToolbarView instance methods

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = YES;
		self.userInteractionEnabled = YES;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_White.png"]];
        
        int aIntNavBarHeight=0;
        if((([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0))
            aIntNavBarHeight=60;
        else
            aIntNavBarHeight=44;
        
        [self setFrame:CGRectMake(0, 0, self.frame.size.width, aIntNavBarHeight+appDelObj.intIOS7)];
        
		CGRect shadowRect = self.bounds; shadowRect.origin.y += shadowRect.size.height; shadowRect.size.height = 4.0f;
        
		UIXToolbarShadow *shadowView = [[UIXToolbarShadow alloc] initWithFrame:shadowRect];
		[self addSubview:shadowView];
        [shadowView release];
	}
	return self;}

- (void)dealloc
{
	[super dealloc];
}

@end

#pragma mark -	UIXToolbarShadow class implementation

@implementation UIXToolbarShadow

#pragma mark - UIXToolbarShadow class methods

+ (Class)layerClass
{
	return [CAGradientLayer class];
}

#pragma mark - UIXToolbarShadow instance methods

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = NO;
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.backgroundColor = [UIColor clearColor];
		CAGradientLayer *layer = (CAGradientLayer *)self.layer;
		CGColorRef blackColor = [UIColor colorWithWhite:0.24f alpha:1.0f].CGColor;
		CGColorRef clearColor = [UIColor colorWithWhite:0.24f alpha:0.0f].CGColor;
		layer.colors = [NSArray arrayWithObjects:(id)blackColor, (id)clearColor, nil];
	}
	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
