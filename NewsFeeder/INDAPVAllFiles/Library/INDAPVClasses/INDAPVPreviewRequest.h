
/********************************************************************************\
 *
 * File Name       INDAPVPreviewRequest.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

@class INDAPVPreview;

@interface INDAPVPreviewRequest : NSObject
{
@private // Instance variables

	NSURL *_fileURL;

	NSString *_guid;

	NSString *_password;

	NSString *_cacheKey;

	NSString *_thumbName;

	INDAPVPreview *_thumbView;

	NSUInteger _targetTag;

	NSInteger _thumbPage;

	CGSize _thumbSize;

	CGFloat _scale;
}

@property (nonatomic, retain, readonly) NSURL *fileURL;
@property (nonatomic, retain, readonly) NSString *guid;
@property (nonatomic, retain, readonly) NSString *password;
@property (nonatomic, retain, readonly) NSString *cacheKey;
@property (nonatomic, retain, readonly) NSString *thumbName;
@property (nonatomic, retain, readonly) INDAPVPreview *thumbView;
@property (nonatomic, assign, readonly) NSUInteger targetTag;
@property (nonatomic, assign, readonly) NSInteger thumbPage;
@property (nonatomic, assign, readonly) CGSize thumbSize;
@property (nonatomic, assign, readonly) CGFloat scale;

+ (id)forView:(INDAPVPreview *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size;

- (id)initWithView:(INDAPVPreview *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size;

@end
