
/********************************************************************************\
 *
 * File Name       INDAPVSearcher.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <Foundation/Foundation.h>

@interface INDAPVSearcher : NSObject 
{
    CGPDFOperatorTableRef table;
    NSMutableString *currentData;
}
@property (nonatomic, retain) NSMutableString * currentData;
-(id)init;
-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString;
@end