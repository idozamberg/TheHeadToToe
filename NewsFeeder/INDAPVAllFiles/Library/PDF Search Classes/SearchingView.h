
/********************************************************************************\
 *
 * File Name       SearchingView.h
 * Author          $Author:: Yasika Patel       $: Author of last commit
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>

@protocol SearchingViewDelegate

-(void)DismissSearchingView;
-(void)TextSearching:(NSString *)aStrClickMethod SearchBar:(UISearchBar *)aSearchBar;
-(void)OrientationMethod:(NSString *)aStrOrientationMethod InterfaceOrientation:(UIInterfaceOrientation)aInterfaceOrientation Duration:(NSTimeInterval)aDuration;
-(void)DidSelectMethod:(int)aInt;
@end



@interface SearchingView : UIViewController<UISearchBarDelegate,UITableViewDataSource,UITableViewDelegate>
{
    UILabel *lblSearchingiPhone;
    IBOutlet UITableView *tblViewObj;
    IBOutlet UIImageView *imgViewNavBar;
}
-(IBAction)BtnEventClick:(id)sender;
-(void)ReloadTableView;

@property(nonatomic,retain)IBOutlet UISearchBar *searchBarObj;
@property(nonatomic,retain)NSString *strSearchClick;
@property(nonatomic,retain)NSMutableArray *arrSerachingListForiPhone;
@property(retain) id<SearchingViewDelegate> delegate;

@end
