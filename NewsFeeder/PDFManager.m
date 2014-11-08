//
//  PDFManager.m
//  HeadToToe
//
//  Created by ido zamberg on 10/16/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "PDFManager.h"
#import "AdmissionQuestion.h"
#import "OCPDFGenerator.h"
//#import "Scanner.h"
#import "HTTFile.h"
#import "INDAPVDocument.h"
#import "INDAPVScanner.h"
#import "CGPDFDocument.h"



@implementation PDFManager
{
}
@synthesize documentsUrls = _documentsUrls;
@synthesize scanner;

static PDFManager* sharePDF;


+ (PDFManager*) sharedInstance
{
    if (!sharePDF)
    {
        sharePDF = [PDFManager new];
    }
    
    return sharePDF;
}

- (id) init
{
    self = [super init];
    
    if (self)
    {
        //[self loadDocumentsUrl];
        scanner = [[INDAPVScanner alloc] init];
    }
    
    return self;
}

- (NSString*) createPdfFromDictionary : (NSMutableDictionary*) dict andShouldFilter : (BOOL) shouldFilter
{
    
    // Creating pdf
    NSString *path = [OCPDFGenerator generatePDFFromNSString:[self createStringFromDictionaryForPdf:dict andShouldFilter:shouldFilter]];

    NSString* theFileName = [[path lastPathComponent] stringByDeletingPathExtension];
    
    NSFileManager *fileManager = [NSFileManager new];
    
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:theFileName];
        
        //[fileManager removeItemAtPath:targetPath error:NULL]; // Delete target file
        
    [fileManager copyItemAtPath:path toPath:targetPath error:NULL];

    return theFileName;
}

- (NSString*) createStringFromDictionaryForPdf : (NSMutableDictionary*) dict andShouldFilter : (BOOL) shouldFilter
{
    NSString* pdfString = @"ADMISSION: \n";
    
    // Going through all categories
    for (NSString* part in [dict allKeys])
    {
        // Setting title
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ \n",part]];
        
        // Getting current dictionary
        NSMutableDictionary* currentExamPart = [dict objectForKey:part];
        
        if ([self doesHaveCheckedSections:currentExamPart] || !shouldFilter)
        {
                // Setting part title
                for (NSString* bodyPart in [currentExamPart allKeys])
                {
                    // Getting current question array
                    NSMutableArray* currentQuestionsArray = [currentExamPart valueForKey:bodyPart];
                    
                    // Filter non checked questions
                    if ([self doesHaveCheckedQuestions:currentQuestionsArray] || !shouldFilter)
                    {
                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"     %@ \n",bodyPart]];
                        
                        // Going through all qeustions sections
                        for (AdmissionQuestion* currentQuestion in currentQuestionsArray)
                        {
                            
                            // Checking if cell was checked or not
                            if (currentQuestion.wasChecked)
                            {
                                NSString* comment = currentQuestion.comment ? currentQuestion.comment : @"";
                              
                                // Empty checked text ?
                                if (!currentQuestion.checkedText)
                                {
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@:",currentQuestion.text]];
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@" Oui - %@",comment]];
                                }
                                else
                                {
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@ : %@",currentQuestion.text,currentQuestion.checkedText]];
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@" %@",comment]];
                                }
                            }
                            else
                            {
                                if (!currentQuestion.nonCheckedText)
                                {
                                    // Setting up string to write
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          Pas de %@",currentQuestion.text]];
                                }
                                else
                                {
                                    // Setting up string to write
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@ %@",currentQuestion.text,currentQuestion.nonCheckedText]];
                                }
                            }
                            
                            // New line
                            pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];

                        }
                    }
                }
        }
        
        // New line
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];

    }

    return pdfString;
}

- (BOOL) doesHaveCheckedSections : (NSMutableDictionary*) dict
{
    for (NSString* bodyPart in [dict allKeys])
    {
        // Getting current question array
        NSMutableArray* currentQuestionsArray = [dict valueForKey:bodyPart];
        
        for (AdmissionQuestion* currentQuestion in currentQuestionsArray)
        {
            if (currentQuestion.wasChecked)
            {
                return YES;
            }

        }
    }
    
    return NO;
}

