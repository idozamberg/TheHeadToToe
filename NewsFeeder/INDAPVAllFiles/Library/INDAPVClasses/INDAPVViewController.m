
/********************************************************************************\
 *
 * File Name       INDAPVViewController.m
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "Constant.h"
#import "INDAPVViewController.h"
#import "INDAPVPreviewCache.h"
#import "INDAPVPreviewQueue.h"
#import "INDAPVScanner.h"
#import "CGPDFDocument.h"

@implementation INDAPVViewController
@synthesize selections, scanner,keyword;

#pragma mark Constants

#define PAGING_VIEWS 3

#define TOOLBAR_HEIGHT 44.0f
#define PAGEBAR_HEIGHT 60.0f

#define TAP_AREA_SIZE 48.0f
#define BUTTON_X 8.0f
#define BUTTON_Y 8.0f
#define BUTTON_SPACE 8.0f
#define BUTTON_HEIGHT 30.0f

#define DONE_BUTTON_WIDTH 56.0f
#define SHOW_CONTROL_WIDTH 78.0f

#define TITLE_HEIGHT 28.0f

//Y HM
#define PinkColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_Red.png"]]
#define MenuIconFrame CGRectMake(0, 0, 65, 65)//HM Menu
//End

#pragma mark Properties

@synthesize delegate;
@synthesize searchBarObj;
#pragma mark Support methods

- (void)updateScrollViewContentSize
{
    //NSLog(@"updateScrollViewContentSize page :%d",[document.pageCount integerValue]);
    
    NSInteger count = [document.pageCount integerValue];
    if (count > PAGING_VIEWS) count = PAGING_VIEWS; // Limit
    CGFloat contentHeight = theScrollView.bounds.size.height;
    CGFloat contentWidth = (theScrollView.bounds.size.width * count);
    theScrollView.contentSize = CGSizeMake(contentWidth, contentHeight);
}

- (void)updateScrollViewContentViews
{
    //NSLog(@"%@",document.pageCount);

    [self updateScrollViewContentSize]; // Update the content size
    NSMutableIndexSet *pageSet = [NSMutableIndexSet indexSet]; // Page set
    [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
     ^(id key, id object, BOOL *stop)
     {
         INDAPVContentView *contentView = object; [pageSet addIndex:contentView.tag];
         //NSLog(@"%@",document.pageCount);
     }
     ];
    
    __block CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;
    __block CGPoint contentOffset = CGPointZero; NSInteger page = [document.pageNumber integerValue];
    
    [pageSet enumerateIndexesUsingBlock: // Enumerate page number set
     ^(NSUInteger number, BOOL *stop)
     {
         NSNumber *key = [NSNumber numberWithInteger:number]; // # key
         INDAPVContentView *contentView = [contentViews objectForKey:key];
         contentView.frame = viewRect; if (page == number) contentOffset = viewRect.origin;
         viewRect.origin.x += viewRect.size.width; // Next view frame position
         //NSLog(@"%@",document.pageCount);

     }
     ];
    
    if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
    {
       // NSLog(@"%@",document.pageCount);

        theScrollView.contentOffset = contentOffset; // Update content offset
    }
}

- (void)updateToolbarBookmarkIcon
{
    NSInteger page = [document.pageNumber integerValue];
    BOOL bookmarked = [document.bookmarks containsIndex:page];
    [mainToolbar setBookmarkState:bookmarked]; // Update
}

-(void)ShowAlertView:(NSString *)aAlertMsg
{
    UIAlertView *alertView=[[UIAlertView alloc]initWithTitle:@"PDF Viewer" message:aAlertMsg delegate:self cancelButtonTitle:@"Ok" otherButtonTitles:nil, nil];//Wrong Page Number !!
    [alertView show];
    [alertView release];
}

- (void)showDocumentPage:(NSInteger)page
{
   //NSLog(@"My Page Number :%@",document.pageNumber);
    if (page != currentPage) // Only if different
    {
        NSInteger minValue; NSInteger maxValue;
        NSInteger maxPage = [document.pageCount integerValue];
        NSInteger minPage = 1;
        
        if ((page < minPage) || (page > maxPage))
        {
            [searchBarObj setText:@""];
            [self ShowAlertView:[NSString stringWithFormat:@"Oops!! This Document Has Only %d Pages.",maxPage]];
            
            return;
        }
        
        if (maxPage <= PAGING_VIEWS) // Few pages
        {
            minValue = minPage;
            maxValue = maxPage;
        }
        else // Handle more pages
        {
            minValue = (page - 1);
            maxValue = (page + 1);
            
            if (minValue < minPage)
            {minValue++; maxValue++;}
            else
                if (maxValue > maxPage)
                {minValue--; maxValue--;}
        }
        
        NSMutableIndexSet *newPageSet = [NSMutableIndexSet new];
        NSMutableDictionary *unusedViews = [contentViews mutableCopy];
        CGRect viewRect = CGRectZero; viewRect.size = theScrollView.bounds.size;
        
        for (NSInteger number = minValue; number <= maxValue; number++)
        {
            NSNumber *key = [NSNumber numberWithInteger:number]; // # key
            
            INDAPVContentView *contentView = [contentViews objectForKey:key];
            
            if(Searching==YES && number==page  )
            {
                [contentView removeFromSuperview];
                for(UIView *bw in theScrollView.subviews)
                {
                    if(bw.tag == number-1)
                    {
                        [bw removeFromSuperview];
                    }
                }
                NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
                
                contentView = [[INDAPVContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
                contentView.tag=number;
                [theScrollView addSubview:contentView]; [contentViews setObject:contentView forKey:key];
                
                contentView.message = self;
                [contentView zoomReset];
                [unusedViews removeObjectForKey:key];
                contentView.frame = viewRect;
                [contentView release];
            }
            else if(Searching==YES && number== (page+1)  )
            {
                [contentView removeFromSuperview];
                for(UIView *bw in theScrollView.subviews)
                {
                    if(bw.tag == number-1)
                    {
                    }
                }
                NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
                
                contentView = [[INDAPVContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
                contentView.tag=number;
                [theScrollView addSubview:contentView]; [contentViews setObject:contentView forKey:key];
                
                contentView.message = self;
                [contentView zoomReset];
                [unusedViews removeObjectForKey:key];
                contentView.frame = viewRect;
                [contentView release];
            }
            else if (contentView == nil) // Create a brand new document content view
            {
                NSURL *fileURL = document.fileURL; NSString *phrase = document.password; // Document properties
                contentView = [[INDAPVContentView alloc] initWithFrame:viewRect fileURL:fileURL page:number password:phrase];
                [theScrollView addSubview:contentView];
                [contentViews setObject:contentView forKey:key];
                contentView.message = self; [contentView release];
                // contentView.strViewKeyWord=keyword;
                [newPageSet addIndex:number];
            }
            else // Reposition the existing content view
            {
                contentView.frame = viewRect; [contentView zoomReset];
                //contentView.strViewKeyWord=keyword;
                [unusedViews removeObjectForKey:key];
            }
            viewRect.origin.x += viewRect.size.width;
        }
        Searching=NO;
        
        [unusedViews enumerateKeysAndObjectsUsingBlock: // Remove unused views
         ^(id key, id object, BOOL *stop)
         {
             [contentViews removeObjectForKey:key];
             
             INDAPVContentView *contentView = object;
             
             [contentView removeFromSuperview];
         }
         ];
        
        [unusedViews release], unusedViews = nil; // Release unused views
        
        CGFloat viewWidthX1 = viewRect.size.width;
        CGFloat viewWidthX2 = (viewWidthX1 * 2.0f);
        
        CGPoint contentOffset = CGPointZero;
        
        if (maxPage >= PAGING_VIEWS)
        {
            if (page == maxPage)
                contentOffset.x = viewWidthX2;
            else
                if (page != minPage)
                    contentOffset.x = viewWidthX1;
        }
        else
            if (page == (PAGING_VIEWS - 1))
                contentOffset.x = viewWidthX1;
        
        if (CGPointEqualToPoint(theScrollView.contentOffset, contentOffset) == false)
        {
            theScrollView.contentOffset = contentOffset; // Update content offset
        }
        
        if ([document.pageNumber integerValue] != page) // Only if different
        {
            document.pageNumber = [NSNumber numberWithInteger:page]; // Update page number
        }
        
        NSURL *fileURL = document.fileURL; NSString *phrase = document.password; NSString *guid = document.guid;
        
        if ([newPageSet containsIndex:page] == YES) // Preview visible page first
        {
            NSNumber *key = [NSNumber numberWithInteger:page]; // # key
            
            INDAPVContentView *targetView = [contentViews objectForKey:key];
            //targetView.strViewKeyWord=keyword;
            [targetView showPageThumb:fileURL page:page password:phrase guid:guid];
            
            //NSLog(@"showDocumentPage page :%d",page);
            [newPageSet removeIndex:page]; // Remove visible page from set
        }
        
        [newPageSet enumerateIndexesWithOptions:NSEnumerationReverse usingBlock: // Show previews
         ^(NSUInteger number, BOOL *stop)
         {
             NSNumber *key = [NSNumber numberWithInteger:number]; // # key
             
             INDAPVContentView *targetView = [contentViews objectForKey:key];
             // targetView.strViewKeyWord=keyword;
             [targetView showPageThumb:fileURL page:number password:phrase guid:guid];
         }
         ];
        
        [newPageSet release], newPageSet = nil; // Release new page set
        
        [mainPagebar updatePagebar]; // Update the pagebar display
        
        [self updateToolbarBookmarkIcon]; // Update bookmark
        
        currentPage = page; // Track current page number
        
//YP
//        if ([document.pageNumber intValue] != page) {
//            document.pageNumber = @(page);
//        }
    }
}

- (void)showDocument:(id)object
{
    [self updateScrollViewContentSize]; // Set content size
   // NSLog(@"showDocument page :%d",[document.pageNumber integerValue]);
    [self showDocumentPage:[document.pageNumber integerValue]]; // Show
    document.lastOpen = [NSDate date]; // Update last opened date
    
    isVisible = YES; // iOS present modal bodge
}

#pragma mark UIViewController methods

//YP - (7-10-14) - New COde
- (id)initWithPath:(NSString*)path andPassword:(NSString*)password
{
    document = [INDAPVDocument withDocumentFilePath:path password:password];
    return [self initWithReaderDocument:document];
}

- (id)initWithReaderDocument:(INDAPVDocument *)object
{
    id reader = nil;
    
    if ((object != nil) && ([object isKindOfClass:[INDAPVDocument class]]))
    {
        if ((self = [super initWithNibName:nil bundle:nil])) // Designated initializer
        {
            NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
            
            [notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillTerminateNotification object:nil];
            
            [notificationCenter addObserver:self selector:@selector(applicationWill:) name:UIApplicationWillResignActiveNotification object:nil];
            
            [object updateProperties]; [document retain];//document = [object retain]; // Retain the supplied INDAPVDocument object for our use
            
            [INDAPVPreviewCache touchThumbCacheWithGUID:object.guid]; // Touch the document thumb cache directory
            
            reader = self; // Return an initialized ReaderViewController object
        }
    }
    
    return reader;
}

#pragma mark - View Methods

- (void)viewDidLoad//2
{
    [super viewDidLoad];
    
    NSAssert(!(document == nil), @"ReaderDocument == nil");
    
    assert(self.splitViewController == nil); // Not supported (sorry)
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_Red.png"]];
    
    strSearch=@"";
    intClickBtn=0;
    
    if(isIOS7())
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    CGRect viewRect = self.view.bounds; // View controller's view bounds
    
    theScrollView = [[UIScrollView alloc] initWithFrame:viewRect]; // All
    
    theScrollView.scrollsToTop = NO;
    theScrollView.pagingEnabled = YES;
    theScrollView.delaysContentTouches = NO;
    theScrollView.showsVerticalScrollIndicator = NO;
    theScrollView.showsHorizontalScrollIndicator = NO;
    theScrollView.contentMode = UIViewContentModeRedraw;
    theScrollView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    theScrollView.backgroundColor = [UIColor clearColor];
    theScrollView.userInteractionEnabled = YES;
    theScrollView.autoresizesSubviews = NO;
    theScrollView.delegate = self;
    theScrollView.tag=1001;
    [self.view addSubview:theScrollView];
    
    CGRect toolbarRect = viewRect;
    toolbarRect.size.height = TOOLBAR_HEIGHT;
    
    mainToolbar = [[INDAPVMainToolbar alloc] initWithFrame:toolbarRect document:document]; // At top
    mainToolbar.delegate = self;
    [self.view addSubview:mainToolbar];
    
    int aIntHeight=0;
    if(isIpad())
        aIntHeight=60;
    else
        aIntHeight=44;
    
    CGRect pagebarRect = viewRect;
    pagebarRect.size.height = aIntHeight;
    pagebarRect.origin.y = (viewRect.size.height - aIntHeight);
    //
    mainPagebar = [[INDAPVMainPagebar alloc] initWithFrame:pagebarRect document:document]; // At bottom
    mainPagebar.delegate = self;
    [self.view addSubview:mainPagebar];
    
    
    UITapGestureRecognizer *singleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleSingleTap:)];
    singleTapOne.numberOfTouchesRequired = 1; singleTapOne.numberOfTapsRequired = 1; singleTapOne.delegate = self;
    
    UITapGestureRecognizer *doubleTapOne = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapOne.numberOfTouchesRequired = 1; doubleTapOne.numberOfTapsRequired = 2; doubleTapOne.delegate = self;
    
    UITapGestureRecognizer *doubleTapTwo = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleDoubleTap:)];
    doubleTapTwo.numberOfTouchesRequired = 2; doubleTapTwo.numberOfTapsRequired = 2; doubleTapTwo.delegate = self;
    
    [singleTapOne requireGestureRecognizerToFail:doubleTapOne]; // Single tap requires double tap to fail
    
    [self.view addGestureRecognizer:singleTapOne]; [singleTapOne release];
    [self.view addGestureRecognizer:doubleTapOne]; [doubleTapOne release];
    [self.view addGestureRecognizer:doubleTapTwo]; [doubleTapTwo release];
    
    contentViews = [NSMutableDictionary new];
    lastHideTime = [NSDate new];
    
    //Y Add
    
    strSearchPageNumber=[[NSMutableString alloc]init];
    strSearchWord=[[NSMutableString alloc]init];
    
    if(isIpad())
        [self CallHMSideMenu];//HM Side Menu
    else
        [self AddViewForiPhoneSideMenu];//iPhone Side Menu
    
    boolMenuOpen=NO;
    [self AddBrightnessViewWithSlider];//Slider For Brightness
    
    
    if(!searchingViewObj)
    {
        searchingViewObj=[[SearchingView alloc]initWithNibName:@"SearchingView" bundle:nil];
        searchingViewObj.delegate=self;
    }
    
    //End
    [self SetFramesForOrientation];
    //NSLog(@"%@",document.pageCount);
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (CGSizeEqualToSize(lastAppearSize, CGSizeZero) == false)
    {
        if (CGSizeEqualToSize(lastAppearSize, self.view.bounds.size) == false)
        {
            [self updateScrollViewContentViews]; // Update content views
        }
        
        lastAppearSize = CGSizeZero; // Reset view size tracking
    }
    //NSLog(@"%@",document.pageCount);
}



- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    if (CGSizeEqualToSize(theScrollView.contentSize, CGSizeZero)) // First time
    {
        
        //NSLog(@"%@",document.pageCount);
        
        [self performSelector:@selector(showDocument:) withObject:nil afterDelay:0.02];
    }
    
#if (kApp_PDF_ISIdle == TRUE) // Option
    
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    
#endif // end of kApp_PDF_ISIdle Option
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //NSLog(@"%@",document.pageCount);
    
    lastAppearSize = self.view.bounds.size; // Track view size
    
#if (kApp_PDF_ISIdle == TRUE) // Option
    
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
#endif // end of kApp_PDF_ISIdle Option
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)viewDidUnload
{
    [mainToolbar release], mainToolbar = nil; [mainPagebar release], mainPagebar = nil;
    [theScrollView release], theScrollView = nil; [contentViews release], contentViews = nil;
    [lastHideTime release], lastHideTime = nil; lastAppearSize = CGSizeZero; currentPage = 0;
    
    [super viewDidUnload];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    if(SearchWordVC)
    {
        [SearchWordVC release];
        SearchWordVC=nil;
    }
    
    if(SearchPageVC)
    {
        [SearchPageVC release];
        SearchPageVC=nil;
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [mainToolbar release], mainToolbar = nil; [mainPagebar release], mainPagebar = nil;
    [theScrollView release], theScrollView = nil; [contentViews release], contentViews = nil;
    [lastHideTime release], lastHideTime = nil; [document release], document = nil;
    
    [super dealloc];
}

#pragma mark - Page Methods
- (IBAction)handleSwipeFrom:(UISwipeGestureRecognizer *)recognizer {
    NSInteger page = [document.pageNumber integerValue];
    NSInteger maxPage = [document.pageCount integerValue];
    NSInteger minPage = 1; // Minimum
    CGPoint location = [recognizer locationInView:self.view];
    // [self showImageWithText:@"swipe" atPoint:location];
    
    if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        location.x -= 220.0;
        if ((maxPage > minPage) && (page != maxPage))
        {
            [self TurnPageRight];
        }
    }
    else {
        location.x += 220.0;
        
        if ((maxPage > minPage) && (page != minPage))
        {
            [self TurnPageLeft];
        }
    }
}

-(void)TurnPageLeft{
    CATransition *transition = [CATransition animation];
    [transition setDelegate:self];
    [transition setDuration:0.5f];
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        [transition setSubtype:@"fromBottom"];
        [transition setType:@"pageUnCurl"];
        [self.view.layer addAnimation:transition forKey:@"CurlAnim"];
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        [transition setSubtype:@"fromRight"];
        [transition setType:@"pageUnCurl"];
        [self.view.layer addAnimation:transition forKey:@"UnCurlAnim"];
    }
    [self showDocumentPage:currentPage-1];
}

-(void)TurnPageRight
{
    CATransition *transition = [CATransition animation];
    [transition setDelegate:self];
    [transition setDuration:0.5f];
    
    if([appDelObj.strOrientation isEqualToString:@"LandscapeRight"]||[appDelObj.strOrientation isEqualToString:@"Landscape"])
    {
        [transition setSubtype:@"fromBottom"];
        [transition setType:@"pageCurl"];
        [self.view.layer addAnimation:transition forKey:@"CurlAnim"];
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        [transition setSubtype:@"fromRight"];
        [transition setType:@"pageCurl"];
        [self.view.layer addAnimation:transition forKey:@"CurlAnim"];
    }    [self showDocumentPage:currentPage+1];
}

//y page scroll
-(void)PageCurlScroll
{
    if (boolScrollPage)
    {
        boolScrollPage=NO;
        theScrollView.scrollEnabled=YES;
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"isScroll"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        for (UIGestureRecognizer *recView in [self.view gestureRecognizers]) {
            if ([recView isKindOfClass:[UISwipeGestureRecognizer class]]) {
                [self.view removeGestureRecognizer:recView];
            }
        }
    }
    else
    {
        boolScrollPage=YES;
        theScrollView.scrollEnabled=NO;
        [[NSUserDefaults standardUserDefaults] setBool:NO forKey:@"isScroll"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        UISwipeGestureRecognizer *swipeLeftRecognizerLeft=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        swipeLeftRecognizerLeft.direction=UISwipeGestureRecognizerDirectionLeft;
        [self.view addGestureRecognizer:swipeLeftRecognizerLeft];
        
        UISwipeGestureRecognizer *swipeLeftRecognizerRight=[[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(handleSwipeFrom:)];
        swipeLeftRecognizerRight.direction=UISwipeGestureRecognizerDirectionRight;
        [self.view addGestureRecognizer:swipeLeftRecognizerRight];
    }
}

#pragma mark - UIScrollViewDelegate methods

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    __block NSInteger page = 0;
    
    if (scrollView.tag==1001) {
        CGFloat contentOffsetX = scrollView.contentOffset.x;
        
        [contentViews enumerateKeysAndObjectsUsingBlock: // Enumerate content views
         ^(id key, id object, BOOL *stop)
         {
             INDAPVContentView *contentView = object;
             
             if (contentView.frame.origin.x == contentOffsetX)
             {
                 page = contentView.tag; *stop = YES;
             }
         }
         ];
        
        if (page != 0) [self showDocumentPage:page]; // Show the page
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self showDocumentPage:theScrollView.tag]; // Show page
    
    theScrollView.tag = 0; // Clear page number tag
}

#pragma mark UIGestureRecognizerDelegate methods

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)recognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isKindOfClass:[UIScrollView class]]) return YES;
    
    return NO;
}

#pragma mark UIGestureRecognizer action methods

- (void)decrementPageNumber
{
    if (theScrollView.tag == 0) // Scroll view did end
    {
        NSInteger page = [document.pageNumber integerValue];
        NSInteger maxPage = [document.pageCount integerValue];
        NSInteger minPage = 1; // Minimum
        
        if ((maxPage > minPage) && (page != minPage))
        {
            CGPoint contentOffset = theScrollView.contentOffset;
            
            contentOffset.x -= theScrollView.bounds.size.width; // -= 1
            
            [theScrollView setContentOffset:contentOffset animated:YES];
            
            theScrollView.tag = (page - 1); // Decrement page number
        }
    }
}

- (void)incrementPageNumber
{
    if (theScrollView.tag == 0) // Scroll view did end
    {
        NSInteger page = [document.pageNumber integerValue];
        NSInteger maxPage = [document.pageCount integerValue];
        NSInteger minPage = 1; // Minimum
        
        if ((maxPage > minPage) && (page != maxPage))
        {
            CGPoint contentOffset = theScrollView.contentOffset;
            
            contentOffset.x += theScrollView.bounds.size.width; // += 1
            
            [theScrollView setContentOffset:contentOffset animated:YES];
            
            theScrollView.tag = (page + 1); // Increment page number
        }
    }
}

- (void)handleSingleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        CGPoint point = [recognizer locationInView:recognizer.view];
        CGRect areaRect = CGRectInset(viewRect, TAP_AREA_SIZE, 0.0f); // Area
        
        if (CGRectContainsPoint(areaRect, point)) // Single tap is inside the area
        {
            NSInteger page = [document.pageNumber integerValue]; // Current page #
            NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
            INDAPVContentView *targetView = [contentViews objectForKey:key];
            id target = [targetView singleTap:recognizer]; // Process tap
            
            if (target != nil) // Handle the returned target object
            {
                if ([target isKindOfClass:[NSURL class]]) // Open a URL
                {
                    [[UIApplication sharedApplication] openURL:target];
                }
                else // Not a URL, so check for other possible object type
                {
                    if ([target isKindOfClass:[NSNumber class]]) // Goto page
                    {
                        NSInteger value = [target integerValue]; // Number
                        [self showDocumentPage:value]; // Show the page
                    }
                }
            }
            else // Nothing active tapped in the target content view
            {
                if ([lastHideTime timeIntervalSinceNow] < -0.75) // Delay since hide
                {
                    if ((mainToolbar.hidden == YES) || (mainPagebar.hidden == YES))
                    {
                        [self ShowAllMainMenu];
                    }
                }
            }
            return;
        }
        
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point)) // page++ area
        {
            [self incrementPageNumber]; return;
        }
        
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point)) // page-- area
        {
            [self decrementPageNumber]; return;
        }
    }
}

- (void)handleDoubleTap:(UITapGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized)
    {
        CGRect viewRect = recognizer.view.bounds; // View bounds
        CGPoint point = [recognizer locationInView:recognizer.view];
        CGRect zoomArea = CGRectInset(viewRect, TAP_AREA_SIZE, TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(zoomArea, point)) // Double tap is in the zoom area
        {
            NSInteger page = [document.pageNumber integerValue]; // Current page #
            NSNumber *key = [NSNumber numberWithInteger:page]; // Page number key
            INDAPVContentView *targetView = [contentViews objectForKey:key];
            
            switch (recognizer.numberOfTouchesRequired) // Touches count
            {
                case 1: // One finger double tap: zoom ++
                {
                    [targetView zoomIncrement]; break;
                }
                    
                case 2: // Two finger double tap: zoom --
                {
                    [targetView zoomDecrement]; break;
                }
            }
            return;
        }
        
        CGRect nextPageRect = viewRect;
        nextPageRect.size.width = TAP_AREA_SIZE;
        nextPageRect.origin.x = (viewRect.size.width - TAP_AREA_SIZE);
        
        if (CGRectContainsPoint(nextPageRect, point)) // page++ area
        {
            [self incrementPageNumber]; return;
        }
        
        CGRect prevPageRect = viewRect;
        prevPageRect.size.width = TAP_AREA_SIZE;
        
        if (CGRectContainsPoint(prevPageRect, point)) // page-- area
        {
            [self decrementPageNumber]; return;
        }
    }
}

#pragma mark INDAPVContentViewDelegate methods

- (void)contentView:(INDAPVContentView *)contentView touchesBegan:(NSSet *)touches
{
    if ((mainToolbar.hidden == NO) || (mainPagebar.hidden == NO))
    {
        if (touches.count == 1) // Single touches only
        {
            UITouch *touch = [touches anyObject]; // Touch info
            CGPoint point = [touch locationInView:self.view]; // Touch location
            CGRect areaRect = CGRectInset(self.view.bounds, TAP_AREA_SIZE, TAP_AREA_SIZE);
            if (CGRectContainsPoint(areaRect, point) == false) return;
        }
        [self HideAllMainMenu];
        [lastHideTime release];
        lastHideTime = [NSDate new];
    }
}

-(void)HideAllMainMenu
{
    [mainToolbar hideToolbar];
    [mainPagebar hidePagebar];
    imgViewHMMenu.hidden=YES;
    
    if(boolBrightnessTap==NO)
        imgViewSliderBG.hidden=YES;
    
    if(boolMenuOpen==YES)
        viewMenuBtns.hidden=YES;
}

-(void)ShowAllMainMenu
{
    [mainToolbar showToolbar];
    [mainPagebar showPagebar];
    imgViewHMMenu.hidden=NO;// Show
    
    if(boolBrightnessTap==NO)
        imgViewSliderBG.hidden=NO;
    
    if(boolMenuOpen==YES)
        viewMenuBtns.hidden=NO;
}

#pragma mark INDAPVMainToolbarDelegate methods

- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar doneButton:(UIButton *)button
{
#if (kApp_PDF_SubView == FALSE) // Option
    
    //NSLog(@"document.fileName :%@",document.fileName);
    //NSLog(@"document.fileURL  :%@",document.fileURL);
    
    [document saveReaderDocument]; // Save any Document object changes
    [[INDAPVPreviewQueue sharedInstance] cancelOperationsWithGUID:document.guid];
    [[INDAPVPreviewCache sharedInstance] removeAllObjects]; // Empty the thumb cache
    if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss
    
    [self.navigationController popViewControllerAnimated:YES];
    
    //Or
    
    //	if ([delegate respondsToSelector:@selector(dismissReaderViewController:)] == YES)
    //	{
    //[delegate dismissReaderViewController:self]; // Dismiss the
    //	}
    //	else // We have a "Delegate must respond to -dismissReaderViewController: error"
    //	{
    //		NSAssert(NO, @"Delegate must respond to -dismissReaderViewController:");
    //	}
    
#endif // end of kApp_PDF_SubView Option
}

- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar emailButton:(UIButton *)button
{
#if (kApp_PDF_Mail == TRUE) // Option
    
    if ([MFMailComposeViewController canSendMail] == NO) return;
    
    if (printInteraction != nil) [printInteraction dismissAnimated:YES];
    
    unsigned long long fileSize = [document.fileSize unsignedLongLongValue];
    
    if (fileSize < (unsigned long long)15728630) // Check attachment size limit (15MB)
    {
        NSURL *fileURL = document.fileURL; NSString *fileName = document.fileName; // Document
        
        NSData *attachment = [NSData dataWithContentsOfURL:fileURL options:(NSDataReadingMapped|NSDataReadingUncached) error:nil];
        
        if (attachment != nil) // Ensure that we have valid document file attachment data
        {
            MFMailComposeViewController *mailComposer = [MFMailComposeViewController new];
            [mailComposer addAttachmentData:attachment mimeType:@"application/pdf" fileName:fileName];
            [mailComposer setSubject:fileName]; // Use the document file name for the subject
            mailComposer.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
            mailComposer.modalPresentationStyle = UIModalPresentationFormSheet;
            mailComposer.mailComposeDelegate = self; // Set the delegate
            [self presentModalViewController:mailComposer animated:YES];
            [mailComposer release]; // Cleanup
        }
    }
#endif // end of kApp_PDF_Mail Option
}

#pragma mark MFMailComposeViewControllerDelegate methods

- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error
{
#ifdef DEBUG
    if ((result == MFMailComposeResultFailed) && (error != NULL)) NSLog(@"%@", error);
#endif
    
    [self dismissModalViewControllerAnimated:YES]; // Dismiss
}

#pragma mark ThumbsViewControllerDelegate methods

- (void)dismissThumbsViewController:(INDAPVPreviewsViewController *)viewController
{
    [self updateToolbarBookmarkIcon];// Update bookmark icon
    [self dismissModalViewControllerAnimated:NO]; // Dismiss
    //[mainToolbar SetFramesForOrientation];
    [self SetFramesForOrientation];
}

- (void)thumbsViewController:(INDAPVPreviewsViewController *)viewController gotoPage:(NSInteger)page
{
    [self showDocumentPage:page]; // Show the page
}

#pragma mark INDAPVMainPagebarDelegate methods

- (void)pagebar:(INDAPVMainPagebar *)pagebar gotoPage:(NSInteger)page
{
    [self showDocumentPage:page]; // Show the page
}

#pragma mark UIApplication notification methods

- (void)applicationWill:(NSNotification *)notification
{
    [document saveReaderDocument];
    
    if (isIpad())
    {
        if (printInteraction != nil) [printInteraction dismissAnimated:NO];
    }
}

#pragma mark - SearchBar Methods

-(void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    if([strSearch isEqualToString:@"SearchPageNumber"])
    {
        if([[aSearchBar text] isEqualToString:@""])
        {
            [aSearchBar resignFirstResponder];
            return;
        }
    }
    else
    {
        if([keyword isEqualToString:[[aSearchBar text] retain]] )//keyWord
        {
            [aSearchBar resignFirstResponder];
            return;
        }
        
        if([keyword isEqualToString:@""] && [[aSearchBar text] isEqualToString:@""])//keyWord
        {
            [aSearchBar resignFirstResponder];
            return;
        }
    }
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    if([strSearch isEqualToString:@"SearchPageNumber"])
    {
        [aSearchBar setKeyboardType:UIKeyboardTypeNumberPad];
        if(!isIpad())//KeyBoard
        {
            if(aSearchBar==searchingViewObj.searchBarObj)
            {
                [[NSNotificationCenter defaultCenter] addObserver: self
                                                         selector: @selector(KeyboardDidShowOrHide:)
                                                             name: UIKeyboardDidShowNotification object:nil];
                
            }
            else
            {
                [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
            }
        }
    }
    else
    {
        if(isIOS8())
        {
            [self removeKeyboardDoneButton];
        }
        [aSearchBar setKeyboardType:UIKeyboardTypeDefault];
    }
}

-(void)SerchDataFromPDF
{
    keyword = [[searchBarObj text] retain];////keyWord
    
    if(!isIpad())
    {
        keyword=[[searchingViewObj.searchBarObj text] retain];
    }
    
    int lastPage=currentPage;
    currentPage=currentPage-1;
    Searching=YES;
    
    [self showDocumentPage:lastPage];
    [[NSUserDefaults standardUserDefaults] setObject:keyword forKey:@"SearchKeyWord"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self GetListOfSearchPage];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    [aSearchBar resignFirstResponder];
    if([[aSearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]<=0)
    {
        [self ShowAlertView:@"Please Enter Any Text Here."];
        aSearchBar.text=@"";
    }
    else
    {
        if([strSearch isEqualToString:@"SearchPageNumber"])
        {
            if([aSearchBar.text intValue] == 0)
                [self ShowAlertView:@"Oops!! This Is Not A Valid Page Number."];
            else
            {
                int aInt=[aSearchBar.text intValue];
                [self showDocumentPage:aInt];
                [strSearchPageNumber setString:[NSString stringWithFormat:@"%@",aSearchBar.text]];
            }
        }
        else
        {
            [strSearchWord setString:[NSString stringWithFormat:@"%@",aSearchBar.text]];
            
            arrSearchPagesIndex=[[NSMutableArray alloc]init];
            if(isIpad())
            {
                lblSearching.hidden=NO;
                searchBarObj.userInteractionEnabled=NO;
                tblSearchResult.userInteractionEnabled=NO;
                
                //YP - (1-10-14) - New Code - PopUP
                if(isIOS8())
                {
                    [SearchWordVC setPreferredContentSize:CGSizeMake(300, 344)];
                }
                else
                {
                    //YP - (1-10-14) - Old Code
                    [SearchWordVC setContentSizeForViewInPopover:CGSizeMake(300, 344)];
                }
                
                [self ReloadTableView];
            }
            [self performSelectorInBackground:@selector(SerchDataFromPDF) withObject:nil];
        }
    }
}

-(void)ReloadTableView
{
    if(isIpad())
    {
        if(isIOS7())
        {
            [tblSearchResult setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
        }
        [tblSearchResult reloadData];
    }
    else
        [searchingViewObj ReloadTableView];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [searchBarObj setText:@""];
    [aSearchBar resignFirstResponder];
    
    if([strSearch isEqualToString:@"SearchWord"])
    {
        [strSearchWord setString:@""];
        [arrSearchPagesIndex removeAllObjects];
        arrSearchPagesIndex=nil;
        
        if ([arrSearchPagesIndex count]==0)
        {
            [arrSearchPagesIndex addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"No Result",@"PageTitle",@"-1",@"PageNo",nil]];
        }
        
        [self ReloadTableView];
        
        if(isIpad())
        {
            //YP - (1-10-14) - New Code - PopUP
            if(isIOS8())
            {
                [SearchWordVC setPreferredContentSize:CGSizeMake(300, 44)];
            }
            else
            {
                //YP - (1-10-14) - Old Code
                [SearchWordVC setContentSizeForViewInPopover:CGSizeMake(300, 44)];
            }
        }
        
        
        [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:@"SearchKeyWord"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //Refresh Page
        keyword = [[searchBarObj text] retain];////keyWord
        if(!isIpad())
        {
            keyword=[[aSearchBar text] retain];
        }
        int lastPage=currentPage;
        currentPage=currentPage-1;
        Searching=YES;
        [self showDocumentPage:lastPage];
        
        aSearchBar.text=@"";
        if(!isIpad())
        {
            [self DismissSearchingView];
        }
        else
        {
            if(isIOS7())
            {
                [self SetFramesForSearchBar];
            }
        }
        
    }
    else
    {
        [strSearchPageNumber setString:@""];
        if(!isIpad())
        {
            [self RemoveKeyBoard];
            [self DismissSearchingView];
        }
    }
}

#pragma mark - TableView Methods

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [arrSearchPagesIndex count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
    cell.textLabel.textColor=PinkColor;
    
    if ([[[arrSearchPagesIndex objectAtIndex:indexPath.row] valueForKey:@"PageTitle"] isEqualToString:@"No Result"])
    {
        cell.textLabel.text=@"No Record Found.";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.userInteractionEnabled=NO;
    }
    else
    {
        cell.textLabel.text=[[arrSearchPagesIndex objectAtIndex:indexPath.row] valueForKey:@"PageTitle"];
        cell.userInteractionEnabled=YES;
    }
    
    //if(isIOS7())
    [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self showDocumentPage:[[[arrSearchPagesIndex objectAtIndex:indexPath.row] valueForKey:@"PageNo"] integerValue]];
    if(isIpad())
        [searchPopVC dismissPopoverAnimated:YES];
    else
    {
        [self DismissSearchingView];
    }
}

-(void)GetListOfSearchPage
{
    OrientationLock=TRUE;
    PDFDocRef = CGPDFDocumentCreateX((CFURLRef)document.fileURL,document.password);
    float pages = CGPDFDocumentGetNumberOfPages(PDFDocRef);
    for (i=0; i<pages; i++)
    {
        PDFPageRef = CGPDFDocumentGetPage(PDFDocRef,i+1); // Get page
        if ([[self selections] count]>0)
        {
            [arrSearchPagesIndex addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"Page %d (%d Times)",i+1,[[self selections] count]],@"PageTitle",[NSString stringWithFormat:@"%d",i+1],@"PageNo",nil]];
            [self performSelector:@selector(RefereshTableOnMainThred)];
        }
        
        [self performSelectorOnMainThread:@selector(PerFormONMainThresd:) withObject:[NSString stringWithFormat:@"%f",(i+1/pages)/pages] waitUntilDone:NO];
        CGPDFPageRelease(PDFPageRef);
        selections=nil;
        
    }
    
    OrientationLock=FALSE;
    if ([arrSearchPagesIndex count]==0)
    {
        [arrSearchPagesIndex addObject:[NSMutableDictionary dictionaryWithObjectsAndKeys:@"No Result",@"PageTitle",@"-1",@"PageNo",nil]];
        [self ReloadTableView];
    }
    
    if(!isIpad())
    {
        searchingViewObj.arrSerachingListForiPhone=arrSearchPagesIndex;
        [searchingViewObj ReloadTableView];
    }
    else
    {
        lblSearching.hidden=YES;
        searchBarObj.userInteractionEnabled=YES;
        tblSearchResult.userInteractionEnabled=YES;
    }
    
    if(isIOS7())
    {
        [self SetFramesForSearchBar];
        [tblSearchResult reloadData];
    }
}

-(void)RefereshTableOnMainThred{
    
    NSIndexPath *path1 = [NSIndexPath indexPathForRow:[arrSearchPagesIndex count]-1 inSection:0];
    NSArray *indexArray = [NSArray arrayWithObjects:path1,nil];
    [tblSearchResult insertRowsAtIndexPaths:indexArray withRowAnimation:UITableViewRowAnimationTop];
}

-(void)PerFormONMainThresd:(NSString*)UpdateProgress{
}


- (NSArray *)selections
{
    @synchronized (self)
    {
        scanner = [[INDAPVScanner alloc] init];
        [self.scanner setKeyword:keyword];//keyWord
        [self.scanner scanPage:PDFPageRef];
        self.selections = [self.scanner selections];
        return selections;
    }
}

#pragma mark - Yka
#pragma mark - HMSide Menu

- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar SettingButton:(UIButton *)button
{
    if(isIpad())
    {
        int aIntY;
        int aIntX;
        if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
        {
            aIntY=60;
            aIntX=895;
        }
        else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
        {
            aIntY=185;
            aIntX=638;
        }
        
        
        if (self.sideMenu.isOpen)
        {
            [self.sideMenu close];
            [UIView animateWithDuration:1.0 animations:^{
                imgViewHMMenu.frame = CGRectMake(1024, aIntY+appDelObj.intIOS7, 120, 630);
            }completion:^(BOOL finished) {
                if (finished) {
                }
            }];
        }
        else
        {
            imgViewHMMenu.frame = CGRectMake(1024, aIntY+appDelObj.intIOS7, 120, 630);
            [UIView animateWithDuration:0.5 animations:^{
                imgViewHMMenu.frame = CGRectMake(aIntX, aIntY+appDelObj.intIOS7, 120, 630);
            }completion:^(BOOL finished) {
                if (finished) {
                    [self.sideMenu open];
                }
            }];
        }
    }
    else
    {
        if(boolMenuOpen==NO)
        {
            boolMenuOpen=YES;
            viewMenuBtns.hidden=NO;
            [self iPhoneSideMenu];
            
            int aIntMenuWH=40;
            
            [self CreateMenuForiPhone:CGRectMake(15 ,20 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Search_Page.png"] Tag:1001];
            [self CreateMenuForiPhone:CGRectMake(15 ,66 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Search_Word.png"] Tag:1002];
            [self CreateMenuForiPhone:CGRectMake(15 ,113 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Bookmark_Gray.png"] Tag:1003];
            [self CreateMenuForiPhone:CGRectMake(15 ,160 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"PageCurl.png"] Tag:1004];
            [self CreateMenuForiPhone:CGRectMake(70 ,20 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"MultiPage.png"] Tag:1005];
            [self CreateMenuForiPhone:CGRectMake(70 ,66 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Brightness.png"] Tag:1006];
            [self CreateMenuForiPhone:CGRectMake(70 ,113 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Camera.png"] Tag:1007];
            [self CreateMenuForiPhone:CGRectMake(70 ,160 ,aIntMenuWH ,aIntMenuWH) Image:[UIImage imageNamed:@"Printer.png"] Tag:1008];
        }
        else
        {
            boolMenuOpen=NO;
            viewMenuBtns.hidden=YES;
            viewMenuBtns.frame = CGRectMake(475, 45+appDelObj.intIOS7, 120, 215);//(170, 45, 150, 215)
        }
    }
}

-(void)AddViewForiPhoneSideMenu
{
    if(!viewMenuBtns)
    {
        viewMenuBtns=[[UIView alloc]init];
        imgViewBG=[[UIImageView alloc]init];
        imgViewBG.frame = CGRectMake(5, 0, 115, 210);//140
        
        [imgViewBG setImage:[UIImage imageNamed:@"MenuBG_Iphone.png"]];
        [imgViewBG setAlpha:0.7];
        [viewMenuBtns addSubview:imgViewBG];
        viewMenuBtns.backgroundColor=[UIColor clearColor];
        [self.view addSubview:viewMenuBtns];
        viewMenuBtns.hidden=YES;
    }
}

-(void)CreateMenuForiPhone:(CGRect)aFrame Image:(UIImage*)aImage Tag:(int)aTag
{
    UIButton *aBtnRef = [UIButton buttonWithType:UIButtonTypeCustom];
    [aBtnRef addTarget:self action:@selector(SideMenuEventClick:) forControlEvents:UIControlEventTouchDown];
    aBtnRef.frame = aFrame;
    aBtnRef.tag=aTag;
    [aBtnRef setImage:aImage forState:UIControlStateNormal];
    [viewMenuBtns addSubview:aBtnRef];
}


-(void)CallHMSideMenu
{
    if(!imgViewHMMenu)
    {
        imgViewHMMenu = [[UIImageView alloc]init];
        [imgViewHMMenu setUserInteractionEnabled:TRUE];
        [imgViewHMMenu setBackgroundColor:[UIColor clearColor]];
        imgViewHMMenu.autoresizesSubviews=NO;
        imgViewHMMenu.tag=2001;
        [self.view addSubview:imgViewHMMenu];
        [self HMMenuFrame];
    }
    
    UIView *view1 = [[UIView alloc] init];
    UIView *view2 = [[UIView alloc] init];
    UIView *view3 = [[UIView alloc] init];
    UIView *view4 = [[UIView alloc] init];
    UIView *view5 = [[UIView alloc] init];
    UIView *view6 = [[UIView alloc] init];
    UIView *view7 = [[UIView alloc] init];
    UIView *view8 = [[UIView alloc] init];
    
    CGRect aFrameMenuIcon;
    float aFloatIconSpace;
    if(isIpad())//HM Menu
    {
        aFloatIconSpace=10.0f;
        aFrameMenuIcon=CGRectMake(0, 0, 65, 65);
    }
    else
    {
        aFloatIconSpace=5.0f;
        aFrameMenuIcon=CGRectMake(0, 0, 35, 35);
    }
    
    [self CallHMView:view1 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Search_Page.png"] Tag:1001];//Search Page
    [self CallHMView:view2 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Search_Word.png"] Tag:1002];//Search Word
    
    [self CallHMView:view3 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Bookmark_Gray.png"] Tag:1003];//BookMark
    [self CallHMView:view4 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"PageCurl.png"] Tag:1004];//Scroll/Curl
    [self CallHMView:view5 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"MultiPage.png"] Tag:1005];//Multi Page
    
    [self CallHMView:view6 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Brightness.png"] Tag:1006];//Brightness
    [self CallHMView:view7 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Camera.png"] Tag:1007];//Capture Page
    [self CallHMView:view8 Frame:aFrameMenuIcon Image:[UIImage imageNamed:@"Printer.png"] Tag:1008];//Print
    
    self.sideMenu = [[INDAPVSideMenu alloc] initWithItems:@[view1, view2, view3, view4, view5, view6, view7, view8]];
    [self.sideMenu setItemSpacing:aFloatIconSpace];
    
    [imgViewHMMenu addSubview:self.sideMenu];
    
}

-(void)CallHMView:(UIView*)aView Frame:(CGRect)aFrame Image:(UIImage*)aImg Tag:(int)aTag
{
    aView.frame = aFrame;
    [aView setTag:aTag];
    [aView setMenuActionWithBlock:^{
        [self HMSideMenuEventClick:aTag];
    }];
    UIImageView *aImgIcon = [[UIImageView alloc] initWithFrame:aFrame];
    [aImgIcon setImage:aImg];
    [aView addSubview:aImgIcon];
    
    aImgIcon.autoresizesSubviews=NO;
    aView.autoresizesSubviews=NO;
    [aView setBackgroundColor:[UIColor clearColor]];
}

-(void)ShowSearchBar:(BOOL)aBoolSearchWord
{
    NSMutableString *aStrText=[[NSMutableString alloc]init];
    if(aBoolSearchWord)
    {
        if(!SearchWordVC)
        {
            SearchWordVC=[[UIViewController alloc] init];
        }
    }
    else
    {
        if(!SearchPageVC)
        {
            SearchPageVC=[[UIViewController alloc] init];
        }
    }
    
    if(searchBarObj)
    {
        [searchBarObj release];
        [searchBarObj removeFromSuperview];
        searchBarObj=nil;
    }
    
    if(!searchBarObj)
    {
        searchBarObj=[[UISearchBar alloc] init];
        searchBarObj.showsCancelButton=YES;
        searchBarObj.tintColor=PinkColor;
        [searchBarObj setText:[searchBarObj text]];
        searchBarObj.delegate=self;
        
        if(isIpad())
            searchBarObj.frame=CGRectMake(0, 0, 300, 44);
        
        if(searchPopVC)
        {
            [searchPopVC release];
            searchPopVC=nil;
        }
        
        if(aBoolSearchWord)
        {
            searchPopVC=[[UIPopoverController alloc]initWithContentViewController:SearchWordVC];
            [SearchWordVC.view addSubview:searchBarObj];
            
        }
        else
        {
            searchPopVC = [[UIPopoverController alloc] initWithContentViewController:SearchPageVC];
            [SearchPageVC.view addSubview:searchBarObj];
        }
        
        if(isIOS7())
        {
            
            if([arrSearchPagesIndex count]>0)
            {
                if([strSearch isEqualToString:@"SearchWord"])
                    searchPopVC.popoverContentSize = CGSizeMake(300.0f, 344.0f);
                else
                    searchPopVC.popoverContentSize = CGSizeMake(300.0f, 44.0f);
            }
            else
            {
                searchPopVC.popoverContentSize = CGSizeMake(300.0f, 44.0f);
            }
            
            searchPopVC.popoverBackgroundViewClass = [PopoverBackgroundView class];
        }
        
        for(UIView *subView in searchBarObj.subviews) {
            if ([subView isKindOfClass:[UITextField class]]) {
                UITextField *searchField = (UITextField *)subView;
                searchField.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
            }
        }
    }
    
    if([strSearch isEqualToString:@"SearchWord"])
    {
        if ([strSearchWord length]>0)
            aStrText=[NSMutableString stringWithFormat:@"%@",strSearchWord];
        else
            [aStrText setString:@""];
    }
    else
    {
        if ([strSearchPageNumber length]>0)
            aStrText=[NSMutableString stringWithFormat:@"%@",strSearchPageNumber];
        else
            [aStrText setString:@""];
    }
    [searchBarObj setPlaceholder:@"Enter Page Number"];
    [searchBarObj setText:aStrText];
    
    
    if([strSearch isEqualToString:@"SearchWord"])
    {
        if(!tblSearchResult)
        {
            tblSearchResult =[[UITableView alloc] init];
            tblSearchResult.delegate=self;
            tblSearchResult.dataSource=self;
            [tblSearchResult setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_White.png"]]];
            tblSearchResult.frame = CGRectMake(0, 44, 300, 300);
            tblSearchResult.autoresizesSubviews=NO;
            tblSearchResult.allowsSelection = YES;
            
            if(isIOS7())
                [tblSearchResult setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
            
            
            [SearchWordVC.view addSubview:tblSearchResult];
        }
        
        if(!lblSearching)
        {
            lblSearching=[[UILabel alloc]init];
            lblSearching.textAlignment=NSTextAlignmentCenter;
            lblSearching.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
            lblSearching.textColor=PinkColor;
            lblSearching.backgroundColor=[UIColor clearColor];
            lblSearching.text=@"Searching...";
            lblSearching.frame=CGRectMake(5, 45, 290, 40);
            [SearchWordVC.view addSubview:lblSearching];
        }
        [searchBarObj setPlaceholder:@"Enter Any Text"];
    }
    else
    {
        if(tblSearchResult)
        {
            tblSearchResult.delegate=nil;
            tblSearchResult.dataSource=nil;
            [tblSearchResult removeFromSuperview];
            tblSearchResult=nil;
        }
        
        if(lblSearching)
        {
            [lblSearching release];
            lblSearching=nil;
        }
    }
    lblSearching.hidden=YES;
    [self SetFramesForSearchBar];
}


-(IBAction)SideMenuEventClick:(id)sender
{
    UIButton *aBtnRef=sender;
    [self HMSideMenuEventClick:[aBtnRef tag]];
}

-(void)NavigationController:(UIViewController*)aViewController
{
    if(navControllerObj)
    {
        [navControllerObj release];
        navControllerObj=nil;
    }
    navControllerObj = [[NavigationControllerIOS6 alloc]initWithRootViewController:aViewController];
    navControllerObj.navigationBarHidden = YES;
}

-(void)HMSideMenuEventClick:(int)aIntTag
{
    [self NavigationController:searchingViewObj];
    
    intClickBtn=aIntTag;
    
    if(boolBrightnessTap==NO)
    {
        if(aIntTag != 1006)
            [self ShowHideBrightnessViewWithSlider:NO];
    }
    
    if(aIntTag == 1001)//Search Page
    {
        strSearch=@"SearchPageNumber";
        if (isIpad())
        {
            [self ShowSearchBar:NO];
        }
        else
        {
            searchingViewObj.strSearchClick=strSearch;
            [self presentModalViewController:navControllerObj animated:YES];
        }
    }
    else if(aIntTag == 1002)//Search Word
    {
        strSearch=@"SearchWord";
        if (isIpad())
        {
            [self ShowSearchBar:YES];
        }
        else
        {
            searchingViewObj.strSearchClick=strSearch;
            [self presentModalViewController:navControllerObj animated:YES];
        }
    }
    else if(aIntTag == 1003)//BookMark
    {
        if (printInteraction != nil) [printInteraction dismissAnimated:YES];
        
        NSInteger page = [document.pageNumber integerValue];
        if ([document.bookmarks containsIndex:page])
        {
            [mainToolbar setBookmarkState:NO];
            [document.bookmarks removeIndex:page];
        }
        else // Add the bookmarked page index
        {
            [mainToolbar setBookmarkState:YES];
            [document.bookmarks addIndex:page];
        }
    }
    else if(aIntTag == 1004)//Scroll/Curl
    {
        [self PageCurlScroll];
        if(isIpad())
        {
            for(UIView *aView in [imgViewHMMenu subviews])
            {
                if([aView isKindOfClass:[INDAPVSideMenu class]])
                {
                    UIView *aViewTemp = (UIView *)[aView viewWithTag:1004];
                    for (int aInt=0; aInt<[[aViewTemp subviews]count]; aInt++)
                    {
                        if ([[[aViewTemp subviews]objectAtIndex:aInt] isKindOfClass:[UIImageView class]])
                        {
                            UIImageView *aImage=(UIImageView *)[[aViewTemp subviews]objectAtIndex:aInt];
                            if(boolScrollPage==YES)
                                aImage.image=[UIImage imageNamed:@"PageScroll.png"];
                            else
                                aImage.image=[UIImage imageNamed:@"PageCurl.png"];
                            break;
                        }
                    }
                }
            }
        }
        else
        {
            for(UIView *aViewTemp in [viewMenuBtns subviews])
            {
                if([aViewTemp isKindOfClass:[UIButton class]])
                {
                    UIButton *aBtnTemp = (UIButton *)[aViewTemp viewWithTag:1004];
                    for (int aInt=0; aInt<[[aBtnTemp subviews]count]; aInt++)
                    {
                        if(boolScrollPage==YES)
                            [aBtnTemp setImage:[UIImage imageNamed:@"PageScroll.png"] forState:UIControlStateNormal];
                        else
                            [aBtnTemp setImage:[UIImage imageNamed:@"PageCurl.png"] forState:UIControlStateNormal];
                        
                        break;
                    }
                }
            }
        }
    }
    else if(aIntTag == 1005)//Multi Page
    {
        if (printInteraction != nil) [printInteraction dismissAnimated:NO]; // Dismiss
        
        INDAPVPreviewsViewController *thumbsViewController = [[INDAPVPreviewsViewController alloc] initWithReaderDocument:document];
        
        if(!isIpad())
            [self NavigationController:thumbsViewController];
        
        thumbsViewController.delegate = self;
        thumbsViewController.title = self.title;
        
        thumbsViewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        thumbsViewController.modalPresentationStyle = UIModalPresentationFullScreen;
        
        if(!isIpad())
            [self presentModalViewController:navControllerObj animated:YES];
        else
            [self presentModalViewController:thumbsViewController animated:YES];
        
        [thumbsViewController release]; // Release ThumbsViewController
    }
    else if(aIntTag == 1006)//Brightness
    {
        [self ShowHideBrightnessViewWithSlider:boolBrightnessTap];
    }
    else if(aIntTag == 1007)//Capture Page //Camera
    {
        if(imgViewSliderBG)
            imgViewSliderBG.hidden=YES;
        
        [self HideAllMainMenu];
        
        UIView *flashView = [[UIView alloc] init];
        
        if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
        {
            if(isIpad())
            {
                //YP - (1-10-14) - New Code - Capture Image
                flashView.frame=CGRectMake(0, 0, self.view.frame.size.width, 1024);
                
                //YP - (1-10-14) - Old Code
                //flashView.frame=CGRectMake(0, 0, 768, 1024);
            }
            else
            {
                //YP - (1-10-14) - New Code - Capture Image
                if(isIphone5())
                    flashView.frame=CGRectMake(0, 0, self.view.frame.size.width, 568);
                else
                    flashView.frame=CGRectMake(0, 0, self.view.frame.size.width, 480);
                
                
                //YP - (1-10-14) - Old Code
                //if(isIphone5())
                //    flashView.frame=CGRectMake(0, 0, 320, 568);
                //else
                //    flashView.frame=CGRectMake(0, 0, 320, 480);
            }
        }
        else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
        {
            if(isIpad())
                flashView.frame=CGRectMake(0, 0, 1024, 1024);
            else
            {
                if(isIphone5())
                    flashView.frame=CGRectMake(0, 0, 568, 568);
                else
                    flashView.frame=CGRectMake(0, 0, 480, 480);
            }
        }
        
        flashView.alpha=0.9;
        [flashView setBackgroundColor:[UIColor whiteColor]];
        [[[self view] window] addSubview:flashView];
        
        [UIView animateWithDuration:0.5
                         animations:^{
                             [flashView setAlpha:0.f];
                         }
                         completion:^(BOOL finished){
                             [flashView removeFromSuperview];
                             [self ShowAllMainMenu];
                             if(imgViewSliderBG)
                                 imgViewSliderBG.hidden=NO;
                         }
         ];
        
        UIGraphicsBeginImageContext(self.view.frame.size);
        CGContextRef resizedContext = UIGraphicsGetCurrentContext();
        [[self.view layer] renderInContext:resizedContext];
        
        //Save Image In Photo Gallery
        UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        UIImageWriteToSavedPhotosAlbum(viewImage, nil, nil, nil);
        
    }
    else if(aIntTag == 1008)//Print
    {
#if (kApp_PDF_Print == TRUE) // Option
        
        Class printInteractionController = NSClassFromString(@"UIPrintInteractionController");
        if ((printInteractionController != nil) && [printInteractionController isPrintingAvailable])
        {
            printInteraction = [UIPrintInteractionController sharedPrintController];
            
            printInteraction.delegate = self;
            NSURL *fileURL = document.fileURL;
            UIPrintInfo *printInfo = [UIPrintInfo printInfo];
            printInfo.outputType = UIPrintInfoOutputGeneral;
            printInfo.jobName = document.fileName;
            printInfo.duplex = UIPrintInfoDuplexLongEdge;
            printInteraction.printInfo = printInfo;
            printInteraction.showsPageRange = YES;
            printInteraction.printingItem = fileURL;
            
            if(isIpad())
            {
                [self SetPrinterFrame];
            }
            else
            {
                void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
                ^(UIPrintInteractionController *printInteraction, BOOL completed, NSError *error) {
                    //self.content = nil;
                    if (!completed && error)
                        NSLog(@"FAILED! due to error in domain %@ with error code %u",
                              error.domain, error.code);
                };
                
                [printInteraction presentAnimated:YES completionHandler:completionHandler];
            }
        }
        
#endif // end of kApp_PDF_Print Option
    }
}
#pragma mark - Printer Delegate Methods

- (void)printInteractionControllerWillPresentPrinterOptions:(UIPrintInteractionController *)printInteractionController
{
    if(!isIpad())
        [appDelObj.NavigationControllerObj ShowPrinter:YES];
}

- (void)printInteractionControllerWillDismissPrinterOptions:(UIPrintInteractionController *)printInteractionController;
{
    if(!isIpad())
    {
        [appDelObj.NavigationControllerObj ShowPrinter:NO];
    }
}

#pragma mark - SearchingView Delegate Methods

-(void)DismissSearchingView
{
    [self.navigationController dismissModalViewControllerAnimated:YES];
    [self updateScrollViewContentViews];//Yasi Add- Temp Condition For Reload PDF Page
}

-(void)DidSelectMethod:(int)aInt
{
    [self showDocumentPage:[[[arrSearchPagesIndex objectAtIndex:aInt] valueForKey:@"PageNo"] integerValue]];
    [self DismissSearchingView];
}

-(void)TextSearching:(NSString *)aStrClickMethod SearchBar:(UISearchBar *)aSearchBar
{
    if([aStrClickMethod isEqualToString:@"searchBarSearchButtonClicked"])
        [self searchBarSearchButtonClicked:aSearchBar];
    else if([aStrClickMethod isEqualToString:@"searchBarTextDidBeginEditing"])
        [self searchBarTextDidBeginEditing:aSearchBar];
    else if([aStrClickMethod isEqualToString:@"searchBarTextDidEndEditing"])
        [self searchBarTextDidEndEditing:aSearchBar];
    else if([aStrClickMethod isEqualToString:@"searchBarCancelButtonClicked"])
        [self searchBarCancelButtonClicked:aSearchBar];
}

-(void)OrientationMethod:(NSString *)aStrOrientationMethod InterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation Duration:(NSTimeInterval)aDuration
{
    if([aStrOrientationMethod isEqualToString:@"willAnimateRotationToInterfaceOrientation"])
        [self willAnimateRotationToInterfaceOrientation:aInterfaceOrientation duration:aDuration];
    else if([aStrOrientationMethod isEqualToString:@"didRotateFromInterfaceOrientation"])
        [self didRotateFromInterfaceOrientation:aInterfaceOrientation];
    else if([aStrOrientationMethod isEqualToString:@"willRotateToInterfaceOrientation"])
        [self willRotateToInterfaceOrientation:aInterfaceOrientation duration:aDuration];
}

#pragma mark - Slider

-(void)AddBrightnessViewWithSlider
{
    imgViewSliderBG=[[UIImageView alloc]init];
    imgViewSliderBG.backgroundColor = [UIColor orangeColor];
    [imgViewSliderBG setAutoresizingMask:UIViewAutoresizingNone];
    imgViewSliderBG.alpha=0.7;
    imgViewSliderBG.tag=2002;
    imgViewSliderBG.layer.cornerRadius = 20;
    imgViewSliderBG.layer.masksToBounds = YES;
    imgViewSliderBG.userInteractionEnabled=TRUE;
    [self.view addSubview:imgViewSliderBG];
    
    SliderBrightness=[[UISlider alloc]init];
    
    SliderBrightness.minimumValue=0;
    SliderBrightness.maximumValue=0.8;
    [SliderBrightness setValue:0.8];
    
    [SliderBrightness addTarget:self action:@selector(SliderValueChange) forControlEvents:UIControlEventValueChanged];
    [imgViewSliderBG addSubview:SliderBrightness];
    
    imgViewBrightness=[[UIImageView alloc]init];
    imgViewBrightness.tag=2003;
    imgViewBrightness.backgroundColor = [UIColor blackColor];
    [imgViewBrightness setAutoresizingMask:UIViewAutoresizingNone];
    imgViewBrightness.alpha=0;
    
    [self.view addSubview:imgViewBrightness];
    
    if(isIpad())
    {
        SliderBrightness.frame = CGRectMake(20, 25, 360, 30);
        //imgViewBrightness.frame = CGRectMake(0, 0, self.view.frame.size.width, 1024);
    }
    else
    {
        SliderBrightness.frame = CGRectMake(20, 10, 240, 30);
        // imgViewBrightness.frame = CGRectMake(0, 0, self.view.frame.size.width, 480+appDelObj.intiPhone5);
    }
    
    boolBrightnessTap=YES;
    SliderBrightness.hidden=YES;
    imgViewBrightness.hidden=YES;
}

-(void)ShowHideBrightnessViewWithSlider:(BOOL)aBoolBrightness
{
    int aIntX=0;
    int aIntY=0;
    int aIntWidth=0;
    int aIntImgWidth=0;
    int aIntImgHeight=0;
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        if(isIpad())
        {
            aIntX=310;
            aIntY=445;
            aIntWidth=1024;
            aIntImgWidth=400;
            aIntImgHeight=80;
        }
        else
        {
            aIntX=40+(appDelObj.intiPhone5/2);
            aIntY=135;
            aIntWidth=480+appDelObj.intiPhone5;
            aIntImgWidth=280;
            aIntImgHeight=50;
        }
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        if(isIpad())
        {
            aIntX=180;
            aIntY=575;
            aIntWidth=768;
            aIntImgWidth=400;
            aIntImgHeight=80;
        }
        else
        {
            aIntX=20;
            aIntY=295+appDelObj.intiPhone5;
            aIntWidth=480;
            aIntImgWidth=280;
            aIntImgHeight=50;
        }
    }
    
    if (aBoolBrightness==TRUE)//Show
    {
        SliderBrightness.hidden=NO;
        imgViewBrightness.hidden=NO;
        imgViewBrightness.frame = CGRectMake(0, 0, 1024, 1024);//(0, 0, aIntWidth, aIntWidth)
        boolBrightnessTap=NO;
        imgViewSliderBG.frame = CGRectMake(aIntWidth, aIntY+appDelObj.intIOS7, aIntImgWidth, aIntImgHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            imgViewSliderBG.frame = CGRectMake(aIntX, aIntY+appDelObj.intIOS7, aIntImgWidth, aIntImgHeight);
        }completion:^(BOOL finished) {
            if (finished) {
            }
        }];
    }
    else//Hide
    {
        SliderBrightness.hidden=YES;
        boolBrightnessTap=YES;
        imgViewSliderBG.frame = CGRectMake(aIntX, aIntY+appDelObj.intIOS7, aIntImgWidth, aIntImgHeight);
        
        [UIView animateWithDuration:0.5 animations:^{
            imgViewSliderBG.frame = CGRectMake(1024, aIntY+appDelObj.intIOS7, aIntImgWidth, aIntImgHeight);//aIntWidth=1024
        }completion:^(BOOL finished) {
            if (finished) {
            }
        }];
    }
}

-(void)SliderValueChange
{
    float aFloatSliderValue=(float)SliderBrightness.value;
    imgViewBrightness.alpha=0.8-aFloatSliderValue;
}

#pragma mark - Orienatation Method

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    if (isVisible == NO) return; // iOS present modal bodge
    [self updateScrollViewContentViews]; // Update content views
    lastAppearSize = CGSizeZero; // Reset view size tracking
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (!OrientationLock) {
        return YES;
    }
    else
    {
        return NO;
    }
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    if (isVisible == NO) return; // iOS present modal bodge
    
    // [mainToolbar SetFramesForOrientation];
    
    [self SetFramesForOrientation];
}

-(void)SetFramesForOrientation
{
    [mainToolbar SetFramesForOrientation];
    
    if(isIpad())
        [self HMMenuFrame];
    else
        [self iPhoneSideMenu];
    
    if(intClickBtn == 1008)
    {
        if(isIpad())
            [self SetPrinterFrame];
    }
    
    
    if(intClickBtn == 1001 || intClickBtn == 1002)
    {
        if([searchPopVC isPopoverVisible])
            [self SetFramesForSearchBar];
        else
            [self SetDoneBtnFrameForIphoneKeyboard];
    }
    
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        if(intClickBtn == 1006)
        {
            if(boolBrightnessTap==NO)
            {
                if(isIpad())
                    imgViewSliderBG.frame = CGRectMake(310, 445+appDelObj.intIOS7, 400, 80);
                else
                    imgViewSliderBG.frame = CGRectMake(40+(appDelObj.intiPhone5/2)+appDelObj.intIOS7, 135, 280, 50);
            }
        }
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        if(intClickBtn == 1006)
        {
            if(boolBrightnessTap==NO)
            {
                if(isIpad())
                    imgViewSliderBG.frame = CGRectMake(180, 575+appDelObj.intIOS7, 400, 80);
                else
                    imgViewSliderBG.frame = CGRectMake(20, 295+appDelObj.intiPhone5+appDelObj.intIOS7, 280, 50);
            }
        }
    }
    
    if(isIpad())
        imgViewBrightness.frame = CGRectMake(0, 0, 1024, 1024);
    else
        imgViewBrightness.frame = CGRectMake(0, 0, 480+appDelObj.intiPhone5, 480+appDelObj.intiPhone5);
}

-(void)iPhoneSideMenu
{
    if(boolMenuOpen==YES)
    {
        if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
        {
            viewMenuBtns.frame = CGRectMake(350+appDelObj.intiPhone5, 45+appDelObj.intIOS7, 125, 215);
        }
        else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
        {
            viewMenuBtns.frame = CGRectMake(self.view.frame.size.width - 125, 45+appDelObj.intIOS7, 125, 215);
        }
    }
}

-(void)HMMenuFrame
{
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        if (self.sideMenu.isOpen)
            imgViewHMMenu.frame = CGRectMake(895, 60+appDelObj.intIOS7, 120, 630);
        else
            imgViewHMMenu.frame = CGRectMake(1024, 60+appDelObj.intIOS7, 120, 630);
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        if(isIpad())
        {
            if (self.sideMenu.isOpen)
                imgViewHMMenu.frame = CGRectMake(638, 185+appDelObj.intIOS7, 120, 630);
            else
                imgViewHMMenu.frame = CGRectMake(1024, 185+appDelObj.intIOS7, 120, 630);
        }
        else
        {
            if (self.sideMenu.isOpen)
                imgViewHMMenu.frame = CGRectMake(255, 50+appDelObj.intIOS7, 120, 500);
            else
                imgViewHMMenu.frame = CGRectMake(320, 45+appDelObj.intIOS7, 120, 630);
        }
    }
}

-(void)SetPrinterFrame
{
    [printInteraction dismissAnimated:YES];
    
    CGRect aRect;
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        aRect=CGRectMake(720, 740+appDelObj.intIOS7, 50, 50);
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        aRect=CGRectMake(680, 740+appDelObj.intIOS7, 50, 50);
    }
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printInteraction, BOOL completed, NSError *error) {
        //self.content = nil;
        if (!completed && error)
            NSLog(@"FAILED! due to error in domain %@ with error code %u",
                  error.domain, error.code);
    };
    [printInteraction presentFromRect:aRect inView:self.view animated:YES completionHandler:completionHandler];
}

-(void)SetFramesForSearchBar
{
    int aIntY=0;
    int aIntX=0;
    
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        aIntX=935;
        if([strSearch isEqualToString:@"SearchPageNumber"])
            aIntY=90;
        else
        {
            aIntY=168;
            if(isIOS7())
            {
                if([arrSearchPagesIndex count]>0)
                    aIntY=315;
            }
        }
    }
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
    {
        aIntX=680;
        if([strSearch isEqualToString:@"SearchPageNumber"])
            aIntY=215;
        else
        {
            aIntY=290;
            if(isIOS7())
            {
                if([arrSearchPagesIndex count]>0)
                    aIntY=440;
            }
        }
    }
    
    if(isIpad())
    {
        [searchPopVC presentPopoverFromRect:CGRectMake(aIntX, aIntY+appDelObj.intIOS7, 300, 44) inView:self.view permittedArrowDirections:UIPopoverArrowDirectionRight animated:YES];
        
        if([strSearch isEqualToString:@"SearchWord"])
        {
            if([arrSearchPagesIndex count]>0)
            {
                //YP - (1-10-14) - New Code - PopUP
                if(isIOS8())
                {
                    [SearchWordVC setPreferredContentSize:CGSizeMake(300.0f, 344.0f)];
                }
                else
                {
                    //YP - (1-10-14) - Old Code
                    [SearchWordVC setContentSizeForViewInPopover:CGSizeMake(300.0f, 344.0f)];
                }
            }
            else
            {
                //YP - (1-10-14) - New Code - PopUP
                if(isIOS8())
                {
                    [SearchWordVC setPreferredContentSize:CGSizeMake(300.0f, 44.0f)];
                }
                else
                {
                    //YP - (1-10-14) - Old Code
                    [SearchWordVC setContentSizeForViewInPopover:CGSizeMake(300.0f, 44.0f)];
                }
            }
            if(isIOS7())
                searchPopVC.popoverBackgroundViewClass = [PopoverBackgroundView class];
        }
        else
        {
            //YP - (1-10-14) - New Code - PopUP
            if(isIOS8())
            {
                [SearchPageVC setPreferredContentSize:CGSizeMake(300.0f, 44.0f)];
            }
            else
            {
                //YP - (1-10-14) - Old Code
                [SearchPageVC setContentSizeForViewInPopover:CGSizeMake(300.0f, 44.0f)];
            }
        }
    }
    else
    {
        //YP - (1-10-14) - New Code
        [self SetDoneBtnFrameForIphoneKeyboard];
    }
    
}

#pragma mark - Done Button For Keyboard


- (void)KeyboardDidShowOrHide:(id)sender
{
    @try {
        [self AddDoneBtnForKeyBoard];
        
        //YP - (1-10-14) - New Code - KeyBoard
        if(isIOS8())
        {
            int windowCount = [[[UIApplication sharedApplication] windows] count];
            if (windowCount < 2) {
                return;
            }
            
            UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
            UIView* keyboard;
            
            for(int int1 = 0 ; int1 < [tempWindow.subviews count] ; int1++)
            {
                keyboard = [tempWindow.subviews objectAtIndex:int1];
                // keyboard found, add the button
                
                if([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES){
                    UIButton* searchbtn = (UIButton*)[keyboard viewWithTag:67123];
                    if (searchbtn == nil)//to avoid adding again and again as per my requirement (previous and next button on keyboard)
                        [keyboard addSubview:doneBtn];
                    
                }//This code will work on iOS 8.0
                else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES){
                    
                    for(int int2 = 0 ; int2 < [keyboard.subviews count] ; int2++)
                    {
                        UIView* hostkeyboard = [keyboard.subviews objectAtIndex:int2];
                        
                        if([[hostkeyboard description] hasPrefix:@"<UIInputSetHost"] == YES){
                            UIButton* donebtn = (UIButton*)[hostkeyboard viewWithTag:67123];
                            if (donebtn == nil)//to avoid adding again and again as per my requirement (previous and next button on keyboard)
                                [hostkeyboard addSubview:doneBtn];
                        }
                    }
                }
            }
        }
        else
        {
            //YP - (1-10-14) - Old Code
            NSArray *arr = [[UIApplication sharedApplication] windows];
            if([arr count]>1)
            {
                UIWindow *tempWindow = [arr objectAtIndex:1];
                UIView *keyboard; //aIntVal=i //YP
                for (int aIntVal = 0; aIntVal < [tempWindow.subviews count]; aIntVal++)
                {
                    keyboard = [tempWindow.subviews objectAtIndex:aIntVal];
                    if ([[keyboard description] hasPrefix:@"<UIPeripheralHostView"] == YES)
                    {
                        [keyboard addSubview:doneBtn];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        // DLog(@"Exception : %@",exception);
    }
    @finally {
    }
}

-(void)AddDoneBtnForKeyBoard
{
    @try {
        //Create Custom Done Button For iPhone Number Keypad
        if(doneBtn)
        {
            [doneBtn removeFromSuperview];
            doneBtn=nil;
            [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
        }
        
        doneBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        doneBtn.tag=6001;
        doneBtn.adjustsImageWhenHighlighted = NO;
        doneBtn.alpha=0.5;
        boolDone=TRUE;
        doneBtn.backgroundColor=[UIColor clearColor];
        [doneBtn addTarget:self action:@selector(KeyBoardDoneBtn:) forControlEvents:UIControlEventTouchUpInside];
        [self SetDoneBtnFrameForIphoneKeyboard];
    }
    @catch (NSException *exception) {
        // DLog(@"Exception : %@",exception);
    }
    @finally {
    }
}

-(void)SetDoneBtnFrameForIphoneKeyboard
{
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
    {
        [doneBtn setTitle:@"" forState:UIControlStateNormal];

        //YP - (1-10-14) - New Code
        //NSLog(@"%@",NSStringFromCGRect(self.view.frame));
        if(isIphone5())
        {
            if(isIOS8())
            {                
                doneBtn.frame = DoneKeyBoardBtn_Land_iPhone5_IOS8;
            }
            else
            {
                doneBtn.frame = DoneKeyBoardBtn_Land_iPhone5;
            }
            [doneBtn setBackgroundImage:DoneUnSelectedImage_Land_iPhone forState:UIControlStateNormal];
            [doneBtn setBackgroundImage:DoneSelectedImage_Land_iPhone forState:UIControlStateHighlighted];
        }
        else
        {
            
            if(self.view.frame.size.width==568)
            {
                //[doneBtn setTitle:@"Done" forState:UIControlStateNormal];
                doneBtn.frame = DoneKeyBoardBtn_Land_iPhone5;
                
                [doneBtn setBackgroundImage:DoneUnSelectedImage_Land_iPhone forState:UIControlStateNormal];
            }
            else
            {
                doneBtn.frame = DoneKeyBoardBtn_Land_iPhone;
                [doneBtn setBackgroundImage:DoneUnSelectedImage_Land_iPhone forState:UIControlStateNormal];
                [doneBtn setBackgroundImage:DoneSelectedImage_Land_iPhone forState:UIControlStateHighlighted];
            }
        }
        
        //[doneBtn setBackgroundImage:DoneUnSelectedImage_Land_iPhone forState:UIControlStateNormal];
        //[doneBtn setBackgroundImage:DoneSelectedImage_Land_iPhone forState:UIControlStateHighlighted];
    }
    else
    {
        doneBtn.frame = DoneKeyBoardBtn_Port_iPhone;
        [doneBtn setBackgroundImage:DoneUnSelectedImage_Port_iPhone forState:UIControlStateNormal];
        [doneBtn setBackgroundImage:DoneSelectedImage_Port_iPhone forState:UIControlStateHighlighted];
    }
    
    //NSLog(@"%@",NSStringFromCGRect(doneBtn.frame));
}
-(void)RemoveKeyBoard
{
    @try {
        [searchingViewObj.searchBarObj resignFirstResponder];
        searchingViewObj.searchBarObj.text=@"";
        [doneBtn removeFromSuperview];
        doneBtn=nil;
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    }
    @catch (NSException *exception) {
        // DLog(@"Exception : %@",exception);
    }
    @finally {
    }
}

-(IBAction)KeyBoardDoneBtn:(UIButton*)sender
{
    if(boolDone==FALSE)
    {
        [self RemoveKeyBoard];
    }
    else
    {
        if([searchingViewObj.searchBarObj.text intValue] > [document.pageCount integerValue] || [searchingViewObj.searchBarObj.text intValue] <= 0)
        {
            if([[searchingViewObj.searchBarObj.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]<=0)
            {
                [self ShowAlertView:@"Please Enter Any Text Here."];
                searchingViewObj.searchBarObj.text=@"";
            }
            else if([searchingViewObj.searchBarObj.text intValue] > 0)
                [self ShowAlertView:[NSString stringWithFormat:@"Oops!! This Document Has Only %d Pages.",[document.pageCount integerValue]]];
            else
                [self ShowAlertView:@"Oops!! This Is Not A Valid Page Number."];
        }
        else
        {
            int intPage=[searchingViewObj.searchBarObj.text intValue];
            [self showDocumentPage:intPage];
            [self RemoveKeyBoard];
            [self DismissSearchingView];
        }
        return;
    }
}

- (void)removeKeyboardDoneButton
{
    NSArray *arTemp = [[UIApplication sharedApplication] windows];
    if ([arTemp count] <= 1) return;
    UIWindow* tempWindow = [[[UIApplication sharedApplication] windows] objectAtIndex:1];
    UIView* keyboard;
    for(int aInt=0; aInt<[tempWindow.subviews count]; aInt++)
    {
        keyboard = [tempWindow.subviews objectAtIndex:aInt];
        // keyboard found, add the button
        if ([[keyboard description] hasPrefix:@"<UIPeripheralHost"] == YES)
        {
            for (id temp in keyboard.subviews)
            {
                if ([temp isKindOfClass:[UIButton class]])
                {
                    UIButton *btnDone = (UIButton*) temp;
                    [btnDone removeFromSuperview];
                    break;
                }
            }
        }
        //This code will work on iOS 8.0
        else if([[keyboard description] hasPrefix:@"<UIInputSetContainerView"] == YES)
        {
            for(int aIntVal = 0 ; aIntVal < [keyboard.subviews count] ; aIntVal++)
            {
                UIView* hostkeyboard = [keyboard.subviews objectAtIndex:aIntVal];
                if([[hostkeyboard description] hasPrefix:@"<UIInputSetHost"] == YES)
                {
                    for (id temp in hostkeyboard.subviews)
                    {
                        if ([temp isKindOfClass:[UIButton class]])
                        {
                            UIButton *btnDone = (UIButton*) temp;
                            [btnDone removeFromSuperview];
                            break;
                        }
                    }
                }
            }
        }
        else{}
    }
}


@end
