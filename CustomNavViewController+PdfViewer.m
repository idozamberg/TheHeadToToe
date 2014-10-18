//
//  CustomNavViewController+PdfViewer.m
//  
//
//  Created by ido zamberg on 10/16/14.
//
//

#import "CustomNavViewController+PdfViewer.h"

@implementation CustomNavViewController (PdfViewer)



-(void)pushShowPDFReaderWithName : (NSString*) name
{
    // Setting up file name
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsPath error:NULL];
    NSString *fileName = [fileList firstObject]; // Presume that the first file is a PDF
    NSString *filePath = [documentsPath stringByAppendingPathComponent:name];
    
    // Configuring screen
    ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    self.readerViewController = [[ReaderViewController alloc] initWithReaderDocument:document];
    CustomNavigationBarView* navigation = [CustomNavigationBarView viewFromStoryboard];
    
    [navigation setFrame:CGRectMake( 0, 0, 320, 50 )];
    [navigation setBackgroundColor:THEME_COLOR_RED];
    [navigation showRightButton:YES];
    [navigation.lblTitle setText:@""];
    [navigation.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                           forState:UIControlStateNormal];
    
    [navigation.rightButton setImage:[UIImage imageNamed:@"Arrow up"]
                            forState:UIControlStateNormal];
    
    
    navigation.delegate = self;
    
    [self.readerViewController.view addSubview:navigation];
    
    //[self.navigationController presentViewController:readerViewController animated:YES completion:Nil];
    
    [self.navigationController pushViewController:self.readerViewController animated:YES];
    
}

@end
