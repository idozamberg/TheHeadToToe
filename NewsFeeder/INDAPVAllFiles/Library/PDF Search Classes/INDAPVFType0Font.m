
/********************************************************************************\
 *
 * File Name       INDAPVFType0Font.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import "INDAPVFType0Font.h"
#import "INDAPVType0Font.h"
#import "INDAPVType2Font.h"


@interface INDAPVFType0Font ()
@property (nonatomic, readonly) NSMutableArray *descendantFonts;
@end

@implementation INDAPVFType0Font

/* Initialize with font dictionary */
- (id)initWithFontDictionary:(CGPDFDictionaryRef)dict
{
	if ((self = [super initWithFontDictionary:dict]))
	{
		CGPDFArrayRef dFonts;
		if (CGPDFDictionaryGetArray(dict, "DescendantFonts", &dFonts))
		{
			NSUInteger count = CGPDFArrayGetCount(dFonts);
			for (int i = 0; i < count; i++)
			{
				CGPDFDictionaryRef fontDict;
				if (!CGPDFArrayGetDictionary(dFonts, i, &fontDict)) continue;
				const char *subtype;
				if (!CGPDFDictionaryGetName(fontDict, "Subtype", &subtype)) continue;


				if (strcmp(subtype, "CIDFontType0") == 0)
				{
					// Add descendant font of type 0
					INDAPVType0Font *font = [[INDAPVType0Font alloc] initWithFontDictionary:fontDict];
					if (font) [self.descendantFonts addObject:font];
					[font release];
				}
				else if (strcmp(subtype, "CIDFontType2") == 0)
				{
					// Add descendant font of type 2
					INDAPVType2Font *font = [[INDAPVType2Font alloc] initWithFontDictionary:fontDict];
					if (font) [self.descendantFonts addObject:font];
					[font release];
				}
			}
		}
	}
	return self;
}

/* Custom implementation, using descendant fonts */
- (CGFloat)widthOfCharacter:(unichar)characher withFontSize:(CGFloat)fontSize
{
	for (INDAPVFont *font in self.descendantFonts)
	{
		CGFloat width = [font widthOfCharacter:characher withFontSize:fontSize];
		if (width > 0) return width;
	}
	return 0;
}

- (NSDictionary *)ligatures
{
    INDAPVFont *descendantFont = [self.descendantFonts lastObject];
    return descendantFont.ligatures;
}

- (INDAPVFontDescriptor *)fontDescriptor {
	INDAPVFont *descendantFont = [self.descendantFonts lastObject];
	return descendantFont.fontDescriptor;
}

- (CGFloat)minY
{
	INDAPVFont *descendantFont = [self.descendantFonts lastObject];
	return [descendantFont.fontDescriptor descent];
}

/* Highest point of any character */
- (CGFloat)maxY
{
	INDAPVFont *descendantFont = [self.descendantFonts lastObject];
	return [descendantFont.fontDescriptor ascent];
}

- (NSString *)stringWithPDFString:(CGPDFStringRef)pdfString
{
    NSMutableString *result;
	INDAPVFont *descendantFont = [self.descendantFonts lastObject];
    NSString *descendantResult = [descendantFont stringWithPDFString: pdfString];
    if (self.toUnicode) {
        unichar mapping;
        result = [[[NSMutableString alloc] initWithCapacity: [descendantResult length]] autorelease];
        for (int i = 0; i < [descendantResult length]; i++) {
            mapping = [self.toUnicode unicodeCharacter: [descendantResult characterAtIndex:i]];
            [result appendFormat: @"%C", mapping];
        }        
    } else {
        result = [NSMutableString stringWithString: descendantResult];
    }
    return result;
}

- (NSString *)cidWithPDFString:(CGPDFStringRef)pdfString {
    INDAPVFont *descendantFont = [self.descendantFonts lastObject];
    return [descendantFont stringWithPDFString: pdfString];
}


#pragma mark -
#pragma mark Memory Management

- (NSMutableArray *)descendantFonts
{
	if (!descendantFonts)
	{
		descendantFonts = [[NSMutableArray alloc] init];
	}
	return descendantFonts;
}

- (void)dealloc
{
	[descendantFonts release];
	[super dealloc];
}

@end
