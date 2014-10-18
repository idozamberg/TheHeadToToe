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

static PDFManager* shareData;


+ (PDFManager*) sharedInstance
{
    if (!shareData)
    {
        shareData = [PDFManager new];
    }
    
    return shareData;
}

- (NSString*) createPdfFromDictionary : (NSMutableDictionary*) dict
{
    
    // Creating pdf
    NSString *path = [OCPDFGenerator generatePDFFromNSString:[self createStringFromDictionaryForPdf:dict]];

    NSString* theFileName = [[path lastPathComponent] stringByDeletingPathExtension];
    
    NSFileManager *fileManager = [NSFileManager new];
    
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    
    NSString *targetPath = [documentsPath stringByAppendingPathComponent:theFileName];
        
        //[fileManager removeItemAtPath:targetPath error:NULL]; // Delete target file
        
    [fileManager copyItemAtPath:path toPath:targetPath error:NULL];

    return theFileName;
}

- (NSString*) createStringFromDictionaryForPdf : (NSMutableDictionary*) dict
{
    NSString* pdfString = @"ADMISSION: \n";
    
    // Going through all categories
    for (NSString* part in [dict allKeys])
    {
        // Setting title
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"%@ \n",part]];
        
        // Getting current dictionary
        NSMutableDictionary* currentExamPart = [dict objectForKey:part];
        
        // Setting part title

        for (NSString* bodyPart in [currentExamPart allKeys])
        {
            pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"     %@ \n",bodyPart]];
            
            // Getting current question array
            NSMutableArray* currentQuestionsArray = [currentExamPart valueForKey:bodyPart];
            
            for (AdmissionQuestion* currentQuestion in currentQuestionsArray)
            {
                
                // Checking if cell was checked or not
                if (currentQuestion.wasChecked)
                {
                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"          %@:",currentQuestion.text]];
                    pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@" Oui - %@",currentQuestion.comment]];
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
        
        // New line
        pdfString = [pdfString stringByAppendingString:[NSString stringWithFormat:@"\n"]];

    }

    return pdfString;
}
@end
