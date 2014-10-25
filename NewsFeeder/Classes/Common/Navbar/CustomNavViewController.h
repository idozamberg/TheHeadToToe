//
//  CustomNavViewController.h
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SuperViewController.h"
#import "CustomNavigationBarView.h"
#import "ReaderViewController.h"


@interface CustomNavViewController : SuperViewController<CustomNavBarViewDelegate,UINavigationControllerDelegate> {
	CustomNavigationBarView * navBarView;
    
    NSString *navBGFile;
}

@property (nonatomic, retain) CustomNavigationBarView * navBarView;
@property (nonatomic, strong) ReaderViewController* readerController;
@property (nonatomic)         BOOL isShowingPdfView;
@property (nonatomic, strong) NSString *transitionClassName;
@property (nonatomic, strong) id animator;



- (void) insertNavBarWithScreenName:(NSString *)screen;
- (void) setContentWithDicName:(NSString *)dicName;

- (void) resetElementsForMode:(BOOL)isPortrait;

- (void) moveToMainView;

-(void)ShowPDFReaderWithName : (NSString*) name;


@end
