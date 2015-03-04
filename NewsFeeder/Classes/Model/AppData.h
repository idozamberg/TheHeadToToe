//
//  AppData.h
//  iCare
//
//  Created by ido zamberg on 20/12/13.
//  Copyright (c) 2013 ido zamberg. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "UIHelper.h"
#import "UICustomNavigationController.h"
#import "HTTFile.h"

#define SECTION_AG 0
#define SECTION_APS 1
#define SECTION_EX 2

typedef enum
{
    menuModeMain,
    menuModeSubMenu,
    menuModeClosed
}menuMode;

typedef enum
{
    viewModeStandAlone,
    viewModeInNavigation,
    viewModeFromHomeScreen
}viewMode;


@interface AppData : NSObject

+ (AppData*) sharedInstance;

// Properties
@property (strong,nonatomic) NSMutableDictionary* filesList;
@property (strong,nonatomic) NSMutableDictionary* questionsList;
@property (strong,nonatomic) NSMutableDictionary* labValues;
@property (strong,nonatomic) NSMutableDictionary* youTubeFilesList;
@property (strong,nonatomic) NSMutableArray* favoriteFilesList;


@property (strong,nonatomic) UICustomNavigationController* currNavigationController;

// Methods & Functions
- (void) performStartupOperations;
- (NSMutableArray*) flattenedFilesArray;
- (NSMutableArray*) flattenedVideosArray;
- (NSMutableArray*) flattenedLabArray;
- (NSMutableArray*) flattenedSearchArray;
- (NSMutableDictionary*) clearQuestions;
- (HTTFile*) videoIdentifierForTest : (NSString*) test;
- (void) saveFavoriteList;
- (void) loadFavoriteList;
- (void) addFileToFavorites : (HTTFile*) file;


@end
