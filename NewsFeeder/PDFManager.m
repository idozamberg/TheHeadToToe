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

@implementation PDFManager

static PDFManager* sharePDF;


+ (PDFManager*) sharedInstance
{
    if (!sharePDF)
    {
        sharePDF = [PDFManager new];
    }
    
    return sharePDF;
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
                                pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@:",currentQuestion.text]];
                                pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@" Oui - %@",comment]];
                            }
                            else
                            {
                                // Setting up string to write
                                pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          Pas de %@",currentQuestion.text]];
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
@end
