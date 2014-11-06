
/********************************************************************************\
 *
 * File Name       INDAPVPreviews.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

#import "INDAPVPreview.h"

@class INDAPVPreviews;

@protocol INDAPVPreviewDelegate <NSObject, UIScrollViewDelegate>

@required // Delegate protocols

- (NSUInteger)numberOfThumbsInThumbsView:(INDAPVPreviews *)thumbsView;

- (id)thumbsView:(INDAPVPreviews *)thumbsView thumbCellWithFrame:(CGRect)frame;

- (void)thumbsView:(INDAPVPreviews *)thumbsView updateThumbCell:(id)thumbCell forIndex:(NSInteger)index;

- (void)thumbsView:(INDAPVPreviews *)thumbsView didSelectThumbWithIndex:(NSInteger)index;

@optional // Delegate protocols

- (void)thumbsView:(INDAPVPreviews *)thumbsView refreshThumbCell:(id)thumbCell forIndex:(NSInteger)index;

- (void)thumbsView:(INDAPVPreviews *)thumbsView didPressThumbWithIndex:(NSInteger)index;

@end

@interface INDAPVPreviews : UIScrollView <UIScrollViewDelegate, UIGestureRecognizerDelegate>
{
@private // Instance variables

	CGPoint lastContentOffset;

	INDAPVPreview *touchedCell;

	NSMutableArray *thumbCellsQueue;

	NSMutableArray *thumbCellsVisible;

	NSInteger _thumbsX, _thumbsY, _thumbX;

	CGSize _thumbSize, _lastViewSize;

	NSUInteger _thumbCount;

	BOOL canUpdate;
}

@property (nonatomic, assign, readwrite) id <INDAPVPreviewDelegate> delegate;

- (void)setThumbSize:(CGSize)thumbSize;

- (void)reloadThumbsCenterOnIndex:(NSInteger)index;

- (void)reloadThumbsContentOffset:(CGPoint)newContentOffset;

- (void)refreshThumbWithIndex:(NSInteger)index;

- (void)refreshVisibleThumbs;

- (CGPoint)insetContentOffset;

@end
