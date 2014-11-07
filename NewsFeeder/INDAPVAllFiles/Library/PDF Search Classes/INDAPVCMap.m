
/********************************************************************************\
 *
 * File Name       INDAPVCMap.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVCMap.h"
#import "INDAPVTrueTypeFont.h"

@implementation INDAPVCMap

- (void)scanCodeSpaceRange:(NSScanner *)scanner
{
	static NSString *endToken = @"endcodespacerange";
	NSString *content = nil;
	[scanner scanUpToString:endToken intoString:&content];
	[scanner scanString:endToken intoString:nil];

}

- (void)scanRanges:(NSScanner *)scanner
{
	NSString *content = nil;
	static NSString *endToken = @"endbfrange";
	[scanner scanUpToString:endToken intoString:&content];
	NSCharacterSet *alphaNumericalSet = [NSCharacterSet alphanumericCharacterSet];
	
	offsets = [[NSMutableArray alloc] init];
	NSScanner *rangeScanner = [NSScanner scannerWithString:content];
	while (![rangeScanner isAtEnd])
	{
		unsigned int start, end, offset;
		[rangeScanner scanUpToCharactersFromSet:alphaNumericalSet intoString:nil];
		[rangeScanner scanHexInt:&start];
		[rangeScanner scanUpToCharactersFromSet:alphaNumericalSet intoString:nil];
		[rangeScanner scanHexInt:&end];
		[rangeScanner scanUpToCharactersFromSet:alphaNumericalSet intoString:nil];
		[rangeScanner scanHexInt:&offset];
		NSDictionary *dict = [NSDictionary dictionaryWithObjectsAndKeys:
							  [NSNumber numberWithInt:start], @"First",
							  [NSNumber numberWithInt:end], @"Last",
							  [NSNumber numberWithInt:offset], @"Offset", 
							  nil];
		[offsets addObject:dict];

	}
	[scanner scanString:endToken intoString:nil];
}

- (void)scanChars:(NSScanner *)scanner 
{
	NSString *content = nil;
	static NSString *endToken = @"endbfchar";
	[scanner scanUpToString:endToken intoString:&content];
    NSCharacterSet *newLineSet = [NSCharacterSet newlineCharacterSet];
    NSCharacterSet *tagSet = [NSCharacterSet characterSetWithCharactersInString:@"<>"];
    NSString *separatorString = @"> <";
    
    chars = [[NSMutableDictionary alloc] init];    
    NSScanner *rangeScanner = [NSScanner scannerWithString:content];
    while (![rangeScanner isAtEnd])
    {
        NSString *line = nil;
        [rangeScanner scanUpToCharactersFromSet:newLineSet intoString:&line];
        line = [line stringByTrimmingCharactersInSet:tagSet];
        NSArray *parts = [line componentsSeparatedByString:separatorString];
        
        NSUInteger from, to;
        NSScanner *scanner = [NSScanner scannerWithString:[parts objectAtIndex:0]];
        [scanner scanHexInt:&from];
        
        if (parts.count > 1)
        {
            scanner = [NSScanner scannerWithString:[parts objectAtIndex:1]];
            [scanner scanHexInt:&to];
        }
        else
        {
            scanner = [NSScanner scannerWithString:@""];
            [scanner scanHexInt:&to];
        }
        
        NSNumber *fromNumber = [NSNumber numberWithInt:from];
        NSNumber *toNumber = [NSNumber numberWithInt:to];
        [chars setObject:toNumber  forKey:fromNumber];
    }
    
}

- (void)scanCMap:(NSScanner *)scanner
{
	while (![scanner isAtEnd])
	{
		NSString *line;
		[scanner scanUpToCharactersFromSet:[NSCharacterSet newlineCharacterSet] intoString:&line];
		if ([line rangeOfString:@"begincodespacerange"].location != NSNotFound)
		{
			[self scanCodeSpaceRange:scanner];
		}
		else if ([line rangeOfString:@"beginbfrange"].location != NSNotFound)
		{
			[self scanRanges:scanner];
		}
        else if ([line rangeOfString:@"beginbfchar"].location != NSNotFound) 
        {
            [self scanChars:scanner];
        }
	}
}

- (void)scanning:(NSString *)text
{
	NSScanner *scanner = [NSScanner scannerWithString:text];
	[scanner scanUpToString:@"begincmap" intoString:nil];
	[scanner scanString:@"begincmap" intoString:nil];

	[self scanCMap:scanner];
}

- (id)initWithPDFStream:(CGPDFStreamRef)stream
{
	if ((self = [super init]))
	{
		NSData *data = (NSData *) CGPDFStreamCopyData(stream, nil);
		NSString *text = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
		[data release];
		
		[self scanning:text];
		return self;
    }
	return self;
}

- (NSDictionary *)rangeWithCharacter:(unichar)character
{
	for (NSDictionary *dict in offsets)
	{
		if ([[dict objectForKey:@"First"] intValue] <= character && [[dict objectForKey:@"Last"] intValue] >= character)
		{
			return dict;
		}
	}
	return nil;
}

- (unichar)unicodeCharacter:(unichar)cid
{
	NSDictionary *dict = [self rangeWithCharacter:cid];
    if (dict)
    {
        NSUInteger internalOffset = cid - [[dict objectForKey:@"First"] intValue];
        return [[dict objectForKey:@"Offset"] intValue] + internalOffset;
    }
    else if (chars)
    {
        NSNumber *fromChar = [NSNumber numberWithInt: cid];
        NSNumber *toChar = [chars objectForKey: fromChar];
        return [toChar intValue];
    }
    return cid;
}

- (void)dealloc
{
	[offsets release];
	[super dealloc];
}

@end
