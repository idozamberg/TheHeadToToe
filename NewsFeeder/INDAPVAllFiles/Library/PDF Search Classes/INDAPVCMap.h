
/********************************************************************************\
 *
 * File Name       INDAPVCMap.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <Foundation/Foundation.h>


@interface INDAPVCMap : NSObject {
	NSMutableArray *offsets;
    NSMutableDictionary *chars;
}

/* Initialize with PDF stream containing a CMap */
- (id)initWithPDFStream:(CGPDFStreamRef)stream;

/* Unicode mapping for character ID */
- (unichar)unicodeCharacter:(unichar)cid;

@end
