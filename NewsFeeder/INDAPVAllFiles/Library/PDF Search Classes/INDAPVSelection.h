
/********************************************************************************\
 *
 * File Name       INDAPVSelection.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import <Foundation/Foundation.h>

@class INDAPVRenderingState;

@interface INDAPVSelection : NSObject {
	INDAPVRenderingState *initialState;
	CGAffineTransform transform;
	CGRect frame;
}

/* Initalize with rendering state (starting marker) */
- (id)initWithStartState:(INDAPVRenderingState *)state;

/* Finalize the selection (ending marker) */
- (void)finalizeWithState:(INDAPVRenderingState *)state;

/* The frame with zero origin covering the selection */
@property (nonatomic, readonly) CGRect frame;

/* The transformation needed to position the selection */
@property (nonatomic, readonly) CGAffineTransform transform;

@end
