/********************************************************************************\
 *
 * File Name       INDAPVSelection.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVSelection.h"
#import "INDAPVRenderingState.h"


@implementation INDAPVSelection

/* Rendering state represents opening (left) cap */
- (id)initWithStartState:(INDAPVRenderingState *)state
{
	if ((self = [super init]))
	{
		initialState = [state copy];
	}
	return self;
}

/* Rendering state represents closing (right) cap */
- (void)finalizeWithState:(INDAPVRenderingState *)state
{
	// Concatenate CTM onto text matrix
	transform = CGAffineTransformConcat([initialState textMatrix], [initialState ctm]);

	INDAPVFont *openingFont = [initialState font];
	INDAPVFont *closingFont = [state font];
	
	// Width (difference between caps) with text transformation removed
	CGFloat width = [state textMatrix].tx - [initialState textMatrix].tx;	
	width /= [state textMatrix].a;

	// Use tallest cap for entire selection
	CGFloat startHeight = [openingFont maxY] - [openingFont minY];
	CGFloat finishHeight = [closingFont maxY] - [closingFont minY];
	INDAPVRenderingState *s = (startHeight > finishHeight) ? initialState : state;

	INDAPVFont *font = [s font];
	INDAPVFontDescriptor *descriptor = [font fontDescriptor];
	
	// Height is ascent plus (negative) descent
	CGFloat height = [s convertToUserSpace:(font.maxY - font.minY)];

	// Descent
	CGFloat descent = [s convertToUserSpace:descriptor.descent];

	// Selection frame in text space
	frame = CGRectMake(0, descent, width, height);
	
//	[initialState release]; initialState = nil;
}


#pragma mark - Memory Management

- (void)dealloc
{
	[initialState release];
	[super dealloc];
}

@synthesize frame, transform;
@end
