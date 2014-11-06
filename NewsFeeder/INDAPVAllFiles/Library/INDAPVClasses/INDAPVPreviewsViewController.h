
/********************************************************************************\
 *
 * File Name       INDAPVPreviewsViewController.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/




#import <UIKit/UIKit.h>

#import "INDAPVPreviewsMainToolbar.h"
#import "INDAPVPreviews.h"

@class INDAPVPreviewsViewController;
@class INDAPVDocument;

@protocol INDAPVPreviewsViewControllerDelegate <NSObject>

@required // Delegate protocols

- (void)thumbsViewController:(INDAPVPreviewsViewController *)viewController gotoPage:(NSInteger)page;

- (void)dismissThumbsViewController:(INDAPVPreviewsViewController *)viewController;

@end

@interface INDAPVPreviewsViewController : UIViewController <INDAPVPreviewsMainToolbarDelegate, INDAPVPreviewDelegate>
{
@private // Instance variables

	INDAPVDocument *document;

	INDAPVPreviewsMainToolbar *mainToolbar;

	INDAPVPreviews *theThumbsView;

	NSMutableArray *bookmarked;

	BOOL updateBookmarked;

	CGPoint thumbsOffset;
	CGPoint markedOffset;

	BOOL showBookmarked;
}

@property (nonatomic, assign, readwrite) id <INDAPVPreviewsViewControllerDelegate> delegate;

- (id)initWithReaderDocument:(INDAPVDocument *)object;

@end

#pragma mark -	ThumbsPageThumb class interface


@interface ThumbsPageThumb : INDAPVPreview
{
@private // Instance variables

	UIView *backView;

	UIView *maskView;

	UILabel *textLabel;

	UIImageView *bookMark;

	CGSize maximumSize;

	CGRect defaultRect;
}

- (CGSize)maximumContentSize;

- (void)showText:(NSString *)text;

- (void)showBookmark:(BOOL)show;

@end
