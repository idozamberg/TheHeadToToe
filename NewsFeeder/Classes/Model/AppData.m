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
#import "LabValue.h"
#import "YouTubeVideoFile.h"
#import "HTTFavoriteFile.h"

@implementation AppData
@synthesize questionsList = _questionsList,currNavigationController,youTubeFilesList = _youTubeFilesList;
@synthesize favoriteFilesList = _favoriteFilesList;

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
    [self loadYouTubeFileList];
    [self loadFavoriteList];
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
                newFile.system = system;
                
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
                        NSArray* texts = [UIHelper seprateStringsWithString:currentQuestion];
                        
                        // Setting new question
                        AdmissionQuestion* newQuestion = [AdmissionQuestion new];
                        
                        // Setting question section
                        newQuestion.questionSection    = currentArrayKey;
                        newQuestion.text               = [texts objectAtIndex:0];
                        
                        // Setting text for when question is not checked
                        if (texts.count > 1)
                        {
                            // Removing white space and setting non checked question
                            newQuestion.nonCheckedText = [[texts objectAtIndex:1] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
                        }
                        
                        // Setting text for when question is checked
                        if (texts.count > 2)
                        {
                            newQuestion.checkedText = [texts objectAtIndex:2];
                        }
                        
                        newQuestion.comment = @"";
                        newQuestion.wasChecked = NO;
                    
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

- (NSMutableDictionary*) clearQuestions
{
    [self loadQuestions];
    
    return _questionsList;
}

- (NSArray*) getSortedKeysArrayForDictionary :(NSDictionary*) dict
{
     NSArray *arr =  [[dict allKeys] sortedArrayUsingSelector:@selector(localizedStandardCompare:)];
    
    return arr;
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
        
        // Getting sorted keys array
        NSArray* keysArray = [self getSortedKeysArrayForDictionary:currentTypeDict];
        
        // Going through all values and creating a native object
        for (NSString* currValue in keysArray)
        {
            LabValue* newValue = [LabValue new];
            
            // Removing number from key
            NSArray* splitLabKey = [currValue componentsSeparatedByString:@"."];
            
            // Setting values
            newValue.name  = [splitLabKey objectAtIndex:1];
            newValue.value = [currentTypeDict objectForKey:currValue];
            
            [currentValuesArray addObject:newValue];
        }
        
        // Adding array to our dictionary
        [self.labValues setObject:currentValuesArray forKey:examType];
    }
    
    // Loading list and saving to memory
}

- (void) loadYouTubeFileList
{
    self.youTubeFilesList = [NSMutableDictionary new];
    
    NSMutableDictionary* files = [UIHelper dictionaryFromPlistWithName:@"Videos"];
    
    // Convert dictionary to native object
    for (NSString* system in [files allKeys])
    {
        if ([[files valueForKey:system] isKindOfClass:[NSArray class]])
        {
            // Going through all files
            for (NSDictionary* currentFileDict in [files valueForKey:system])
            {
                // Setting new file
                YouTubeVideoFile* newFile = [YouTubeVideoFile new];
                newFile.name = [currentFileDict valueForKey:@"Name"];
                newFile.fileDescription = [currentFileDict valueForKey:@"Description"];
                newFile.system = system;
                
                // if it's the first file
                if (![_youTubeFilesList objectForKey:system])
                {
                    // Adding file while creating and array
                    [_youTubeFilesList setObject:[NSMutableArray arrayWithObject:newFile] forKey:system];
                }
                else
                {
                    // just add the file
                    [[_youTubeFilesList objectForKey:system] addObject:newFile];
                }
            }
        }
    }
    
    // Loading list and saving to memory
}




- (NSMutableArray*) flattenedFilesArray
{
    NSMutableArray* flatArray = [NSMutableArray new];
    
    // Going through all systems
    for (NSArray* system in [self.filesList allValues])
    {
        // Add array to flattend array
        [flatArray addObjectsFromArray:system];
    }
    
    return flatArray;
}

- (NSMutableArray*) flattenedVideosArray
{
    NSMutableArray* flatArray = [NSMutableArray new];
    
    // Going through all systems
    for (NSArray* system in [self.youTubeFilesList allValues])
    {
        // Add array to flattend array
        [flatArray addObjectsFromArray:system];
    }
    
    return flatArray;
}

- (NSMutableArray*) flattenedLabArray
{
    NSMutableArray* flatArray = [NSMutableArray new];
    
    // Going through all systems
    for (NSArray* system in [self.labValues allValues])
    {
        // Add array to flattend array
        [flatArray addObjectsFromArray:system];
    }
    
    return flatArray;
}

- (NSMutableArray*) flattenedSearchArray
{
    NSMutableArray* flatArray = [NSMutableArray arrayWithObjects:[self flattenedFilesArray],[self flattenedLabArray],[self flattenedVideosArray] ,nil];
    
    return flatArray;
}

- (HTTFile*) videoIdentifierForTest : (NSString*) test
{
    // Getting flat array
    NSMutableArray* allVideos;//[self flattenedVideosArray];
    
    // Creating predicate for files and videos
    NSPredicate *filePredicate =
    [NSPredicate predicateWithFormat:@"(SELF.name contains[cd] %@) OR (SELF.fileDescription contains[cd] %@) OR (SELF.system contains[cd] %@)" ,test,test,test];
    
    // Flitering array
    allVideos = ((NSMutableArray*)[[self flattenedVideosArray] filteredArrayUsingPredicate:filePredicate]);
    
    if (allVideos.count > 0)
    {
        return [allVideos objectAtIndex:0];
    }
    
    return Nil;
}

 - (void) saveFavoriteList
{
    // Saving favorite list
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.favoriteFilesList];
    [userDefaults setObject:data forKey:@"favoriteList"];
    [userDefaults synchronize];
}

- (void) loadFavoriteList
{
    // Retrieving favorite list
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [userDefaults objectForKey:@"favoriteList"];
    self.favoriteFilesList = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [userDefaults synchronize];
    
    // If list is empty
    if (!self.favoriteFilesList)
    {
        self.favoriteFilesList = [NSMutableArray new];
    }
    else
    {
        [self sortFavoritesArray];
    }
    
}

- (void) sortFavoritesArray
{
    // Sorting array by number of times opened
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"numberOfTimesFileWasOpened"
                                                 ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObject:sortDescriptor];
    [self.favoriteFilesList sortUsingDescriptors:sortDescriptors];
}

- (void) addFileToFavorites : (HTTFile*) file
{
    BOOL doesExist = NO;
    
    // If file exist change number of times
    for (HTTFavoriteFile* currFile in self.favoriteFilesList)
    {
        // Check if file exist
        if ([currFile.name isEqualToString:file.name])
        {
            doesExist = YES;
            // Adding one
            NSNumber* newNumber = [NSNumber numberWithInteger:([currFile.numberOfTimesFileWasOpened integerValue] + 1)];
            currFile.numberOfTimesFileWasOpened = newNumber;
        }
    }

    if (!doesExist)
    {
        // Adding new file
        HTTFavoriteFile* favorite = [[HTTFavoriteFile alloc] initWithFile:file];
        [self.favoriteFilesList addObject:favorite];
    }
    
    // Saving changes
    [self saveFavoriteList];
    [self sortFavoritesArray];
}

@end