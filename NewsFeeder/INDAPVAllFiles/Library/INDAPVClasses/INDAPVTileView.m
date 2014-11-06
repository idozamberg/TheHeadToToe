
/********************************************************************************\
 *
 * File Name       INDAPVTileView.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVTileView.h"

@implementation INDAPVTileView

#pragma mark Constants

#define LEVELS_OF_DETAIL 4
#define LEVELS_OF_DETAIL_BIAS 3

//#pragma mark Properties

//@synthesize ;

#pragma mark INDAPVTileView class methods

+ (CFTimeInterval)fadeDuration
{
	return 0.001; // iOS bug workaround

	//return 0.0; // No fading wanted
}

#pragma mark INDAPVTileView instance methods

- (id)init
{
	if ((self = [super init]))
	{
		self.levelsOfDetail = LEVELS_OF_DETAIL;

		self.levelsOfDetailBias = LEVELS_OF_DETAIL_BIAS;

		UIScreen *mainScreen = [UIScreen mainScreen]; // Screen

		CGFloat screenScale = [mainScreen scale]; // Screen scale

		CGRect screenBounds = [mainScreen bounds]; // Screen bounds

		CGFloat w_pixels = (screenBounds.size.width * screenScale);

		CGFloat h_pixels = (screenBounds.size.height * screenScale);

		CGFloat max = ((w_pixels < h_pixels) ? h_pixels : w_pixels);

		CGFloat sizeOfTiles = ((max < 512.0f) ? 512.0f : 1024.0f);

		self.tileSize = CGSizeMake(sizeOfTiles, sizeOfTiles);
	}

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

@end
