/********************************************************************************\
 *
 * File Name       INDAPVType0Font.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "INDAPVType0Font.h"


@implementation INDAPVType0Font

- (NSString *)stringWithPDFString:(CGPDFStringRef)pdfString
{
	size_t length = CGPDFStringGetLength(pdfString);
	const unsigned char *cid = CGPDFStringGetBytePtr(pdfString);
    NSMutableString *result = [[NSMutableString alloc] init];
	for (int i = 0; i < length; i+=2) {
		char unicodeValue = cid[i+1];
        [result appendFormat:@"%hhd", unicodeValue];
       // [result appendFormat:@"%C", unicodeValue];//Old
	}
    return result;
}

@end
