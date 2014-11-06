
/********************************************************************************\
 *
 * File Name       INDAPVPreview.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "INDAPVPreview.h"

@implementation INDAPVPreview

#pragma mark Properties

@synthesize operation = _operation;
@synthesize targetTag = _targetTag;

#pragma mark INDAPVPreview instance methods

- (id)initWithFrame:(CGRect)frame
{
 

	if ((self = [super initWithFrame:frame]))
	{
		self.autoresizesSubviews = NO;
		self.userInteractionEnabled = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingNone;
		self.backgroundColor = [UIColor clearColor];
       
		imageView = [[UIImageView alloc] initWithFrame:self.bounds];

		imageView.autoresizesSubviews = NO;
		imageView.userInteractionEnabled = NO;
		imageView.contentMode = UIViewContentModeScaleAspectFit;
		imageView.autoresizingMask = UIViewAutoresizingNone;
		imageView.backgroundColor = [UIColor clearColor];

		[self addSubview:imageView];
	}

	return self;
}

- (void)dealloc
{
 

	[imageView release], imageView = nil;

	[super dealloc];
}

- (void)showImage:(UIImage *)image
{
 

	imageView.image = image; // Show image
}

- (void)showTouched:(BOOL)touched
{
 
}

- (void)removeFromSuperview
{
 

	_targetTag = 0; // Clear target tag

	[self.operation cancel], self.operation = nil;

	[super removeFromSuperview];
}

- (void)reuse
{
 

	_targetTag = 0; // Clear target tag

	[self.operation cancel], self.operation = nil;

	imageView.image = nil; // Release image
}

@end
