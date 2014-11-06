
/********************************************************************************\
 *
 * File Name       INDAPVPreviewRender.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <Foundation/Foundation.h>

#import "INDAPVPreviewQueue.h"

@class INDAPVPreviewRequest;

@interface INDAPVPreviewRender : INDAPVThumbOperation
{
@private // Instance variables

	INDAPVPreviewRequest *request;
}

- (id)initWithRequest:(INDAPVPreviewRequest *)request;

@end
