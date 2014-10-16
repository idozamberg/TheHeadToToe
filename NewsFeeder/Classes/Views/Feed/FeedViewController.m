//
//  FeedViewController.m
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedItemSmallCell.h"
#import "FeedItemLargeCell.h"
#import "InviteViewController.h"
#import "FeedItemData.h"

@interface FeedViewController ()

@end

@implementation FeedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    // Menu View
    menuView = (FeedListMenuView *)[[FeedListMenuView alloc] viewFromStoryboard];
    [menuView setFrame:CGRectMake( 0, -1000, 320, 50 )];
    menuView.delegate = self;
    [self.view addSubview:menuView];
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_FEED];
    
    CGRect frm = btnDownArrow.frame;
    frm.origin.x = 185;
    frm.origin.y = 42;
    [btnDownArrow setFrame:frm];
    [self.navBarView addSubview:btnDownArrow];
    
    arrFeeds = [[NSMutableArray alloc] init];
    
    NSMutableArray * group1 = [[NSMutableArray alloc] init];
    [group1 addObject:[[FeedItemData alloc] initWithName:@"Grid Label" desc:@"This is some text." photo:@"feed_example1"]];
    [group1 addObject:[[FeedItemData alloc] initWithName:@"Grid Label" desc:@"This is some text." photo:@"feed_example1"]];
    
    NSMutableArray * group2 = [[NSMutableArray alloc] init];
    [group2 addObject:[[FeedItemData alloc] initWithName:@"Grid Label" desc:@"This is some text." photo:@"feed_example1"]];
    
    NSMutableArray * group3 = [[NSMutableArray alloc] init];
    [group3 addObject:[[FeedItemData alloc] initWithName:@"Grid Label" desc:@"This is some text." photo:@"feed_example1"]];
    [group3 addObject:[[FeedItemData alloc] initWithName:@"Grid Label" desc:@"This is some text." photo:@"feed_example1"]];
    
    [arrFeeds addObject:group1];
    [arrFeeds addObject:group2];
    [arrFeeds addObject:group3];
    
    [self addGestureRecognizersToPiece:self.view];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark --
#pragma mark -- Tap Gesture --

- (void)addGestureRecognizersToPiece:(UIView *)piece
{
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPiece:)];
    tapGesture.delegate = self;
    [piece addGestureRecognizer:tapGesture];
}


- (void) tapPiece:(UITapGestureRecognizer *)gestureRecognizer {
    [btnDownArrow setSelected:NO];
    [menuView hide];
}



- (IBAction) button_click:(id)sender
{
    if ([sender isEqual:btnDownArrow]) {
        [btnDownArrow setSelected:![btnDownArrow isSelected]];
        
        if ([btnDownArrow isSelected]) {
            [menuView showWithTitles:[NSArray arrayWithObjects:@"Articles", @"Related", @"Translate", @"Share", @"Unsubscribe", nil]];
        }
        else {
            [menuView hide];
        }
    }
}


#pragma mark --
#pragma mark -- Set navigationBar --

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
    
    [self tapPiece:nil];
}


- (void) didClickNavBarRightButton
{
    [self tapPiece:nil];
    
    if (rightController == nil) {
        rightController = [[InviteViewController alloc] viewFromStoryboard];
        [self.view.superview addSubview:rightController.view];
        [rightController.view setFrame:CGRectMake( 320, 0, gScreenSize.width, gScreenSize.height )];
    }
    
    [collectView setUserInteractionEnabled:!(self.view.frame.origin.x > -254)];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:0.3f];
    [UIView setAnimationDelegate:self];
    
    if (self.view.frame.origin.x > -254) {
        self.view.transform = CGAffineTransformMakeTranslation( -254 * 2, 0 );
        rightController.view.transform = CGAffineTransformMakeTranslation( -254, 0 );
    }
    else {
        self.view.transform = CGAffineTransformMakeTranslation( -254, 0 );
        rightController.view.transform = CGAffineTransformMakeTranslation( 0, 0 );
    }
    
    [UIView commitAnimations];
}


#pragma mark -- 
#pragma mark -- UICollectionViewDataSource, UICollectionViewDelegate -- 

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return [[arrFeeds objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return [arrFeeds count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell * colCell = nil;
    
    FeedItemData * item = [[arrFeeds objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    
    if (indexPath.section == 1) {
        FeedItemLargeCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedItemLargeCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FeedItemLargeCell alloc] initWithFrame:CGRectMake(0,
                                                                       0,
                                                                       320,
                                                                       184
                                                                       )];
        }
        
        [cell setFeedItemCell:item.strName
                         desc:item.strDesc
                        photo:item.strPhoto];
        
        colCell = cell;
    }
    else {
        FeedItemSmallCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"FeedItemSmallCell" forIndexPath:indexPath];
        if (cell == nil) {
            cell = [[FeedItemSmallCell alloc] initWithFrame:CGRectMake(160 * indexPath.row,
                                                                       0,
                                                                       160,
                                                                       160
                                                                       )];
        }
        
        [cell setFeedItemCell:item.strName
                         desc:item.strDesc
                        photo:item.strPhoto];
        
        colCell = cell;
    }
    
    
    CGRect frm = colCell.frame;
    if (indexPath.section == 1) {
        frm.origin.y = 160;
        frm.size.height = 184;
        frm.size.width = 320;
    }
    else {
        frm.origin.y = (indexPath.section == 0) ? 0 : 160 + 184;
        frm.origin.x = 160 * indexPath.row;
        frm.size.height = 160;
        frm.size.width = 160;
    }
    
    [colCell setFrame:frm];
    
    return colCell;
}



#pragma mark -- 
#pragma mark -- FeedListMenuViewDelegate -- 

- (void) didClickFeedListMenu:(FeedListMenuView *)flmv index:(int)index
{
    [btnDownArrow setSelected:NO];
}


@end
