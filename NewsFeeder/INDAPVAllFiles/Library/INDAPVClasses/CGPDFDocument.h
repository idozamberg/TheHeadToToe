
/********************************************************************************\
 *
 * File Name       CGPDFDocument.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>


CGPDFDocumentRef CGPDFDocumentCreateX(CFURLRef theURL, NSString *password);

BOOL CGPDFDocumentNeedsPassword(CFURLRef theURL, NSString *password);
