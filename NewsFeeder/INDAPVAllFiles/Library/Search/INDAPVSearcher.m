
/********************************************************************************\
 *
 * File Name       INDAPVSearcher.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "INDAPVSearcher.h"

@implementation INDAPVSearcher
@synthesize currentData;
-(id)init
{
    if(self = [super init])
    {
        table = CGPDFOperatorTableCreate();
        CGPDFOperatorTableSetCallback(table, "TJ", arrayCallback);
        CGPDFOperatorTableSetCallback(table, "Tj", stringCallback);
    }
    return self;
}

void arrayCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    INDAPVSearcher * searcher = (INDAPVSearcher *)userInfo;
    
    CGPDFArrayRef array;
    
    bool success = CGPDFScannerPopArray(inScanner, &array);
    
    for(size_t n = 0; n < CGPDFArrayGetCount(array); n += 2)
    {
        if(n >= CGPDFArrayGetCount(array))
            continue;
        
        CGPDFStringRef string;
        success = CGPDFArrayGetString(array, n, &string);
        if(success)
        {
            NSString *data = (NSString *)CGPDFStringCopyTextString(string);
            [searcher.currentData appendFormat:@"%@", data];
            [data release];
        }
    }
}

void stringCallback(CGPDFScannerRef inScanner, void *userInfo)
{
    INDAPVSearcher *searcher = (INDAPVSearcher *)userInfo;
    
    CGPDFStringRef string;
    
    bool success = CGPDFScannerPopString(inScanner, &string);
    
    if(success)
    {
        NSString *data = (NSString *)CGPDFStringCopyTextString(string);
        [searcher.currentData appendFormat:@" %@", data];
        [data release];
    }
}

-(BOOL)page:(CGPDFPageRef)inPage containsString:(NSString *)inSearchString;
{
    [self setCurrentData:[NSMutableString string]];
    CGPDFContentStreamRef contentStream = CGPDFContentStreamCreateWithPage(inPage);
    CGPDFScannerRef scanner = CGPDFScannerCreate(contentStream, table, self);
   // bool ret = CGPDFScannerScan(scanner);//Y Comment - No use
    CGPDFScannerRelease(scanner);
    CGPDFContentStreamRelease(contentStream);
  
    return ([[currentData uppercaseString] 
             rangeOfString:[inSearchString uppercaseString]].location != NSNotFound);
}
@end
