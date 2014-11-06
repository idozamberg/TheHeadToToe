/********************************************************************************\
 *
 * File Name       INDAPVStringDetector.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/




/*
 *	Given a keyword and a stream of charachers, triggers when
 *	the desired needle is found.
 *
 *	The implementation ressembles a finite state machine (FSM).
 *
 *
 */

#import <Foundation/Foundation.h>
#import "INDAPVFont.h"

@class INDAPVStringDetector;

@protocol StringDetectorDelegate <NSObject>

@optional

/* Tells the delegate that the first character of the needle was detected */
- (void)detector:(INDAPVStringDetector *)detector didStartMatchingString:(NSString *)string;

/* Tells the delegate that the entire needle was detected */
- (void)detector:(INDAPVStringDetector *)detector foundString:(NSString *)needle;

/* Tells the delegate that one character was scanned */
- (void)detector:(INDAPVStringDetector *)detector didScanCharacter:(unichar)character;

@end


@interface INDAPVStringDetector : NSObject {
	NSString *keyword;
	NSUInteger keywordPosition;
	NSMutableString *unicodeContent;
	id<StringDetectorDelegate> delegate;
}

/* Initialize with a given needle */
- (id)initWithKeyword:(NSString *)needle;

/* Feed more charachers into the state machine */
- (NSString *)appendPDFString:(CGPDFStringRef)string withFont:(INDAPVFont *)font;

/* Reset the detector state */
- (void)reset;

@property (nonatomic, retain) NSString *keyword;
@property (nonatomic, assign) id<StringDetectorDelegate> delegate;
@property (nonatomic, readonly) NSString *unicodeContent;
@end
