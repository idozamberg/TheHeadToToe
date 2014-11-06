
/********************************************************************************\
 *
 * File Name       Constant.h
 * Author          $Author:: Yasika Patel       $: Author of last commit
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#ifndef PDFViewer_Constant_h
#define PDFViewer_Constant_h


//PDF Name & Type
//#define FileType    @"pdf"
//#define FileName1   @"iPhone Development"




//PDF Constant
#define kApp_PDF_Bookmark TRUE
#define kApp_PDF_Mail TRUE
#define kApp_PDF_Print TRUE
#define kApp_PDF_PreviewThumb TRUE
#define kApp_PDF_ISIdle FALSE
#define kApp_PDF_View_Shadow TRUE
#define kApp_PDF_SubView FALSE

//Device
#define isIphone5() (([[UIScreen mainScreen] bounds].size.height <= 480.0) ? 0 : 1)
#define isIphone() (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) ? 1 : 0)
#define isIpad() (([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0)
#define isIOS7() (([[[UIDevice currentDevice] systemVersion]doubleValue] >= 7.0) ? 1 : 0)

//YP - (1-10-14) - New Code
#define isIOS8() (([[[UIDevice currentDevice] systemVersion]doubleValue] >= 8.0) ? 1 : 0)

#define ClearColor [UIColor clearColor]


//KeyBoard
#define DoneKeyBoardBtn_Port_iPhone     CGRectMake(0, 163, 105, 53)//163
#define DoneKeyBoardBtn_Land_iPhone     CGRectMake(0, 123, 158, 39)
#define DoneUnSelectedImage_Port_iPhone [UIImage imageNamed:@"UnSelectedDone_Port_iPhone.png"]
#define DoneSelectedImage_Port_iPhone   [UIImage imageNamed:@"SelectedDone_Port_iPhone.png"]
#define DoneUnSelectedImage_Land_iPhone [UIImage imageNamed:@"UnSelectedDone_Land_iPhone.png"]
#define DoneSelectedImage_Land_iPhone   [UIImage imageNamed:@"SelectedDone_Land_iPhone.png"]
//KeyBoard iPhone5
#define DoneKeyBoardBtn_Land_iPhone5          CGRectMake(0, 123, 187, 39)
#define DoneKeyBoardBtn_Land_iPhone5_IOS8     CGRectMake(0, 123, 197, 39)

#endif
