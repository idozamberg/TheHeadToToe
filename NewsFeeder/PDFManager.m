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

- (NSArray*) getSortedKeysArrayForDictionary :(NSDictionary*) dict
{
    NSArray *arr =  [[dict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    return arr;
}

- (NSString*) createStringFromDictionaryForPdf : (NSMutableDictionary*) dict andShouldFilter : (BOOL) shouldFilter
{
    NSString* pdfString = @"ADMISSION: \n";
    NSInteger sectionCounter = 0;
    
    // Going through all categories
    for (NSString* part in [dict allKeys])
    {
        
        // Getting current dictionary
        NSMutableDictionary* currentExamPart;
        NSString* partTitle;
    
        // Checking for current part
        if (sectionCounter == SECTION_AG)
        {
            currentExamPart = [dict objectForKey:@"Anamnèse Générale"];
            partTitle = @"Anamnèse Générale";
        }
        else if (sectionCounter == SECTION_APS)
        {
            currentExamPart = [dict objectForKey:@"Anamnèse par système"];
            partTitle = @"Anamnèse par système";

        }
        else
        {
            currentExamPart = [dict objectForKey:@"Examen Physique"];
            partTitle = @"Examen Physique";

        }

        // Setting title
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ \n",partTitle]];
        
        // Checking if section has selected entities
        if ([self doesHaveCheckedSections:currentExamPart] || !shouldFilter)
        {
                // Getting sroted keys
                NSArray* allBodyParts = [self getSortedKeysArrayForDictionary:currentExamPart];
            
                // Setting part title
                for (NSString* bodyPart in allBodyParts)
                {
                    // Getting current question array
                    NSMutableArray* currentQuestionsArray = [currentExamPart valueForKey:bodyPart];
                    
                    // Removing number from key
                    NSArray* splitBodyPartArray = [bodyPart componentsSeparatedByString:@"."];
                    NSString* splittedBodyPart = [splitBodyPartArray objectAtIndex:1];
                    
                    // Filter non checked questions
                    if ([self doesHaveCheckedQuestions:currentQuestionsArray] || !shouldFilter)
                    {
                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\t%@ ",splittedBodyPart]];
                        
                        // Going through all qeustions sections
                        for (AdmissionQuestion* currentQuestion in currentQuestionsArray)
                        {
                            
                            // Checking if cell was checked or not
                            if (currentQuestion.wasChecked)
                            {
                                // Moving text by a tab
                                pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n\t\t"]];

                                NSString* comment = currentQuestion.comment ? currentQuestion.comment : @"";
                              
                                // Empty checked text ?
                                if (!currentQuestion.checkedText || [currentQuestion.checkedText isEqualToString:@""])
                                {
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@",currentQuestion.text]];
                                    
                                    // If we have a comment
                                    if (comment && ![comment isEqualToString:@""])
                                    {
                                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@": %@",comment]];
                                    }
                                    
                                }
                                else
                                {
                                    // If we have comment show it
                                    if (![comment isEqualToString:@""])
                                    {
                                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@ : %@",currentQuestion.text,currentQuestion.checkedText,comment]];
                                      //  pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@" %@",comment]];
                                    }
                                    // No comment ? no predefient text ? Go to default
                                    else
                                    {
                                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ : %@",currentQuestion.text, currentQuestion.checkedText]];
                                    }
                                }
                            }
                            else
                            {
                                /*if (!currentQuestion.nonCheckedText || [currentQuestion.nonCheckedText isEqualToString:@""] || [currentQuestion.nonCheckedText isEqualToString:@" "])
                                {
                                    // Setting up string to write
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"Pas de %@",currentQuestion.text]];
                                }
                                else
                                {
                                    // Setting up string to write
                                //    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@: %@",currentQuestion.text,currentQuestion.nonCheckedText]];
                                    
                                    // Setting up string to write
                                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@",currentQuestion.nonCheckedText]];
                                    
                                }*/
                            }
                        
                            //pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];
                        }
                        
                        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];

                    }
                }
        }
        
        // New line
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];
        
        sectionCounter += 1;

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
