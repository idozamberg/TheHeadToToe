
/********************************************************************************\
 *
 * File Name       INDAPVCompositeFont.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


/*
 *	A composite font is one of the following types:
 *		- Type0
 *		- CIDType0Font
 *		- CIDType2Font
 *
 *	Composite fonts have the following specific traits:
 *		- Default glyph width
 *
 */

#import <Foundation/Foundation.h>
#import "INDAPVFont.h"

@interface INDAPVCompositeFont : INDAPVFont {
    CGFloat defaultWidth;
}

@property (nonatomic, assign) CGFloat defaultWidth;
@end
