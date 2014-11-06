
/********************************************************************************\
 *
 * File Name       INDAPVPreviewQueue.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <Foundation/Foundation.h>

@interface INDAPVPreviewQueue : NSObject
{
@private // Instance variables

	NSOperationQueue *loadQueue;

	NSOperationQueue *workQueue;
}

+ (INDAPVPreviewQueue *)sharedInstance;

- (void)addLoadOperation:(NSOperation *)operation;

- (void)addWorkOperation:(NSOperation *)operation;

- (void)cancelOperationsWithGUID:(NSString *)guid;

- (void)cancelAllOperations;

@end

#pragma mark -	INDAPVThumbOperation class interface


@interface INDAPVThumbOperation : NSOperation
{
@protected // Instance variables

	NSString *_guid;
}

@property (nonatomic, retain, readonly) NSString *guid;

- (id)initWithGUID:(NSString *)guid;

@end
