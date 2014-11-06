
/********************************************************************************\
 *
 * File Name       INDAPVFont.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

/*
 *	Implements generic behavior of a font.
 *
 *	Most likely used exclusively for subclassing, for Type 0, Type 1 etc.
 *
 *	Ideally, the subclasses are hidden from the user, who interacts with them through this facade class.
 *	
 */
#import <Foundation/Foundation.h>
#import "INDAPVFontDescriptor.h"
#import "INDAPVCMap.h"

@interface INDAPVFont : NSObject {
	INDAPVCMap *toUnicode;
	NSMutableDictionary *widths;
    INDAPVFontDescriptor *fontDescriptor;
	NSDictionary *ligatures;
	NSRange widthsRange;
}

/* Factory method returns a Font object given a PDF font dictionary */
+ (INDAPVFont *)fontWithDictionary:(CGPDFDictionaryRef)dictionary;

/* Initialize with a font dictionary */
- (id)initWithFontDictionary:(CGPDFDictionaryRef)dict;

/* Populate the widths array given font dictionary */
- (void)setWidthsWithFontDictionary:(CGPDFDictionaryRef)dict;

/* Construct a font descriptor given font dictionary */
- (void)setFontDescriptorWithFontDictionary:(CGPDFDictionaryRef)dict;

/* Given a PDF string, returns a Unicode string */
- (NSString *)stringWithPDFString:(CGPDFStringRef)pdfString;

/* Given a PDF string, returns a CID string */
- (NSString *)cidWithPDFString:(CGPDFStringRef)pdfString;

/* Returns the width of a charachter (optionally scaled to some font size) */
- (CGFloat)widthOfCharacter:(unichar)characher withFontSize:(CGFloat)fontSize;

/* Import a ToUnicode CMap from a font dictionary */
- (void)setToUnicodeWithFontDictionary:(CGPDFDictionaryRef)dict;

/* Unicode character with CID */
- (NSString *)stringWithCharacters:(const char *)characters;

@property (nonatomic, retain) INDAPVCMap *toUnicode;
@property (nonatomic, retain) NSMutableDictionary *widths;
@property (nonatomic, retain) INDAPVFontDescriptor *fontDescriptor;
@property (nonatomic, readonly) CGFloat minY;
@property (nonatomic, readonly) CGFloat maxY;
@property (nonatomic, readonly) NSDictionary *ligatures;
@property (nonatomic, readonly) CGFloat widthOfSpace;
@property (nonatomic, readonly) NSRange widthsRange;
@end
