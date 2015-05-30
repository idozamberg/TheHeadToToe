//
//  CustomNavViewController.m
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "CustomNavViewController.h"
#import "ATCAnimatedTransitioning.h"
#import "INDAPVDocument.h"
#import "INDAPVViewController.h"

@implementation CustomNavViewController


@synthesize navBarView,isShowingPdfView,animator,transitionClassName;



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	self.navBarView = [CustomNavigationBarView viewFromStoryboard];
	[self.navBarView setFrame:CGRectMake( 0, 0, [UIScreen mainScreen].bounds.size.width, 64 )];
    
    isShowingPdfView = NO;
    
   // self.navigationController.delegate = self;
}



// Override to allow orientations other than the default portrait orientation.
/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (( interfaceOrientation == UIInterfaceOrientationPortrait ) || 
            ( interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown ));
}
 */


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navBarView setBackgroundColor:gThemeColor];

    if (self.currentViewMode == viewModeStandAlone)
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"menu-50"]
                                    forState:UIControlStateNormal];
    }
    else
    {
        // Changing left button
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                    forState:UIControlStateNormal];
    }
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}



- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void) resize
{
    [super resize];
    
    CGRect frm = self.navBarView.frame;
    frm.origin.y -= gStatusBarHeight;
    [self.navBarView setFrame:frm];
}




#pragma mark --
#pragma mark -- NavBar Delegate --

- (void) didClickNavBarLeftButton
{
    CGRect frm = self.view.frame;
    frm.origin.x = 254;
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    [self.view setFrame:frm];
    [self setEnable:NO];
    
    [UIView commitAnimations];
}


#pragma mark --
#pragma mark -- Set navigationBar --

- (void) insertNavBarWithScreenName:(NSString *)screen
{
    self.navBarView.delegate = self;
	[self setContentWithDicName:screen];
	[self.view addSubview:self.navBarView];
}


- (void) setContentWithDicName:(NSString *)dicName
{
	if ([dicName isEqualToString:SCREEN_FEED]) {
		[self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_FEED
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:NO];
	}
    else if ([dicName isEqualToString:SCREEN_FEEDBACK]) {
        
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_FEEDBACK
                                                                    strID:STR_NAVTITLE]];
        
        
        [self.navBarView.rightButton setHidden:YES];
    }
    else if ([dicName isEqualToString:SCREEN_DOCUMENTS])
    {
            [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_DOCUMENTS
                                                                        strID:STR_NAVTITLE]];
            [self.navBarView.rightButton setHidden:NO];
    }
    else if ([dicName isEqualToString:SCREEN_HTT])
    {
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_HTT
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:NO];
    }
    else if ([dicName isEqualToString:SCREEN_LABORATOIRE])
    {
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_LABORATOIRE
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:YES];

    }
    else if ([dicName isEqualToString:SCREEN_VIDEOS])
    {
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_VIDEOS
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:NO];
        
    }
    else if ([dicName isEqualToString:SCREEN_WEBVIDEO])
    {
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_WEBVIDEO
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:YES];
        
    }
    else if ([dicName isEqualToString:SCREEN_ADMISSION])
    {
        [self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_ADMISSION
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:NO];
        [self.navBarView.rightButton setImage:[UIImage imageNamed:@"checkmark-50"]
                                     forState:UIControlStateNormal];
        [self.navBarView.middleButton setHidden:NO];
        [self.navBarView.middleButton setImage:[UIImage imageNamed:@"filter-50.png"]
                                     forState:UIControlStateNormal];
        [self.navBarView.farLeftMiddleButton setHidden:NO];
    }

    
    else if ([dicName isEqualToString:SCREEN_SEARCH]) {
		[self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_SEARCH
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.leftButton setImage:[UIImage imageNamed:@"navbar_back"]
                                    forState:UIControlStateNormal];
        [self.navBarView.rightButton setHidden:YES];
	}
    else if ([dicName isEqualToString:SCREEN_SETTING]) {
		[self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_SETTING
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.leftButton setTitle:@"Done"
                                    forState:UIControlStateNormal];
        [self.navBarView.leftButton setImage:nil
                                    forState:UIControlStateNormal];
        [self.navBarView.leftButton setTitleColor:[UIColor whiteColor]
                                         forState:UIControlStateNormal];
        [self.navBarView.leftButton setTitleColor:[UIColor lightGrayColor]
                                         forState:UIControlStateHighlighted];
        [self.navBarView.leftButton setFrame:CGRectMake( 5, 30, 60, 30 )];
        [self.navBarView.rightButton setHidden:YES];
	}
    else if ([dicName isEqualToString:SCREEN_ADD]) {
		[self.navBarView.lblTitle setText:[gAppDelegate getStringInScreen:SCREEN_ADD
                                                                    strID:STR_NAVTITLE]];
        [self.navBarView.rightButton setHidden:NO];
	}
}

