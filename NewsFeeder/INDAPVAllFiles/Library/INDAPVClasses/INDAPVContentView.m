
/********************************************************************************\
 *
 * File Name       INDAPVContentView.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "Constant.h"
#import "INDAPVContentView.h"
#import "INDAPVContentPage.h"
#import "INDAPVPreviewCache.h"

#import <QuartzCore/QuartzCore.h>

@implementation INDAPVContentView

#pragma mark Constants

#define ZOOM_LEVELS 4

#if (kApp_PDF_View_Shadow == TRUE) // Option
	#define CONTENT_INSET 4.0f
#else
	#define CONTENT_INSET 2.0f
#endif // end of kApp_PDF_View_Shadow Option

#define PAGE_THUMB_LARGE 240
#define PAGE_THUMB_SMALL 144

#pragma mark Properties

@synthesize message;

#pragma mark INDAPVContentView functions

static inline CGFloat ZoomScaleThatFits(CGSize target, CGSize source)
{
	CGFloat w_scale = (target.width / source.width);
	CGFloat h_scale = (target.height / source.height);

	return ((w_scale < h_scale) ? w_scale : h_scale);
}

#pragma mark INDAPVContentView instance methods

- (void)updateMinimumMaximumZoom
{
	CGRect targetRect = CGRectInset(self.bounds, CONTENT_INSET, CONTENT_INSET);

	CGFloat zoomScale = ZoomScaleThatFits(targetRect.size, theContentView.bounds.size);

	self.minimumZoomScale = zoomScale; // Set the minimum and maximum zoom scales

	self.maximumZoomScale = (zoomScale * ZOOM_LEVELS); // Max number of zoom levels

	zoomAmount = ((self.maximumZoomScale - self.minimumZoomScale) / ZOOM_LEVELS);
}

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase
{
 

	if ((self = [super initWithFrame:frame]))
	{
		self.scrollsToTop = NO;
		self.delaysContentTouches = NO;
		self.showsVerticalScrollIndicator = NO;
		self.showsHorizontalScrollIndicator = NO;
		self.contentMode = UIViewContentModeRedraw;
		self.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		self.backgroundColor = [UIColor clearColor];
        
		self.userInteractionEnabled = YES;
		self.autoresizesSubviews = NO;
		self.bouncesZoom = YES;
		self.delegate = self;

		theContentView = [[INDAPVContentPage alloc] initWithURL:fileURL page:page password:phrase];
        

		if (theContentView != nil) // Must have a valid and initialized content view
		{
			theContainerView = [[UIView alloc] initWithFrame:theContentView.bounds];

			theContainerView.autoresizesSubviews = NO;
			theContainerView.userInteractionEnabled = NO;
			theContainerView.contentMode = UIViewContentModeRedraw;
			theContainerView.autoresizingMask = UIViewAutoresizingNone;
			theContainerView.backgroundColor = [UIColor whiteColor];

#if (kApp_PDF_View_Shadow == TRUE) // Option

			theContainerView.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
			theContainerView.layer.shadowRadius = 4.0f; theContainerView.layer.shadowOpacity = 1.0f;
			theContainerView.layer.shadowPath = [UIBezierPath bezierPathWithRect:theContainerView.bounds].CGPath;

#endif // end of kApp_PDF_View_Shadow Option

			self.contentSize = theContentView.bounds.size; // Content size same as view size
			self.contentOffset = CGPointMake((0.0f - CONTENT_INSET), (0.0f - CONTENT_INSET)); // Offset
			self.contentInset = UIEdgeInsetsMake(CONTENT_INSET, CONTENT_INSET, CONTENT_INSET, CONTENT_INSET);

			theThumbView = [[INDAPVContentThumb alloc] initWithFrame:theContentView.bounds]; // Page thumb view

			[theContainerView addSubview:theThumbView]; // Add the thumb view to the container view

			[theContainerView addSubview:theContentView]; // Add the content view to the container view

			[self addSubview:theContainerView]; // Add the container view to the scroll view

			[self updateMinimumMaximumZoom]; // Update the minimum and maximum zoom scales

			self.zoomScale = self.minimumZoomScale; // Set zoom to fit page content

		}

		[self addObserver:self forKeyPath:@"frame" options:NSKeyValueObservingOptionNew context:NULL];

		self.tag = page; // Tag the view with the page number
	}

	return self;
}

- (void)dealloc
{
 

	[self removeObserver:self forKeyPath:@"frame"];

	[theContainerView release], theContainerView = nil;

	[theContentView release], theContentView = nil;

	[theThumbView release], theThumbView = nil;

	[super dealloc];
}

- (void)showPageThumb:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase guid:(NSString *)guid
{
	BOOL large = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad); // Page thumb size

	CGSize size = (large ? CGSizeMake(PAGE_THUMB_LARGE, PAGE_THUMB_LARGE) : CGSizeMake(PAGE_THUMB_SMALL, PAGE_THUMB_SMALL));

    //NSLog(@"showPageThumb page :%d",page);
	INDAPVPreviewRequest *request = [INDAPVPreviewRequest forView:theThumbView fileURL:fileURL password:phrase guid:guid page:page size:size];

	UIImage *image = [[INDAPVPreviewCache sharedInstance] thumbRequest:request priority:YES]; // Request the page thumb

	if ([image isKindOfClass:[UIImage class]]) [theThumbView showImage:image]; // Show image from cache
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
 

	if ((object == self) && [keyPath isEqualToString:@"frame"])
	{
		CGFloat oldMinimumZoomScale = self.minimumZoomScale;

		[self updateMinimumMaximumZoom]; // Update zoom scale limits

		if (self.zoomScale == oldMinimumZoomScale) // Old minimum
		{
			self.zoomScale = self.minimumZoomScale;
		}
		else // Check against minimum zoom scale
		{
			if (self.zoomScale < self.minimumZoomScale)
			{
				self.zoomScale = self.minimumZoomScale;
			}
			else // Check against maximum zoom scale
			{
				if (self.zoomScale > self.maximumZoomScale)
				{
					self.zoomScale = self.maximumZoomScale;
				}
			}
		}
	}
}

- (void)layoutSubviews
{
 

	[super layoutSubviews];

	CGSize boundsSize = self.bounds.size;
	CGRect viewFrame = theContainerView.frame;

	if (viewFrame.size.width < boundsSize.width)
		viewFrame.origin.x = (((boundsSize.width - viewFrame.size.width) / 2.0f) + self.contentOffset.x);
	else
		viewFrame.origin.x = 0.0f;

	if (viewFrame.size.height < boundsSize.height)
		viewFrame.origin.y = (((boundsSize.height - viewFrame.size.height) / 2.0f) + self.contentOffset.y);
	else
		viewFrame.origin.y = 0.0f;

	theContainerView.frame = viewFrame;
}

- (id)singleTap:(UITapGestureRecognizer *)recognizer
{
 

	return [theContentView singleTap:recognizer];
}

- (void)zoomIncrement
{
 

	CGFloat zoomScale = self.zoomScale;

	if (zoomScale < self.maximumZoomScale)
	{
		zoomScale += zoomAmount; // += value

		if (zoomScale > self.maximumZoomScale)
		{
			zoomScale = self.maximumZoomScale;
		}

		[self setZoomScale:zoomScale animated:YES];
	}
}

- (void)zoomDecrement
{
 

	CGFloat zoomScale = self.zoomScale;

	if (zoomScale > self.minimumZoomScale)
	{
		zoomScale -= zoomAmount; // -= value

		if (zoomScale < self.minimumZoomScale)
		{
			zoomScale = self.minimumZoomScale;
		}

		[self setZoomScale:zoomScale animated:YES];
	}
}

- (void)zoomReset
{
 

	if (self.zoomScale > self.minimumZoomScale)
	{
		self.zoomScale = self.minimumZoomScale;
	}
}

#pragma mark UIScrollViewDelegate methods

- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView
{
	return theContainerView;
}

#pragma mark UIResponder instance methods

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesBegan:touches withEvent:event]; // Message superclass

	[message contentView:self touchesBegan:touches]; // Message delegate
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesCancelled:touches withEvent:event]; // Message superclass
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesEnded:touches withEvent:event]; // Message superclass
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	[super touchesMoved:touches withEvent:event]; // Message superclass
}

@end

#pragma mark - INDAPVContentThumb class implementation


@implementation INDAPVContentThumb


#pragma mark INDAPVContentThumb instance methods

- (id)initWithFrame:(CGRect)frame
{
 

	if ((self = [super initWithFrame:frame])) // Superclass init
	{
		imageView.contentMode = UIViewContentModeScaleAspectFill;

		imageView.clipsToBounds = YES; // Needed for aspect fill
	}

	return self;
}

@end
