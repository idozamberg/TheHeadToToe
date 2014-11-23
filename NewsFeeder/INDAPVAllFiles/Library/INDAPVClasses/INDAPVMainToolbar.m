
/********************************************************************************\
 *
 * File Name       INDAPVMainToolbar.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "Constant.h"
#import "INDAPVMainToolbar.h"
#import "INDAPVDocument.h"
#import "AppData.h"



@implementation INDAPVMainToolbar
{
    INDAPVDocument* currentDocument;
    UIDocumentInteractionController *documentInteraction;

}

#pragma mark Constants

#define BUTTON_X 10.0f
#define BUTTON_X_IPHONE 8.0f

#define BUTTON_Y 6.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 52.0f


#define DONE_BUTTON_WIDTH 52.0f
#define THUMBS_BUTTON_WIDTH 40.0f
#define PRINT_BUTTON_WIDTH 40.0f
#define EMAIL_BUTTON_WIDTH 40.0f
#define MARK_BUTTON_WIDTH 40.0f

#define TITLE_HEIGHT 28.0f

//Y
#define BUTTON_WIDTH_HEIGHT 22.0f
#define BUTTON_WIDTH_HEIGHT_IPHONE 22.0f
#define MARK_BUTTON_HEIGHT_IPHONE 22.0f


//End


#pragma mark Properties

@synthesize delegate;

#pragma mark INDAPVMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame document:nil];
}
 
- (id)initWithFrame:(CGRect)frame document:(INDAPVDocument *)object
{
	assert(object != nil); // Check

	if ((self = [super initWithFrame:frame]))
	{

        currentDocument = object;
#if (kApp_PDF_SubView == FALSE) // Option

        //Y Back
		btnDone = [UIButton buttonWithType:UIButtonTypeCustom];

		btnDone.frame = CGRectMake(BUTTON_X, BUTTON_Y, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
        [btnDone setImage:[UIImage imageNamed:@"back-50.png"] forState:UIControlStateNormal];
		[btnDone addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
				btnDone.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:btnDone];
        
#endif // end of kApp_PDF_SubView Option

#if (kApp_PDF_PreviewThumb == TRUE) // Option



#endif // end of kApp_PDF_PreviewThumb Option

		

#if (kApp_PDF_Bookmark == TRUE) // Option

        markButton = [UIButton buttonWithType:UIButtonTypeCustom];
        markButton.enabled = NO;
        markButton.tag = NSIntegerMin;
        markButton.userInteractionEnabled=NO;
        [self addSubview:markButton];
		markImageN = nil; // N image
		markImageY = [[UIImage imageNamed:@"bookmark-48.png"] retain]; // Y image

#endif // end of kApp_PDF_Bookmark Option

#if (kApp_PDF_Mail == TRUE) // Option

#endif // end of kApp_PDF_Mail Option

#if (kApp_PDF_Print == TRUE) // Option


#endif // end of kApp_PDF_Print Option
        
//Y
#if (kApp_PDF_PreviewThumb == TRUE) 
        
        //Y Setting
		btnSetting = [UIButton buttonWithType:UIButtonTypeCustom];
		[btnSetting setImage:[UIImage imageNamed:@"more-48.png"] forState:UIControlStateNormal];
		[btnSetting addTarget:self action:@selector(SettingButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		btnSetting.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:btnSetting];
        
        //Y Setting
        btnExport = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnExport setImage:[UIImage imageNamed:@"export-50.png"] forState:UIControlStateNormal];
        [btnExport addTarget:self action:@selector(tappedExportButton) forControlEvents:UIControlEventTouchUpInside];
        btnExport.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:btnExport];
        
        btnMail = [UIButton buttonWithType:UIButtonTypeCustom];
        [btnMail setImage:[UIImage imageNamed:@"message-50.png"] forState:UIControlStateNormal];
        [btnMail addTarget:self action:@selector(tappedEmailButton) forControlEvents:UIControlEventTouchUpInside];
        btnMail.autoresizingMask = UIViewAutoresizingNone;
        [self addSubview:btnMail];
        
        
        [self SetFramesForOrientation];
        
#endif
//End
        
//		if ([UIDevice currentDevice].userInterfaceIdiom == UIUserInterfaceIdiomPad)
//		{
        
            //Y Nav_Title
            CGRect titleRect;
            CGFloat aFloat=0.0f;
            
            if(isIpad())
            {
                aFloat=22.0f;
                
                //YP - (1-10-14) - New Code - Navbar Title
//                if(isIOS8())
//                {
//                    titleRect = CGRectMake(70, 10+appDelObj.intIOS7, 885, 40);//+260//885
//                }
//                else
//                {
                    //YP - (1-10-14) - Old Code
                    titleRect = CGRectMake(70, 10+appDelObj.intIOS7, 625, 40);
//                }
            }
            else
            {
                aFloat=14.0f;
                titleRect = CGRectMake(70, 2+appDelObj.intIOS7, 150, 40);
            }
        

			UILabel *titleLabel = [[UILabel alloc] initWithFrame:titleRect];

			titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:aFloat];
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
			//titleLabel.shadowColor = [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
			titleLabel.minimumFontSize = 14.0f;
			titleLabel.text = [object.fileName stringByDeletingPathExtension];
			[self addSubview:titleLabel];
            [titleLabel release];
        
		//}
	}

	return self;
}

- (void)dealloc
{
	[markButton release], markButton = nil;
	[markImageN release], markImageN = nil;
	[markImageY release], markImageY = nil;

	[super dealloc];
}

- (void)setBookmarkState:(BOOL)state
{
#if (kApp_PDF_Bookmark == TRUE) // Option

	if (state != markButton.tag) // Only if different state
	{
		if (self.hidden == NO) // Only if toolbar is visible
		{
			UIImage *image = (state ? markImageY : markImageN);

			[markButton setImage:image forState:UIControlStateNormal];
		}

		markButton.tag = state; // Update bookmarked state tag
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of kApp_PDF_Bookmark Option
}

- (void)updateBookmarkImage
{
#if (kApp_PDF_Bookmark == TRUE) // Option

	if (markButton.tag != NSIntegerMin) // Valid tag
	{
		BOOL state = markButton.tag; // Bookmarked state

		UIImage *image = (state ? markImageY : markImageN);

		[markButton setImage:image forState:UIControlStateNormal];
	}

	if (markButton.enabled == NO) markButton.enabled = YES;

#endif // end of kApp_PDF_Bookmark Option
}

- (void)hideToolbar
{
	if (self.hidden == NO)
	{
		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.alpha = 0.0f;
			}
			completion:^(BOOL finished)
			{
				self.hidden = YES;
			}
		];
	}
}

- (void)showToolbar
{
	if (self.hidden == YES)
	{
		[self updateBookmarkImage]; // First

		[UIView animateWithDuration:0.25 delay:0.0
			options:UIViewAnimationOptionCurveLinear | UIViewAnimationOptionAllowUserInteraction
			animations:^(void)
			{
				self.hidden = NO;
				self.alpha = 1.0f;
			}
			completion:NULL
		];
	}
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

- (void)emailButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self emailButton:button];
}

#pragma mark - Y

//Y
- (void)SettingButtonTapped:(UIButton *)button
{
    [delegate tappedInToolbar:self SettingButton:button];
}

#pragma mark - Orienatation Method

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self SetFramesForOrientation];
}

-(void)SetFramesForOrientation
{
    CGRect aFrameDone;
    CGRect aFrameSetting;
    CGRect aFrameExport;
    CGRect aFrameMail;
    CGRect aFrameMark;
    
    appDelObj.strOrientation = @"Portrait";
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        if(isIpad())
        {
            aFrameDone=CGRectMake(BUTTON_X, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
            aFrameSetting=CGRectMake(962, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
            aFrameMark=CGRectMake(856, BUTTON_Y+appDelObj.intIOS7, 100, 80);
        }
        else
        {
            aFrameDone=CGRectMake(BUTTON_X_IPHONE, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameSetting=CGRectMake(436+appDelObj.intiPhone5, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameMark=CGRectMake(387+appDelObj.intiPhone5, BUTTON_Y+appDelObj.intIOS7, MARK_BUTTON_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
        }
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        if(isIpad())
        {
            aFrameDone=CGRectMake(BUTTON_X, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
            aFrameSetting=CGRectMake(self.bounds.size.width - 50, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT, BUTTON_WIDTH_HEIGHT);
            aFrameMark=CGRectMake(600, BUTTON_Y+appDelObj.intIOS7, 100, 80);
            aFrameMail=CGRectMake(self.bounds.size.width - 60 - BUTTON_WIDTH_HEIGHT_IPHONE - 10, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameExport=CGRectMake(BUTTON_X_IPHONE + BUTTON_WIDTH_HEIGHT_IPHONE + 10, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
        }
        else
        {
            aFrameDone=CGRectMake(BUTTON_X_IPHONE, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameSetting=CGRectMake(self.bounds.size.width - 40, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameMail=CGRectMake(self.bounds.size.width - 40 - BUTTON_WIDTH_HEIGHT_IPHONE - 10, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameExport=CGRectMake(BUTTON_X_IPHONE + BUTTON_WIDTH_HEIGHT_IPHONE + 10, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            aFrameMark=CGRectMake(self.bounds.size.width - 40 - BUTTON_WIDTH_HEIGHT_IPHONE - 15 - BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_Y+appDelObj.intIOS7, MARK_BUTTON_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
        }
    }
    
    btnDone.frame = aFrameDone;
    btnSetting.frame = aFrameSetting;
    markButton.frame = aFrameMark;
    btnExport.frame = aFrameExport;
    btnMail.frame = aFrameMail;
}

- (void)tappedExportButton
{
    
    NSURL *fileURL = currentDocument.fileURL; // Document file URL
    
    documentInteraction = [[UIDocumentInteractionController interactionControllerWithURL:fileURL] retain];
    
    documentInteraction.delegate = self; // UIDocumentInteractionControllerDelegate
    
    [documentInteraction presentOpenInMenuFromRect:btnExport.bounds inView:btnExport animated:YES];
}

#pragma mark - UIDocumentInteractionControllerDelegate methods

- (void)documentInteractionControllerDidDismissOpenInMenu:(UIDocumentInteractionController *)controller
{
    documentInteraction = nil;
}


- (void)tappedEmailButton
{
    if ([MFMailComposeViewController canSendMail] == NO) return;
    
    unsigned long long fileSize = [currentDocument.fileSize unsignedLongLongValue];
    
    if (fileSize < 15728640ull) // Check attachment size limit (15MB)
    {
        NSURL *fileURL = currentDocument.fileURL; NSString *fileName = currentDocument.fileName;
        
        NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        
        if (attachment != nil) // Ensure that we have valid document file attachment data available
        {
            MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
            
            [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
            
            [mailComposer setSubject:fileName]; // Use the document file name for the subject
            
            mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            
            mailComposer.mailComposeDelegate = self; // MFMailComposeViewControllerDelegate
            
            [[AppData sharedInstance].currNavigationController presentViewController:mailComposer animated:YES completion:NULL];
        }
    }
}


- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [[AppData sharedInstance].currNavigationController dismissViewControllerAnimated:YES completion:NULL];
}


//End

@end
