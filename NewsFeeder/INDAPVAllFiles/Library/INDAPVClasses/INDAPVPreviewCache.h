
/********************************************************************************\
 *
 * File Name       INDAPVPreviewCache.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>

#import "INDAPVPreviewRequest.h"

@interface INDAPVPreviewCache : NSObject
{
@private // Instance variables

	NSCache *thumbCache;
}

+ (INDAPVPreviewCache *)sharedInstance;

+ (void)touchThumbCacheWithGUID:(NSString *)guid;

+ (void)createThumbCacheWithGUID:(NSString *)guid;

+ (void)removeThumbCacheWithGUID:(NSString *)guid;

+ (void)purgeThumbCachesOlderThan:(NSTimeInterval)age;

+ (NSString *)thumbCachePathForGUID:(NSString *)guid;

- (id)thumbRequest:(INDAPVPreviewRequest *)request priority:(BOOL)priority;

- (void)setObject:(UIImage *)image forKey:(NSString *)key;

- (void)removeObjectForKey:(NSString *)key;

- (void)removeNullForKey:(NSString *)key;

- (void)removeAllObjects;

@end
