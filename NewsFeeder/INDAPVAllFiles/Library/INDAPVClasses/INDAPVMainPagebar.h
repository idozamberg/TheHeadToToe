
/********************************************************************************\
 *
 * File Name       INDAPVMainPagebar.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>

#import "INDAPVPreview.h"

@class INDAPVMainPagebar;
@class INDAPVTrackControl;
@class INDAPVPagebarThumb;
@class INDAPVDocument;

@protocol INDAPVMainPagebarDelegate <NSObject>

@required // Delegate protocols

- (void)pagebar:(INDAPVMainPagebar *)pagebar gotoPage:(NSInteger)page;

@end

@interface INDAPVMainPagebar : UIView
{
@private // Instance variables

	INDAPVDocument *document;

	INDAPVTrackControl *trackControl;

	NSMutableDictionary *miniThumbViews;

	INDAPVPagebarThumb *pageThumbView;

	UILabel *pageNumberLabel;

	UIView *pageNumberView;

	NSTimer *enableTimer;
	NSTimer *trackTimer;
}

@property (nonatomic, assign, readwrite) id <INDAPVMainPagebarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame document:(INDAPVDocument *)object;

- (void)updatePagebar;

- (void)hidePagebar;
- (void)showPagebar;

@end

#pragma mark -	INDAPVTrackControl class interface


@interface INDAPVTrackControl : UIControl
{
@private // Instance variables

	CGFloat _value;
}

@property (nonatomic, assign, readonly) CGFloat value;

@end

#pragma mark -	INDAPVPagebarThumb class interface


@interface INDAPVPagebarThumb : INDAPVPreview
{
@private // Instance variables
}

- (id)initWithFrame:(CGRect)frame small:(BOOL)small;

@end

#pragma mark -	INDAPVPagebarShadow class interface


@interface INDAPVPagebarShadow : UIView
{
@private // Instance variables
}

@end
