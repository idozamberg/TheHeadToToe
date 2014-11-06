
/********************************************************************************\
 *
 * File Name       INDAPVPreviewQueue.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "INDAPVPreviewQueue.h"

@implementation INDAPVPreviewQueue

#pragma mark INDAPVPreviewQueue class methods

+ (INDAPVPreviewQueue *)sharedInstance
{
	static dispatch_once_t predicate = 0;

	static INDAPVPreviewQueue *object = nil; // Object

	dispatch_once(&predicate, ^{ object = [self new]; });

	return object; // INDAPVPreviewQueue singleton
}

#pragma mark INDAPVPreviewQueue instance methods

- (id)init
{
	if ((self = [super init])) // Initialize
	{
		loadQueue = [NSOperationQueue new];

		[loadQueue setName:@"ReaderThumbLoadQueue"];

		[loadQueue setMaxConcurrentOperationCount:1];

		workQueue = [NSOperationQueue new];

		[workQueue setName:@"ReaderThumbWorkQueue"];

		[workQueue setMaxConcurrentOperationCount:1];
	}

	return self;
}

- (void)dealloc
{
	[loadQueue release], loadQueue = nil;

	[workQueue release], workQueue = nil;

	[super dealloc];
}

- (void)addLoadOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[INDAPVThumbOperation class]])
	{
		[loadQueue addOperation:operation]; // Add to load queue
	}
}

- (void)addWorkOperation:(NSOperation *)operation
{
	if ([operation isKindOfClass:[INDAPVThumbOperation class]])
	{
		[workQueue addOperation:operation]; // Add to work queue
	}
}

- (void)cancelOperationsWithGUID:(NSString *)guid
{
	[loadQueue setSuspended:YES]; [workQueue setSuspended:YES];

	for (INDAPVThumbOperation *operation in loadQueue.operations)
	{
		if ([operation isKindOfClass:[INDAPVThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	for (INDAPVThumbOperation *operation in workQueue.operations)
	{
		if ([operation isKindOfClass:[INDAPVThumbOperation class]])
		{
			if ([operation.guid isEqualToString:guid]) [operation cancel];
		}
	}

	[workQueue setSuspended:NO]; [loadQueue setSuspended:NO];
}

- (void)cancelAllOperations
{
 	[loadQueue cancelAllOperations]; [workQueue cancelAllOperations];
}

@end

#pragma mark -	INDAPVThumbOperation class implementation


@implementation INDAPVThumbOperation

@synthesize guid = _guid;

#pragma mark INDAPVThumbOperation instance methods

- (id)initWithGUID:(NSString *)guid
{
	if ((self = [super init]))
	{
		_guid = [guid retain];
	}

	return self;
}

- (void)dealloc
{
	[_guid release], _guid = nil;

	[super dealloc];
}

@end
