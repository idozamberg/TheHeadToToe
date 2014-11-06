
/********************************************************************************\
 *
 * File Name       INDAPVPreviewCache.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import "INDAPVPreviewCache.h"
#import "INDAPVPreviewQueue.h"
#import "INDAPVPreviewFetch.h"
#import "INDAPVPreview.h"

@implementation INDAPVPreviewCache

#pragma mark Constants

#define CACHE_SIZE 2097152


#pragma mark INDAPVPreviewCache class methods

+ (INDAPVPreviewCache *)sharedInstance
{
	static dispatch_once_t predicate = 0;

	static INDAPVPreviewCache *object = nil; // Object

	dispatch_once(&predicate, ^{ object = [self new]; });

	return object; // INDAPVPreviewCache singleton
}

+ (NSString *)appCachesPath
{
 	static dispatch_once_t predicate = 0;

	static NSString *theCachesPath = nil; // Application caches path string

	dispatch_once(&predicate, // Save a copy of the application caches path the first time it is needed
	^{
		NSArray *cachesPaths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);

		theCachesPath = [[cachesPaths objectAtIndex:0] copy]; // Keep a copy for later abusage
	});

	return theCachesPath;
}

+ (NSString *)thumbCachePathForGUID:(NSString *)guid
{
	NSString *cachesPath = [INDAPVPreviewCache appCachesPath]; // Caches path

	return [cachesPath stringByAppendingPathComponent:guid]; // Append GUID
}

+ (void)createThumbCacheWithGUID:(NSString *)guid
{
 	NSFileManager *fileManager = [NSFileManager new]; // File manager instance

	NSString *cachePath = [INDAPVPreviewCache thumbCachePathForGUID:guid]; // Thumb cache path

	[fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:NO attributes:nil error:NULL];

	[fileManager release]; // Cleanup file manager instance
}

+ (void)removeThumbCacheWithGUID:(NSString *)guid
{
	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
	^{
		NSFileManager *fileManager = [NSFileManager new]; // File manager instance

		NSString *cachePath = [INDAPVPreviewCache thumbCachePathForGUID:guid]; // Thumb cache path

		[fileManager removeItemAtPath:cachePath error:NULL]; // Remove thumb cache directory

		[fileManager release]; // Cleanup file manager instance
	});
}

+ (void)touchThumbCacheWithGUID:(NSString *)guid
{
	NSFileManager *fileManager = [NSFileManager new]; // File manager instance

	NSString *cachePath = [INDAPVPreviewCache thumbCachePathForGUID:guid]; // Thumb cache path

	NSDictionary *attributes = [NSDictionary dictionaryWithObject:[NSDate date] forKey:NSFileModificationDate];

	[fileManager setAttributes:attributes ofItemAtPath:cachePath error:NULL]; // New modification date

	[fileManager release]; // Cleanup file manager instance
}

+ (void)purgeThumbCachesOlderThan:(NSTimeInterval)age
{
 	dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, 0),
	^{
		NSDate *now = [NSDate date]; // Right about now time

		NSString *cachesPath = [INDAPVPreviewCache appCachesPath]; // Caches path

		NSFileManager *fileManager = [NSFileManager new]; // File manager instance

		NSArray *cachesList = [fileManager contentsOfDirectoryAtPath:cachesPath error:NULL];

		if (cachesList != nil) // Process caches directory contents
		{
			for (NSString *cacheName in cachesList) // Enumerate directory contents
			{
				if (cacheName.length == 36) // This is a very hacky cache ident kludge
				{
					NSString *cachePath = [cachesPath stringByAppendingPathComponent:cacheName];

					NSDictionary *attributes = [fileManager attributesOfItemAtPath:cachePath error:NULL];

					NSDate *cacheDate = [attributes objectForKey:NSFileModificationDate]; // Cache date

					NSTimeInterval seconds = [now timeIntervalSinceDate:cacheDate]; // Cache age

					if (seconds > age) // Older than so remove the thumb cache
					{
						[fileManager removeItemAtPath:cachePath error:NULL];

						#ifdef DEBUG
							NSLog(@"%s purged %@", __FUNCTION__, cacheName);
						#endif
					}
				}
			}
		}

		[fileManager release]; // Cleanup
	});
}

#pragma mark INDAPVPreviewCache instance methods

- (id)init
{
 	if ((self = [super init])) // Initialize
	{
		thumbCache = [NSCache new]; // Cache

		[thumbCache setName:@"INDAPVPreviewCache"];

		[thumbCache setTotalCostLimit:CACHE_SIZE];
	}

	return self;
}

- (void)dealloc
{
 	[thumbCache release], thumbCache = nil;

	[super dealloc];
}

- (id)thumbRequest:(INDAPVPreviewRequest *)request priority:(BOOL)priority
{
 	@synchronized(thumbCache) // Mutex lock
	{
		id object = [thumbCache objectForKey:request.cacheKey];

		if (object == nil) // Thumb object does not yet exist in the cache
		{
			object = [NSNull null]; // Return an NSNull thumb placeholder object

			[thumbCache setObject:object forKey:request.cacheKey cost:2]; // Cache the placeholder object

			INDAPVPreviewFetch *thumbFetch = [[INDAPVPreviewFetch alloc] initWithRequest:request]; // Create a thumb fetch operation

			[thumbFetch setQueuePriority:(priority ? NSOperationQueuePriorityNormal : NSOperationQueuePriorityLow)]; // Queue priority

			request.thumbView.operation = thumbFetch; [thumbFetch setThreadPriority:(priority ? 0.55 : 0.35)]; // Thread priority

			[[INDAPVPreviewQueue sharedInstance] addLoadOperation:thumbFetch]; [thumbFetch release]; // Queue the operation
		}

		return object; // NSNull or UIImage
	}
}

- (void)setObject:(UIImage *)image forKey:(NSString *)key
{
 	@synchronized(thumbCache) // Mutex lock
	{
		NSUInteger bytes = (image.size.width * image.size.height * 4.0f);

		[thumbCache setObject:image forKey:key cost:bytes]; // Cache image
	}
}

- (void)removeObjectForKey:(NSString *)key
{
 	@synchronized(thumbCache) // Mutex lock
	{
		[thumbCache removeObjectForKey:key];
	}
}

- (void)removeNullForKey:(NSString *)key
{
 	@synchronized(thumbCache) // Mutex lock
	{
		id object = [thumbCache objectForKey:key];

		if ([object isMemberOfClass:[NSNull class]])
		{
			[thumbCache removeObjectForKey:key];
		}
	}
}

- (void)removeAllObjects
{
 	@synchronized(thumbCache) // Mutex lock
	{
		[thumbCache removeAllObjects];
	}
}

@end