- (BOOL) doesHaveCheckedQuestions : (NSMutableArray*) questionsArray
{
    for (AdmissionQuestion* currentQuestion in questionsArray)
    {
        if (currentQuestion.wasChecked)
        {
            return YES;
        }
    }

    return NO;
}

# pragma mark PDF Scanner
- (void) loadDocumentsUrl
{
    NSArray *userDocuments = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSURL *docementsURL = [NSURL fileURLWithPath:[userDocuments lastObject]];
    NSLog(@"%@", docementsURL);
    NSArray *documentsURLs = [[NSFileManager defaultManager] contentsOfDirectoryAtURL:docementsURL
                                                           includingPropertiesForKeys:nil
                                                                              options:NSDirectoryEnumerationSkipsHiddenFiles
                                                                                error:nil];
    
    NSMutableArray *names = [NSMutableArray array];
    NSMutableDictionary *urls = [NSMutableDictionary dictionary];
    
    NSArray *bundledResources = [[NSBundle mainBundle] URLsForResourcesWithExtension:@"pdf" subdirectory:nil];
    documentsURLs = [documentsURLs arrayByAddingObjectsFromArray:bundledResources];
    
    for (NSURL *docURL in documentsURLs)
    {
        NSString *title = [[docURL lastPathComponent] stringByDeletingPathExtension];
        [names addObject:title];
        [urls setObject:docURL forKey:title];
    }
    
    _documentsUrls = [[NSDictionary alloc] initWithDictionary:urls];
}




- (NSMutableArray*) findStringInPdfLibrary : (NSString*) searchPhrase
{
    NSArray* filesList = [[AppData sharedInstance] flattenedFilesArray];
    NSMutableArray* listOfFilesWithSearchString = [NSMutableArray new];
    
    // Going through all files
    for (HTTFile* currFile in filesList)
    {
        // Getting Current Url
        NSURL* currUrl = [NSURL fileURLWithPath:[self getFileFullPath:currFile.name]];
        
        // Checking if file has string
        if ([self hasStringInFileWithName:currUrl andString:searchPhrase])
        {
            // Adding file to list
            [listOfFilesWithSearchString addObject:currFile];
        }
    }
    
    return listOfFilesWithSearchString;
}


- (NSString*) getFileFullPath : (NSString*) name
{
    // Setting up file name
    NSString *phrase = nil; // Document password (for unlocking most encrypted PDF files)
    NSFileManager *fileManager = [NSFileManager new];
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    NSArray *fileList = [fileManager contentsOfDirectoryAtPath:documentsPath error:NULL];
    NSString *fileName = [fileList firstObject]; // Presume that the first file is a PDF
    NSString *filePath = [documentsPath stringByAppendingPathComponent:name];
    
    return filePath;
}


- (BOOL) hasStringInFileWithName :(NSURL*) fileUrl andString : (NSString*) searchString
{
    CGPDFDocumentRef document;
    
    // Creating document
    document = CGPDFDocumentCreateWithURL((CFURLRef)fileUrl);
    
    // Getting the number of pages
    size_t numberOfpages = CGPDFDocumentGetNumberOfPages(document);
    
    // Going through all pages
    for (int pageNumber = 1; pageNumber <= numberOfpages; pageNumber++)
    {
        // Scan current page
        CGPDFPageRef page = CGPDFDocumentGetPage(document, pageNumber);
        INDAPVScanner *theScanner = [INDAPVScanner aScanner];
        
        [theScanner setKeyword:searchString];//keyWord
        [theScanner scanPage:page];
        
        // Getting results
      //  NSArray *selections = [scanner select:searchString ForPage:page];
        
        // Check if we have results
        if ([theScanner selections].count > 0)
        {
            return YES;
        }
    }
    
    return NO;
}



@end
