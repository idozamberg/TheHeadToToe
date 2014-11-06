
/********************************************************************************\
 *
 * File Name       INDAPVPreviewRequest.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "INDAPVPreviewRequest.h"
#import "INDAPVPreview.h"

@implementation INDAPVPreviewRequest

#pragma mark Properties

@synthesize guid = _guid;
@synthesize fileURL = _fileURL;
@synthesize password = _password;
@synthesize thumbView = _thumbView;
@synthesize thumbPage = _thumbPage;
@synthesize thumbSize = _thumbSize;
@synthesize thumbName = _thumbName;
@synthesize targetTag = _targetTag;
@synthesize cacheKey = _cacheKey;
@synthesize scale = _scale;

#pragma mark INDAPVPreviewRequest class methods

+ (id)forView:(INDAPVPreview *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size
{
    //NSLog(@"forView page :%d",page);
	return [[[INDAPVPreviewRequest alloc] initWithView:view fileURL:url password:phrase guid:guid page:page size:size] autorelease];
}

#pragma mark INDAPVPreviewRequest instance methods

- (id)initWithView:(INDAPVPreview *)view fileURL:(NSURL *)url password:(NSString *)phrase guid:(NSString *)guid page:(NSInteger)page size:(CGSize)size
{
	if ((self = [super init])) // Initialize object
	{
		NSInteger w = size.width; NSInteger h = size.height;

         //NSLog(@"initWithView page :%d",page);
		_thumbView = [view retain]; _thumbPage = page; _thumbSize = size;

		_fileURL = [url copy]; _password = [phrase copy]; _guid = [guid copy];

		_thumbName = [[NSString alloc] initWithFormat:@"%07d-%04dx%04d", page, w, h];

		_cacheKey = [[NSString alloc] initWithFormat:@"%@+%@", _thumbName, _guid];

		_targetTag = [_cacheKey hash]; _thumbView.targetTag = _targetTag;

		_scale = [[UIScreen mainScreen] scale]; // Thumb screen scale
	}

	return self;
}

- (void)dealloc
{
	[_guid release], _guid = nil;

	[_fileURL release], _fileURL = nil;

	[_password release], _password = nil;

	[_thumbView release], _thumbView = nil;

	[_thumbName release], _thumbName = nil;

	[_cacheKey release], _cacheKey = nil;

	[super dealloc];
}

@end
