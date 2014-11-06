
/********************************************************************************\
 *
 * File Name       INDAPVPreviewsViewController.m 
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "Constant.h"
#import "INDAPVPreviewsViewController.h"
#import "INDAPVPreviewRequest.h"
#import "INDAPVPreviewCache.h"
#import "INDAPVDocument.h"

#import <QuartzCore/QuartzCore.h>

@implementation INDAPVPreviewsViewController

#pragma mark Constants

#define TOOLBAR_HEIGHT 44.0f

#define PAGE_THUMB_SMALL 160
#define PAGE_THUMB_LARGE 256

#pragma mark Properties

@synthesize delegate;

#pragma mark UIViewController methods

- (id)initWithReaderDocument:(INDAPVDocument *)object
{
	id thumbs = nil; // ThumbsViewController object

	if ((object != nil) && ([object isKindOfClass:[INDAPVDocument class]]))
	{
		if ((self = [super initWithNibName:nil bundle:nil])) // Designated initializer
		{
			updateBookmarked = YES; bookmarked = [NSMutableArray new]; // Bookmarked pages

			document = [object retain]; // Retain the INDAPVDocument object for our use

			thumbs = self; // Return an initialized ThumbsViewController object
		}
	}
	return thumbs;
}

- (void)viewDidLoad
{
	[super viewDidLoad];

    
	NSAssert(!(delegate == nil), @"delegate == nil");
	NSAssert(!(document == nil), @"INDAPVDocument == nil");
    
	//self.view.backgroundColor = [UIColor scrollViewTexturedBackgroundColor];//Y BG
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_Red.png"]];
    
	CGRect viewRect = self.view.bounds; // View controller's view bounds
	NSString *toolbarTitle = [document.fileName stringByDeletingPathExtension];
	CGRect toolbarRect = viewRect; toolbarRect.size.height = TOOLBAR_HEIGHT;
	mainToolbar = [[INDAPVPreviewsMainToolbar alloc] initWithFrame:toolbarRect title:toolbarTitle]; // At top
	mainToolbar.delegate = self;
	[self.view addSubview:mainToolbar];
	CGRect thumbsRect = viewRect; UIEdgeInsets insets = UIEdgeInsetsZero;

	if (isIpad())
	{
		thumbsRect.origin.y += TOOLBAR_HEIGHT; thumbsRect.size.height -= TOOLBAR_HEIGHT;
        
        //YP - (1-10-14) - New Code - SCrollView - Bookmark
        if(isIOS7())
        {
            insets = UIEdgeInsetsMake(0, 0.0, 40.0, 0.0);
        }
	}
	else // Set UIScrollView insets for non-UIUserInterfaceIdiomPad case
	{
		insets.top = TOOLBAR_HEIGHT;
        
        //YP - (1-10-14) - New Code - SCrollView - Bookmark
        if(isIOS7())
        {
            insets = UIEdgeInsetsMake(-20, 0.0, 60.0, 0.0);
        }
	}

    
    
//	theThumbsView = [[INDAPVPreviews alloc] initWithFrame:thumbsRect];
    theThumbsView = [[INDAPVPreviews alloc] initWithFrame:CGRectMake(self.view.frame.origin.x, TOOLBAR_HEIGHT+appDelObj.intIOS7, self.view.frame.size.width, self.view.frame.size.height)]; // Rest
    
    theThumbsView.contentInset = insets; theThumbsView.scrollIndicatorInsets = insets;
    
	theThumbsView.delegate = self;
	[self.view insertSubview:theThumbsView belowSubview:mainToolbar];

	BOOL large = ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad);
	NSInteger thumbSize = (large ? PAGE_THUMB_LARGE : PAGE_THUMB_SMALL); // Thumb dimensions
	[theThumbsView setThumbSize:CGSizeMake(thumbSize, thumbSize)]; // Thumb size based on device
    
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[theThumbsView reloadThumbsCenterOnIndex:([document.pageNumber integerValue] - 1)]; // Page
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
	[theThumbsView release], theThumbsView = nil;
	[mainToolbar release], mainToolbar = nil;
	[super viewDidUnload];
}


- (void)didReceiveMemoryWarning
{
	[super didReceiveMemoryWarning];
}

- (void)dealloc
{
	[bookmarked release], bookmarked = nil;
	[theThumbsView release], theThumbsView = nil;
	[mainToolbar release], mainToolbar = nil;
	[document release], document = nil;
	[super dealloc];
}

#pragma mark ThumbsMainToolbarDelegate methods

//- (void)tappedInToolbar:(ThumbsMainToolbar *)toolbar showControl:(UISegmentedControl *)control
- (void)tappedInToolbar:(INDAPVPreviewsMainToolbar *)toolbar showControl:(id)sender
{
    UIButton *aBtnRef=sender;
    if([aBtnRef tag]==5001)// Show all page thumbs
    {
       
        showBookmarked = NO; // Show all thumbs
       // aBtnRef.enabled=NO;
        markedOffset = [theThumbsView insetContentOffset];
        [theThumbsView reloadThumbsContentOffset:thumbsOffset];
        return;//y
        //break; // We're done
    }
    else// Show bookmarked thumbs
    {
        
        //aBtnRef.enabled=NO;
        showBookmarked = YES; // Only bookmarked
        thumbsOffset = [theThumbsView insetContentOffset];
        if (updateBookmarked == YES) // Update bookmarked list
        {
            [bookmarked removeAllObjects]; // Empty the list first
            [document.bookmarks enumerateIndexesUsingBlock: // Enumerate
             ^(NSUInteger page, BOOL *stop)
             {
                 [bookmarked addObject:[NSNumber numberWithInteger:page]];
             }
             ];
            markedOffset = CGPointZero; updateBookmarked = NO; // Reset
        }
        [theThumbsView reloadThumbsContentOffset:markedOffset];
        return;//y
        //break; // We're done
    }
}

- (void)tappedInToolbar:(INDAPVPreviewsMainToolbar *)toolbar doneButton:(UIButton *)button
{
	[delegate dismissThumbsViewController:self]; // Dismiss thumbs display
}

#pragma mark UIThumbsViewDelegate methods

- (NSUInteger)numberOfThumbsInThumbsView:(INDAPVPreviews *)thumbsView
{
	return (showBookmarked ? bookmarked.count : [document.pageCount integerValue]);
}

- (id)thumbsView:(INDAPVPreviews *)thumbsView thumbCellWithFrame:(CGRect)frame
{
	return [[[ThumbsPageThumb alloc] initWithFrame:frame] autorelease];
}

//YP - (1-10-14) - BP - BookMark Table

- (void)thumbsView:(INDAPVPreviews *)thumbsView updateThumbCell:(ThumbsPageThumb *)thumbCell forIndex:(NSInteger)index
{
	CGSize size = [thumbCell maximumContentSize]; // Get the cell's maximum content size
	NSInteger page = (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));
	[thumbCell showText:[NSString stringWithFormat:@"%d", page]]; // Page number place holder
	[thumbCell showBookmark:[document.bookmarks containsIndex:page]]; // Show bookmarked statu
	NSURL *fileURL = document.fileURL; NSString *guid = document.guid; NSString *phrase = document.password; // Document info
	INDAPVPreviewRequest *thumbRequest = [INDAPVPreviewRequest forView:thumbCell fileURL:fileURL password:phrase guid:guid page:page size:size];
	UIImage *image = [[INDAPVPreviewCache sharedInstance] thumbRequest:thumbRequest priority:YES]; // Request the thumbnail
	if ([image isKindOfClass:[UIImage class]]) [thumbCell showImage:image]; // Show image from cache
}

- (void)thumbsView:(INDAPVPreviews *)thumbsView refreshThumbCell:(ThumbsPageThumb *)thumbCell forIndex:(NSInteger)index
{
	NSInteger page = (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));
	[thumbCell showBookmark:[document.bookmarks containsIndex:page]]; // Show bookmarked status
}

- (void)thumbsView:(INDAPVPreviews *)thumbsView didSelectThumbWithIndex:(NSInteger)index
{
	NSInteger page = (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));
	[delegate thumbsViewController:self gotoPage:page]; // Show the selected page
	[delegate dismissThumbsViewController:self]; // Dismiss thumbs display
}

- (void)thumbsView:(INDAPVPreviews *)thumbsView didPressThumbWithIndex:(NSInteger)index
{
	NSInteger page = (showBookmarked ? [[bookmarked objectAtIndex:index] integerValue] : (index + 1));
	if ([document.bookmarks containsIndex:page]) [document.bookmarks removeIndex:page]; else [document.bookmarks addIndex:page];
	updateBookmarked = YES; [thumbsView refreshThumbWithIndex:index]; // Refresh page thumb
}
#pragma mark - Orientation Methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{ 
    [mainToolbar SetFramesForOrientation];
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
}



//End

@end

#pragma mark - ThumbsPageThumb class implementation


@implementation ThumbsPageThumb

#pragma mark Constants

#define CONTENT_INSET 8.0f

//#pragma mark Properties

//@synthesize ;

#pragma mark ThumbsPageThumb instance methods

- (CGRect)markRectInImageView
{
	CGRect iconRect = bookMark.frame; iconRect.origin.y = (-2.0f);
	iconRect.origin.x = (imageView.bounds.size.width - bookMark.image.size.width - 8.0f);
	return iconRect; // Frame position rect inside of image view
}

- (id)initWithFrame:(CGRect)frame
{
	if ((self = [super initWithFrame:frame]))
	{
		imageView.contentMode = UIViewContentModeCenter;
		defaultRect = CGRectInset(self.bounds, CONTENT_INSET, CONTENT_INSET);
		maximumSize = defaultRect.size; // Maximum thumb content size
		CGFloat newWidth = ((defaultRect.size.width / 4.0f) * 3.0f);
		CGFloat offsetX = ((defaultRect.size.width - newWidth) / 2.0f);
		defaultRect.size.width = newWidth; defaultRect.origin.x += offsetX;
		imageView.frame = defaultRect; // Update the image view frame
		CGFloat fontSize = (([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad) ? 19.0f : 16.0f);

		textLabel = [[UILabel alloc] initWithFrame:defaultRect];
		textLabel.autoresizesSubviews = NO;
		textLabel.userInteractionEnabled = NO;
		textLabel.contentMode = UIViewContentModeRedraw;
		textLabel.autoresizingMask = UIViewAutoresizingNone;
		textLabel.textAlignment = UITextAlignmentCenter;
		textLabel.font = [UIFont systemFontOfSize:fontSize];
		textLabel.textColor = [UIColor colorWithWhite:0.24f alpha:1.0f];
		textLabel.backgroundColor = [UIColor whiteColor];
		[self insertSubview:textLabel belowSubview:imageView];

		backView = [[UIView alloc] initWithFrame:defaultRect];
		backView.autoresizesSubviews = NO;
		backView.userInteractionEnabled = NO;
		backView.contentMode = UIViewContentModeRedraw;
		backView.autoresizingMask = UIViewAutoresizingNone;
		backView.backgroundColor = [UIColor whiteColor];

#if (kApp_PDF_View_Shadow == TRUE) // Option

		backView.layer.shadowOffset = CGSizeMake(0.0f, 1.0f);
		backView.layer.shadowRadius = 3.0f; backView.layer.shadowOpacity = 1.0f;
		backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of kApp_PDF_View_Shadow Option

		[self insertSubview:backView belowSubview:textLabel];
		maskView = [[UIView alloc] initWithFrame:imageView.bounds];
		maskView.hidden = YES;
		maskView.autoresizesSubviews = NO;
		maskView.userInteractionEnabled = NO;
		maskView.contentMode = UIViewContentModeRedraw;
		maskView.autoresizingMask = UIViewAutoresizingNone;
		maskView.backgroundColor = [UIColor colorWithWhite:0.0f alpha:0.25f];
		[imageView addSubview:maskView];

		UIImage *image = [UIImage imageNamed:@"Mark_Bookmark_S.png"];
		bookMark = [[UIImageView alloc] initWithImage:image];
		bookMark.hidden = YES;
		bookMark.autoresizesSubviews = NO;
		bookMark.userInteractionEnabled = NO;
		bookMark.contentMode = UIViewContentModeCenter;
		bookMark.autoresizingMask = UIViewAutoresizingNone;
		bookMark.frame = [self markRectInImageView];

		[imageView addSubview:bookMark];
	}
	return self;
}

- (void)dealloc
{
	[backView release], backView = nil;
	[maskView release], maskView = nil;
	[textLabel release], textLabel = nil;
	[bookMark release], bookMark = nil;
	[super dealloc];
}

- (CGSize)maximumContentSize
{
	return maximumSize;
}

- (void)showImage:(UIImage *)image
{
	NSInteger x = (self.bounds.size.width / 2.0f);
	NSInteger y = (self.bounds.size.height / 2.0f);
	CGPoint location = CGPointMake(x, y); // Center point
	CGRect viewRect = CGRectZero; viewRect.size = image.size;
    
	textLabel.bounds = viewRect; textLabel.center = location; // Position
	imageView.bounds = viewRect; imageView.center = location; imageView.image = image;
	bookMark.frame = [self markRectInImageView]; // Position bookmark image
	maskView.frame = imageView.bounds; backView.bounds = viewRect; backView.center = location;

#if (kApp_PDF_View_Shadow == TRUE) // Option

	backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of kApp_PDF_View_Shadow Option
}

- (void)reuse
{
	[super reuse]; // Reuse thumb view
	textLabel.text = nil; textLabel.frame = defaultRect;
	imageView.image = nil; imageView.frame = defaultRect;
	bookMark.hidden = YES; bookMark.frame = [self markRectInImageView];
	maskView.hidden = YES; maskView.frame = imageView.bounds; backView.frame = defaultRect;

#if (kApp_PDF_View_Shadow == TRUE) // Option

	backView.layer.shadowPath = [UIBezierPath bezierPathWithRect:backView.bounds].CGPath;

#endif // end of kApp_PDF_View_Shadow Option
}

- (void)showBookmark:(BOOL)show
{
	bookMark.hidden = (show ? NO : YES);
}

- (void)showTouched:(BOOL)touched
{
	maskView.hidden = (touched ? NO : YES);
}

- (void)showText:(NSString *)text
{
	textLabel.text = text;
}


@end
