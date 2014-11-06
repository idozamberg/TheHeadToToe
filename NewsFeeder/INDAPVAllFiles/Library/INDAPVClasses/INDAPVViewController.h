
/********************************************************************************\
 *
 * File Name       INDAPVViewController.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>
#import <MessageUI/MessageUI.h>

#import "INDAPVDocument.h"
#import "INDAPVContentView.h"
#import "INDAPVMainToolbar.h"
#import "INDAPVMainPagebar.h"
#import "INDAPVPreviewsViewController.h"

#import "INDAPVScanner.h"
#import "INDAPVSideMenu.h"
#import "SearchingView.h"
#import "PopoverBackgroundView.h"

@class INDAPVViewController;
@class INDAPVMainToolbar;

@protocol INDAPVViewControllerDelegate <NSObject>

@optional // Delegate protocols

//- (void)dismissReaderViewController:(INDAPVViewController *)viewController;

@end

@interface INDAPVViewController : UIViewController <UIScrollViewDelegate, UIGestureRecognizerDelegate, MFMailComposeViewControllerDelegate,
													INDAPVMainToolbarDelegate, INDAPVMainPagebarDelegate, INDAPVContentViewDelegate,
													INDAPVPreviewsViewControllerDelegate,UISearchBarDelegate,UITableViewDelegate    ,UITableViewDataSource,SearchingViewDelegate,UIPrintInteractionControllerDelegate>
{
@private // Instance variables

	INDAPVDocument *document;

	UIScrollView *theScrollView;

	INDAPVMainToolbar *mainToolbar;

	INDAPVMainPagebar *mainPagebar;

	NSMutableDictionary *contentViews;

	UIPrintInteractionController *printInteraction;

	NSInteger currentPage;
    
    

	CGSize lastAppearSize;

	NSDate *lastHideTime;

	BOOL isVisible;
    CGPDFDocumentRef PDFdocument;
    UISearchBar *searchBar;
    UISearchDisplayController *searchBarVC;
    Boolean Searching;
    UIPopoverController *searchPopVC;
    UITableView *tblSearchResult;
    UIViewController *SearchWordVC,*SearchPageVC;
    
    NSArray *selections;
	INDAPVScanner *scanner;
    NSString *keyword;
    
    CGPDFPageRef PDFPageRef;
    CGPDFDocumentRef PDFDocRef;
    NSMutableArray *arrSearchPagesIndex;
    int i;
    BOOL OrientationLock;

    //Y
    UIImageView *imgViewHMMenu;
    UISlider *SliderBrightness;
    UIImageView *imgViewBrightness,*imgViewSliderBG;
    BOOL boolBrightnessTap;
    NSString *strSearch;
    int intClickBtn;
    UILabel *lblSearching;
    BOOL boolScrollPage;
    NSMutableString *strSearchPageNumber,*strSearchWord;
    PopoverBackgroundView *popoverBackgroundViewObj;
    
    //iPhone
    UIView *viewMenuBtns;
    BOOL boolMenuOpen;
    SearchingView *searchingViewObj;
    UIImageView *imgViewBG;
    NavigationControllerIOS6 *navControllerObj;
    UIButton *doneBtn;
    BOOL boolDone;
    //end

}
@property (nonatomic, assign, readwrite) id <INDAPVViewControllerDelegate> delegate;//Y Comment
@property (nonatomic,retain)UISearchBar *searchBarObj;
- (id)initWithReaderDocument:(INDAPVDocument *)object;
@property (nonatomic, retain) INDAPVScanner *scanner;
@property (nonatomic, copy) NSArray *selections;
@property (nonatomic, copy) NSString *keyword;

//Y
-(void)SetFramesForOrientation;

//HM Side Menu
@property (nonatomic, assign) BOOL menuIsVisible;
@property (nonatomic, strong) INDAPVSideMenu *sideMenu;

- (id)initWithPath:(NSString*)path andPassword:(NSString*)password;
//End

@end
