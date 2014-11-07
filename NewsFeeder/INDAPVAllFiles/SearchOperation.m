//
//  SearchOperation.m
//  HeadToToe
//
//  Created by ido zamberg on 06/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "SearchOperation.h"
#import "PDFManager.h"

@implementation SearchOperation
{
    NSString* keyword;
}

@synthesize delegate;

- (id) initWithSearchString : (NSString*) string
{
    self = [super init];
    
    if (self)
    {
        keyword = string;
    }
    
    return self;
    
}

- (void)main {
    // a lengthy operation
    @autoreleasepool {
     
        if (self.isCancelled) return;
        // Scanning pdf files
        NSMutableArray* scanResults = [[PDFManager sharedInstance] findStringInPdfLibrary:keyword];
    
        if ([self.delegate respondsToSelector:@selector(searchDidFinishedWithArray:)])
        {
            [self.delegate searchDidFinishedWithArray:scanResults];
        }
    }
}

@end
