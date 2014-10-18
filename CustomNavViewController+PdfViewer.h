//
//  CustomNavViewController+PdfViewer.h
//  
//
//  Created by ido zamberg on 10/16/14.
//
//

#import "CustomNavViewController.h"
#import "ReaderViewController.h"


@interface CustomNavViewController (PdfViewer)


@property (nonatomic,strong) ReaderViewController* readerViewController;

-(void)pushShowPDFReaderWithName : (NSString*) name;

@end
