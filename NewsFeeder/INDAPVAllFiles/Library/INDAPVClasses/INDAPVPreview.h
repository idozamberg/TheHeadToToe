
/********************************************************************************\
 *
 * File Name       INDAPVPreview.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

@interface INDAPVPreview : UIView
{
@private // Instance variables

	NSUInteger _targetTag;

	NSOperation *_operation;

@protected // Instance variables

	UIImageView *imageView;
}

@property (assign, readwrite) NSOperation *operation;

@property (nonatomic, assign, readwrite) NSUInteger targetTag;

- (void)showImage:(UIImage *)image;

- (void)showTouched:(BOOL)touched;

- (void)reuse;

@end
