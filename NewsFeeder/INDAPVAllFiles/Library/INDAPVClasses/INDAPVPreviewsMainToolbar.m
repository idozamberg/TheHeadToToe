
/********************************************************************************\
 *
 * File Name       INDAPVPreviewsMainToolbar.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "Constant.h"
#import "INDAPVPreviewsMainToolbar.h"

@implementation INDAPVPreviewsMainToolbar

#pragma mark Constants

#define BUTTON_X 10.0f
#define BUTTON_X_IPhone 8.0f
#define BUTTON_WIDTH_HEIGHT_IPHONE 22.0f

#define BUTTON_SPACE 8.0f
#define TITLE_HEIGHT 28.0f

//Y
#define BUTTON_Y 9.0f
#define DONE_BUTTON_WIDTH 24.0f
#define SHOW_CONTROL_WIDTH 24.0f
#define BUTTON_HEIGHT 24.0f
//End



#pragma mark Properties

@synthesize delegate;

#pragma mark ThumbsMainToolbar instance methods

- (id)initWithFrame:(CGRect)frame
{
	return [self initWithFrame:frame title:nil];
}

- (id)initWithFrame:(CGRect)frame title:(NSString *)title
{
	if ((self = [super initWithFrame:frame]))
	{
        
        appDelObj.strOrientation = @"Portrait";

		CGFloat viewWidth = self.bounds.size.width;
		CGFloat titleX = BUTTON_X; CGFloat titleWidth = (viewWidth - (titleX + titleX));

		UIButton *doneButton = [UIButton buttonWithType:UIButtonTypeCustom];
        if(isIpad())
            doneButton.frame = CGRectMake(BUTTON_X, BUTTON_Y+appDelObj.intIOS7, DONE_BUTTON_WIDTH, BUTTON_HEIGHT);
        else
            doneButton.frame = CGRectMake(BUTTON_X_IPhone, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            
		[doneButton addTarget:self action:@selector(doneButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
		[doneButton setBackgroundImage:[UIImage imageNamed:@"checkmark-48.png"] forState:UIControlStateNormal];
		doneButton.titleLabel.font = [UIFont systemFontOfSize:14.0f];
		doneButton.autoresizingMask = UIViewAutoresizingNone;

		[self addSubview:doneButton];
		titleX += (DONE_BUTTON_WIDTH + BUTTON_SPACE);
        titleWidth -= (DONE_BUTTON_WIDTH + BUTTON_SPACE);

#if (kApp_PDF_Bookmark == TRUE) // Option

	        
        btnMultiPage = [UIButton buttonWithType:UIButtonTypeCustom];
        btnMultiPage.tag=5001;
        [btnMultiPage addTarget:self action:@selector(showControlTapped:) forControlEvents:UIControlEventTouchUpInside];
		[btnMultiPage setBackgroundImage:[UIImage imageNamed:@"categorize-48.png"] forState:UIControlStateNormal];
        btnMultiPage.autoresizingMask = UIViewAutoresizingNone;
        
		[self addSubview:btnMultiPage];
        
        btnBookmark = [UIButton buttonWithType:UIButtonTypeCustom];
        btnBookmark.tag=5002;
        [btnBookmark addTarget:self action:@selector(showControlTapped:) forControlEvents:UIControlEventTouchUpInside];
		[btnBookmark setBackgroundImage:[UIImage imageNamed:@"bookmark-48.png"] forState:UIControlStateNormal];
        btnBookmark.autoresizingMask = UIViewAutoresizingNone;
		[self addSubview:btnBookmark];
        
        [self SetFramesForOrientation];
		titleWidth -= (SHOW_CONTROL_WIDTH + BUTTON_SPACE);

#endif // end of kApp_PDF_Bookmark Option

		
            //Y Nav_Title
            CGRect titleRect;
            CGFloat aFloat;
            titleLabel = [[UILabel alloc] init];
        
            if(isIpad())
            {
                aFloat=22.0f;
                titleRect = CGRectMake(130, 10+appDelObj.intIOS7, 490, 40);
                
                //YP - (1-10-14) - New Code - Bookmark Nav Title
                if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
                {
                    if(isIOS8())
                    {
                        titleRect = CGRectMake(130, 10+appDelObj.intIOS7, 490+260, 40);
                    }
                }
                
                
                //YP - (1-10-14) - Old Code
                //titleRect = CGRectMake(130, 10+appDelObj.intIOS7, 490, 40);
                titleLabel.textAlignment = UITextAlignmentCenter;
            }
            else
            {
                aFloat=14.0f;
                titleRect = CGRectMake(50, 2+appDelObj.intIOS7, 175, 40);
                
                //YP - (1-10-14) - New Code - Bookmark Nav Title
                if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
                {
                    if(isIOS8())
                    {
                        titleRect = CGRectMake(50, 2+appDelObj.intIOS7, 425, 40);
                    }
                    titleLabel.textAlignment = UITextAlignmentCenter;
                }
                else
                {
                    titleLabel.textAlignment = UITextAlignmentCenter;
                }
                
                
                //YP - (1-10-14) - Old Code
                //if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
                //    titleLabel.textAlignment = UITextAlignmentCenter;
                //else
                //    titleLabel.textAlignment = UITextAlignmentRight;
            }
        
            titleLabel.frame=titleRect;
			titleLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:aFloat];
			titleLabel.autoresizingMask = UIViewAutoresizingFlexibleWidth;
			titleLabel.baselineAdjustment = UIBaselineAdjustmentAlignCenters;
			titleLabel.textColor = [UIColor colorWithWhite:0.0f alpha:1.0f];
            //titleLabel.shadowColor = [UIColor colorWithWhite:0.65f alpha:1.0f];
			titleLabel.backgroundColor = [UIColor clearColor];
			titleLabel.shadowOffset = CGSizeMake(0.0f, 1.0f);
			titleLabel.adjustsFontSizeToFitWidth = YES;
			titleLabel.minimumFontSize = 14.0f;
			titleLabel.text = title;

			[self addSubview:titleLabel];
            [titleLabel release];
		
	}

	return self;
}

- (void)dealloc
{
	[super dealloc];
}

#pragma mark UISegmentedControl action methods

- (void)showControlTapped:(id)sender
{
    [delegate tappedInToolbar:self showControl:sender];
}

#pragma mark UIButton action methods

- (void)doneButtonTapped:(UIButton *)button
{
	[delegate tappedInToolbar:self doneButton:button];
}

#pragma mark - Orientation Methods

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{ 
}
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self SetFramesForOrientation];
}

-(void)SetFramesForOrientation
{
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        if(isIpad())
        {
            btnMultiPage.frame = CGRectMake(self.frame.size.width - 74, BUTTON_Y+appDelObj.intIOS7, SHOW_CONTROL_WIDTH, BUTTON_HEIGHT);
            btnBookmark.frame = CGRectMake(self.frame.size.width - 50, BUTTON_Y+appDelObj.intIOS7, SHOW_CONTROL_WIDTH, BUTTON_HEIGHT);
        }
        else
        {
            btnMultiPage.frame = CGRectMake(392+(appDelObj.intiPhone5), BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            btnBookmark.frame = CGRectMake(436+(appDelObj.intiPhone5), BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            
            titleLabel.textAlignment = UITextAlignmentCenter;
        }
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        if(isIpad())
        {
            btnMultiPage.frame = CGRectMake(self.frame.size.width - 88, BUTTON_Y+appDelObj.intIOS7, SHOW_CONTROL_WIDTH, BUTTON_HEIGHT);
            btnBookmark.frame = CGRectMake(self.frame.size.width - 50, BUTTON_Y+appDelObj.intIOS7, SHOW_CONTROL_WIDTH, BUTTON_HEIGHT);
        }
        else
        {
            btnMultiPage.frame = CGRectMake(self.bounds.size.width - 44 - BUTTON_WIDTH_HEIGHT_IPHONE - 10, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, BUTTON_WIDTH_HEIGHT_IPHONE);
            btnBookmark.frame = CGRectMake(self.bounds.size.width - 44, BUTTON_Y+appDelObj.intIOS7, BUTTON_WIDTH_HEIGHT_IPHONE, 25);
            titleLabel.frame = CGRectMake(50, appDelObj.intIOS7, 175, 40);
            titleLabel.textAlignment = UITextAlignmentCenter;
        }
    }
}

//End
@end
