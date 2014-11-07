
/********************************************************************************\
 *
 * File Name       INDAPVScanner.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <Foundation/Foundation.h>
#import "INDAPVStringDetector.h"
#import "INDAPVFontCollection.h"
#import "INDAPVRenderingState.h"
#import "INDAPVSelection.h"

#if __has_feature(objc_arc)
#define ARC_MEMBER __unsafe_unretained
#else
#define ARC_MEMBER
#endif

@interface INDAPVScanner : NSObject <StringDetectorDelegate> {
	NSURL *documentURL;
	NSString *keyword;
	CGPDFDocumentRef pdfDocument;
	CGPDFOperatorTableRef operatorTable;
	INDAPVStringDetector *stringDetector;
	INDAPVFontCollection *fontCollection;
	RenderingStateStack *renderingStateStack;
	INDAPVSelection *currentSelection;
	NSMutableArray *selections;
//	ARC_MEMBER NSMutableString **rawTextContent;
}

/* Initialize with a file path */
- (id)initWithContentsOfFile:(NSString *)path;

/* Initialize with a PDF document */
- (id)initWithDocument:(CGPDFDocumentRef)document;

/* Start scanning (synchronous) */
- (void)scanDocumentPage:(NSUInteger)pageNumber;

/* Start scanning a particular page */
- (void)scanPage:(CGPDFPageRef)page;

+ (INDAPVScanner *)aScanner;

- (NSArray *)select:(NSString *)word ForPage : (CGPDFPageRef) pdfPage;

@property (nonatomic, retain) NSMutableArray *selections;
@property (nonatomic, retain) RenderingStateStack *renderingStateStack;
@property (nonatomic, retain) INDAPVFontCollection *fontCollection;
@property (nonatomic, retain) INDAPVStringDetector *stringDetector;
@property (nonatomic, retain) NSString *keyword;
//@property (nonatomic, assign) ARC_MEMBER NSMutableString **rawTextContent;
@end
