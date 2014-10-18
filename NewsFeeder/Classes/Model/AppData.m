//
//  AppData.m
//  iCare
//
//  Created by ido zamberg on 20/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import "AppData.h"
#import "HTTFile.h"
#import "AdmissionQuestion.h"
#import "ReaderDocument.h"
#import "LabValue.h"

@implementation AppData
@synthesize questionsList = _questionsList,currNavigationController;

static AppData* shareData;


+ (AppData*) sharedInstance
{
    if (!shareData)
   {
       shareData = [AppData new];
   }
    
    return shareData;
}

- (void) performStartupOperations
{
    
    NSFileManager *fileManager = [NSFileManager new];
    
    NSURL *pathURL = [fileManager URLForDirectory:NSDocumentDirectory inDomain:NSUserDomainMask appropriateForURL:nil create:YES error:NULL];
    
    NSString *documentsPath = [pathURL path];
    
    for (NSString *sourcePath in [[NSBundle mainBundle] pathsForResourcesOfType:@"pdf" inDirectory:nil]) // PDFs
    {
        NSString *targetPath = [documentsPath stringByAppendingPathComponent:[sourcePath lastPathComponent]];
        
        //[fileManager removeItemAtPath:targetPath error:NULL]; // Delete target file
        
        [fileManager copyItemAtPath:sourcePath toPath:targetPath error:NULL];
    }
    
    [self loadFilesList];
    [self loadQuestions];
    [self loadLabValues];
}

- (void) loadFilesList
{
    self.filesList = [NSMutableDictionary new];
    
    NSMutableDictionary* files = [UIHelper dictionaryFromPlistWithName:@"filesList"];
    
    // Convert dictionary to native object
    for (NSString* system in [files allKeys])
    {
        if ([[files valueForKey:system] isKindOfClass:[NSArray class]])
        {
            // Going through all files
            for (NSDictionary* currentFileDict in [files valueForKey:system])
            {
                // Setting new file
                HTTFile* newFile = [HTTFile new];
                newFile.name = [currentFileDict valueForKey:@"Name"];
                newFile.fileDescription = [currentFileDict valueForKey:@"Description"];

                
                // if it's the first file
                if (![_filesList objectForKey:system])
                {
                    // Adding file while creating and array
                    [_filesList setObject:[NSMutableArray arrayWithObject:newFile] forKey:system];
                }
                else
                {
                    // just add the file
                    [[_filesList objectForKey:system] addObject:newFile];
                }
            }
        }
    }
    
    // Loading list and saving to memory
}

- (void) loadQuestions
{
    self.questionsList = [NSMutableDictionary new];
    
    NSMutableDictionary* questions = [UIHelper dictionaryFromPlistWithName:@"entree"];

    // Convert dictionary to native object
    for (NSString* part in [questions allKeys])
    {
        NSMutableDictionary* questionsDictionary = [NSMutableDictionary new];
        
        if ([[questions valueForKey:part] isKindOfClass:[NSDictionary class]])
        {
            // Going through all qyestion
            for (NSString* currentArrayKey in [[questions valueForKey:part] allKeys])
            {
                // Getting current question  array
                NSArray* currentQuestionArray = [[questions valueForKey:part] objectForKey:currentArrayKey];
                
                if ([currentQuestionArray isKindOfClass:[NSArray class]])
                {
                    for (NSString* currentQuestion in currentQuestionArray)
                    {
                        // Setting new question
                        AdmissionQuestion* newQuestion = [AdmissionQuestion new];
                        newQuestion.text               = currentQuestion;
                    
                        // if it's the first question
                        if (![questionsDictionary objectForKey:currentArrayKey])
                        {
                            // Adding file while creating and array
                            [questionsDictionary setObject:[NSMutableArray arrayWithObject:newQuestion] forKey:currentArrayKey];
                        }
                        else
                        {
                            // just add the file
                            [[questionsDictionary objectForKey:currentArrayKey] addObject:newQuestion];
                        }
                    }
                }
                else
                {
                    
                    // Adding file while creating and array
                    [questionsDictionary setObject:currentQuestionArray forKey:currentArrayKey];
                }
            }
            
            [self.questionsList setObject:questionsDictionary forKey:part];
        }
    }

}

- (void) loadLabValues
{
    self.labValues = [NSMutableDictionary new];
    
    NSMutableDictionary* labsValuesDict = [UIHelper dictionaryFromPlistWithName:@"Labo"];
    
    // Convert dictionary to native object
    for (NSString* examType in [labsValuesDict allKeys])
    {
        // Getting current values
        NSDictionary* currentTypeDict = [labsValuesDict objectForKey:examType];
        
        NSMutableArray* currentValuesArray = [NSMutableArray new];
        
        // Going through all values and creating a native object
        for (NSString* currValue in [currentTypeDict allKeys])
        {
            LabValue* newValue = [LabValue new];
            newValue.name  =currValue;
            newValue.value = [currentTypeDict objectForKey:currValue];
            
            [currentValuesArray addObject:newValue];
        }
        
        // Adding array to our dictionary
        [self.labValues setObject:currentValuesArray forKey:examType];
    }
    
    // Loading list and saving to memory
}

@end