- (void) resetElementsForMode:(BOOL)isPortrait {
    if (isPortrait) {
    }
    else {
    }
}


- (void) moveToMainView
{
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    [self.navigationController.view setUserInteractionEnabled:NO];
    self.navigationController.view.transform = CGAffineTransformIdentity;
    
    [UIView commitAnimations];
}

-(void)ShowPDFReaderWithFile : (HTTFile*) file
{
    // Adding file to favorites
    [[AppData sharedInstance] addFileToFavorites:file];
    
    // Showing file
    [self ShowPDFReaderWithName:file.name];
}


-(void)ShowPDFReaderWithName : (NSString*) name
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
    /*ReaderDocument *document = [ReaderDocument withDocumentFilePath:filePath password:phrase];
    readerController = [[ReaderViewController alloc] initWithReaderDocument:document];
    
    isShowingPdfView = YES;
    
    //[self.navigationController presentViewController:readerViewController animated:YES completion:Nil];
    
    [self.navigationController pushViewController:readerController animated:YES];*/
    [self openPdf:filePath];
}


- (BOOL) shouldAutorotate
{
    return NO;
}

-(void)openPdf:(NSString *) filePath

{
    NSString *password = @"";
    
    INDAPVDocument* document = [INDAPVDocument withDocumentFilePath:filePath password:password];
    
    if (document != nil)
        
    {
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SearchKeyWord"];
        
        [[NSUserDefaults standardUserDefaults] synchronize];
        
       INDAPVViewController*  aINDAPVViewController = [[INDAPVViewController alloc] initWithPath:filePath andPassword:password];
        
        aINDAPVViewController.delegate = self;
        
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
        
        self.navigationController.navigationBarHidden=TRUE;
        [self.navigationController pushViewController:aINDAPVViewController animated:YES];
        
    }
    
    else
        
    {
        
        NSLog(@"Fix file path");
        
    }
    
}

/*
-(NSUInteger)supportedInterfaceOrientations
{
    UIDeviceOrientation aInterfaceOrientationObj = [[UIDevice currentDevice] orientation];
    if (aInterfaceOrientationObj == UIInterfaceOrientationLandscapeLeft)
    {
        appDelObj.strOrientation = @"Landscape";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationLandscapeRight)
    {
        appDelObj.strOrientation = @"LandscapeRight";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationPortrait)
    {
        appDelObj.strOrientation = @"Portrait";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationPortraitUpsideDown)
    {
        appDelObj.strOrientation = @"PortraitUpsideDown";
    }
    
    if(boolPrinterShow==YES)
    {
        return UIInterfaceOrientationMaskAllButUpsideDown;
    }
    else
        return UIInterfaceOrientationMaskPortrait;
    
}

#pragma mark -- Before IOS6 Orientation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        appDelObj.strOrientation = @"Landscape";
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        appDelObj.strOrientation = @"LandscapeRight";
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        appDelObj.strOrientation = @"Portrait";
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        appDelObj.strOrientation = @"PortraitUpsideDown";
    }
    
    
    if(boolPrinterShow==YES){
        if([appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
            return NO;
        else
            return NO;
    }
    else
        return NO;
}
*/

-(void)ShowPrinter:(BOOL)aBool
{
    boolPrinterShow=aBool;
}

@end
