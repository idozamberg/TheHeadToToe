
/********************************************************************************\
 *
 * File Name       INDAPVPreviewFetch.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVPreviewFetch.h"
#import "INDAPVPreviewRender.h"
#import "INDAPVPreviewCache.h"
#import "INDAPVPreview.h"

#import <ImageIO/ImageIO.h>

@implementation INDAPVPreviewFetch

#pragma mark INDAPVPreviewFetch instance methods

- (id)initWithRequest:(INDAPVPreviewRequest *)object
{
	if ((self = [super initWithGUID:object.guid]))
	{
		request = [object retain];
	}

	return self;
}

- (void)dealloc
{
 	if (request.thumbView.operation == self)
	{
		request.thumbView.operation = nil; // Done
	}

	[request release], request = nil;

	[super dealloc];
}

- (void)cancel
{
 	[[INDAPVPreviewCache sharedInstance] removeNullForKey:request.cacheKey];

	[super cancel];
}

- (NSURL *)thumbFileURL
{

	NSString *cachePath = [INDAPVPreviewCache thumbCachePathForGUID:request.guid]; // Thumb cache path

	NSString *fileName = [NSString stringWithFormat:@"%@.png", request.thumbName]; // Thumb file name

	return [NSURL fileURLWithPath:[cachePath stringByAppendingPathComponent:fileName]]; // File URL
}

- (void)main
{
    if (self.isCancelled == YES) return;

	[[NSThread currentThread] setName:@"INDAPVPreviewFetch"];

	NSURL *thumbURL = [self thumbFileURL]; CGImageRef imageRef = NULL;

	CGImageSourceRef loadRef = CGImageSourceCreateWithURL((CFURLRef)thumbURL, NULL);

	if (loadRef != NULL) // Load the existing thumb image
	{
		imageRef = CGImageSourceCreateImageAtIndex(loadRef, 0, NULL); // Load it

		CFRelease(loadRef); // Release CGImageSource reference
	}
	else // Existing thumb image not found - so create and queue up a thumb render operation on the work queue
	{
		INDAPVPreviewRender *thumbRender = [[INDAPVPreviewRender alloc] initWithRequest:request]; // Create a thumb render operation

		[thumbRender setQueuePriority:self.queuePriority]; [thumbRender setThreadPriority:(self.threadPriority - 0.1)]; // Priority

		if (self.isCancelled == NO) // We're not cancelled - so update things and add the render operation to the work queue
		{
			request.thumbView.operation = thumbRender; // Update the thumb view operation property to the new operation

			[[INDAPVPreviewQueue sharedInstance] addWorkOperation:thumbRender]; // Queue the operation
		}

		[thumbRender release]; // Release INDAPVPreviewFetch object
	}

	if (imageRef != NULL) // Create UIImage from CGImage and show it
	{
		UIImage *image = [UIImage imageWithCGImage:imageRef scale:request.scale orientation:0];

		CGImageRelease(imageRef); // Release the CGImage reference from the above thumb load code

		[[INDAPVPreviewCache sharedInstance] setObject:image forKey:request.cacheKey]; // Update cache

		if (self.isCancelled == NO) // Show the image in the target thumb view on the main thread
		{
			INDAPVPreview *thumbView = request.thumbView; // Target thumb view for image show

			NSUInteger targetTag = request.targetTag; // Target reference tag for image show

			dispatch_async(dispatch_get_main_queue(), // Queue image show on main thread
			^{
				if (thumbView.targetTag == targetTag) [thumbView showImage:image];
			});
		}
	}
}

@end
