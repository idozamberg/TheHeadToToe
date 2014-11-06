
/********************************************************************************\
 *
 * File Name       INDAPVContentPage.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>
#import "INDAPVScanner.h"

@interface INDAPVContentPage : UIView
{
@private // Instance variables

	NSMutableArray *_links;

	CGPDFDocumentRef _PDFDocRef;

	CGPDFPageRef _PDFPageRef;

	NSInteger _pageAngle;

	CGSize _pageSize;
    NSArray *selections;
	INDAPVScanner *scanner;
    NSString *keyword;
}


- (id)initWithURL:(NSURL *)fileURL page:(NSInteger)page password:(NSString *)phrase;

- (id)singleTap:(UITapGestureRecognizer *)recognizer;
@property (nonatomic, retain) INDAPVScanner *scanner;
@property (nonatomic, copy) NSArray *selections;
@property (nonatomic, copy) NSString *keyword;
@end



@interface INDAPVDocumentLink : NSObject
{
@private // Instance variables

	CGPDFDictionaryRef _dictionary;

	CGRect _rect;
}

@property (nonatomic, assign, readonly) CGRect rect;

@property (nonatomic, assign, readonly) CGPDFDictionaryRef dictionary;

+ (id)withRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary;

- (id)initWithRect:(CGRect)linkRect dictionary:(CGPDFDictionaryRef)linkDictionary;

@end
