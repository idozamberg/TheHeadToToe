
/********************************************************************************\
 *
 * File Name       INDAPVContentView.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

#import "INDAPVPreview.h"

@class INDAPVContentView;
@class INDAPVContentPage;
@class INDAPVContentThumb;

@protocol INDAPVContentViewDelegate <NSObject>

@required // Delegate protocols

- (void)contentView:(INDAPVContentView *)contentView touchesBegan:(NSSet *)touches;

@end

@interface INDAPVContentView : UIScrollView <UIScrollViewDelegate>
{
@private // Instance variables

	INDAPVContentPage *theContentView;

	INDAPVContentThumb *theThumbView;

	UIView *theContainerView;

	CGFloat zoomAmount;
}

@property (nonatomic, assign, readwrite) id <INDAPVContentViewDelegate> message;

- (id)initWithFrame:(CGRect)frame fileURL:(NSURL *)fileURL page:(NSUInteger)page password:(NSString *)phrase;

- (void)showPageThumb:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase guid:(NSString *)guid;

- (id)singleTap:(UITapGestureRecognizer *)recognizer;

- (void)zoomIncrement;
- (void)zoomDecrement;
- (void)zoomReset;

@end



@interface INDAPVContentThumb : INDAPVPreview
{
@private // Instance variables
}

@end
