/********************************************************************************\
 *
 * File Name       SearchingView.m
 * Author          $Author:: Yasika Patel       $: Author of last commit
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/

#import "SearchingView.h"

#define PinkColor [UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_Red.png"]]

@interface SearchingView ()

@end

@implementation SearchingView
@synthesize strSearchClick,arrSerachingListForiPhone,searchBarObj;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Add the shadow to the view
    imgViewNavBar.layer.shadowColor = [UIColor blackColor].CGColor;
    imgViewNavBar.layer.shadowOffset = CGSizeMake(0, 1);
    imgViewNavBar.layer.shadowOpacity = 1;
    imgViewNavBar.layer.shadowRadius = 1.0;
    
    [searchBarObj setTintColor:PinkColor];
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Color_White.png"]]];
    
        self.edgesForExtendedLayout = UIRectEdgeNone;
    
}

-(void)dealloc
{
    [lblSearchingiPhone release];
    lblSearchingiPhone=nil;
    
    [imgViewNavBar release];
    imgViewNavBar=nil;
    
    [searchBarObj release];
    searchBarObj=nil;
    
    if(tblViewObj)
    {
        tblViewObj.delegate=nil;
        tblViewObj.dataSource=nil;
        [tblViewObj release];
        tblViewObj=nil;
    }
    
    if(self.arrSerachingListForiPhone)
    {
        [self.arrSerachingListForiPhone removeAllObjects];
        [self.arrSerachingListForiPhone release];
        self.arrSerachingListForiPhone=nil;
    }
    [super dealloc];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];

    if([self.strSearchClick isEqualToString:@"SearchWord"])//
    {
        tblViewObj.delegate=self;
        tblViewObj.dataSource=self;
        tblViewObj.hidden=NO;
        
        if(!lblSearchingiPhone)
        {
            lblSearchingiPhone=[[UILabel alloc]init];
            lblSearchingiPhone.textAlignment=NSTextAlignmentCenter;
            lblSearchingiPhone.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
            lblSearchingiPhone.textColor=PinkColor;
            lblSearchingiPhone.backgroundColor=[UIColor clearColor];
            lblSearchingiPhone.text=@"Searching...";
            [self SetLableFrame];
            lblSearchingiPhone.hidden=YES;
            [tblViewObj addSubview:lblSearchingiPhone];
        }
        
        
        if(!self.arrSerachingListForiPhone)
        {
            self.arrSerachingListForiPhone = [[NSMutableArray alloc]init];
        }
        
        
        if(searchBarObj.text.length==0)
        {
            searchBarObj.placeholder=@"Enter Any Text";
            [searchBarObj setText:@""];
        }
        else
            [searchBarObj setText:searchBarObj.text];
    }
    else
    {
        searchBarObj.placeholder=@"Enter Page Number";
        [searchBarObj setText:@""];
        tblViewObj.hidden=YES;
    }
}


-(IBAction)BtnEventClick:(id)sender
{
    [self.delegate DismissSearchingView];
}

- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar
{
    return YES;
}
- (BOOL) shouldAutorotate
{
    return NO;
}
- (void)searchBarSearchButtonClicked:(UISearchBar *)aSearchBar
{
    if(!(([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad) ? 1 : 0))
    {
        if(self.arrSerachingListForiPhone)
        {
            [self.arrSerachingListForiPhone removeAllObjects];
            [self.arrSerachingListForiPhone release];
            self.arrSerachingListForiPhone=nil;
        }
        [tblViewObj reloadData];
    }
    
    if([[aSearchBar.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length]<=0)
        lblSearchingiPhone.hidden=YES;
    else
        lblSearchingiPhone.hidden=NO;
    
    [self.delegate TextSearching:@"searchBarSearchButtonClicked" SearchBar:aSearchBar];
 
}

-(void)searchBarTextDidEndEditing:(UISearchBar *)aSearchBar
{
    [self.delegate TextSearching:@"searchBarTextDidEndEditing" SearchBar:aSearchBar];
}

- (void)searchBarTextDidBeginEditing:(UISearchBar *)aSearchBar
{
    [self.delegate TextSearching:@"searchBarTextDidBeginEditing" SearchBar:aSearchBar];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)aSearchBar
{
    [self.delegate TextSearching:@"searchBarCancelButtonClicked" SearchBar:aSearchBar];
}

#pragma mark - TableView Methods

-(void)ReloadTableView
{
    lblSearchingiPhone.hidden=YES;
    [tblViewObj reloadData];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.arrSerachingListForiPhone count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]init];
    cell.backgroundColor=[UIColor clearColor];
    cell.textLabel.font=[UIFont fontWithName:@"Helvetica-Light" size:20];
    cell.textLabel.textColor=PinkColor;
    
    if ([[[arrSerachingListForiPhone objectAtIndex:indexPath.row] valueForKey:@"PageTitle"] isEqualToString:@"No Result"])
    {
        cell.textLabel.text=@"No Record Found.";
        cell.textLabel.textAlignment=UITextAlignmentCenter;
        cell.userInteractionEnabled=NO;
    }
    else
    {
        cell.textLabel.text=[[arrSerachingListForiPhone objectAtIndex:indexPath.row] valueForKey:@"PageTitle"];
        cell.userInteractionEnabled=YES;
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.delegate DidSelectMethod:indexPath.row];
}

#pragma mark - Orienatation Method

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation duration:(NSTimeInterval)duration
{
    [self.delegate OrientationMethod:@"willAnimateRotationToInterfaceOrientation" InterfaceOrientation:interfaceOrientation Duration:duration];
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{ 
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self SetLableFrame];
    [self.delegate OrientationMethod:@"willRotateToInterfaceOrientation" InterfaceOrientation:toInterfaceOrientation Duration:duration];
}

-(void)SetLableFrame
{
    if([appDelObj.strOrientation isEqualToString:@"Landscape"]||[appDelObj.strOrientation isEqualToString:@"LandscapeRight"])
        lblSearchingiPhone.frame=CGRectMake(95+appDelObj.intiPhone5, 2, 290, 40);
    else if([appDelObj.strOrientation isEqualToString:@"Portrait"]||[appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
        lblSearchingiPhone.frame=CGRectMake(5, 2, 290, 40);
}
@end
