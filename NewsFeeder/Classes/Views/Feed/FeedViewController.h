//
//  FeedViewController.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "CustomNavViewController.h"
#import "FeedListMenuView.h"

@interface FeedViewController : CustomNavViewController<UIGestureRecognizerDelegate, FeedListMenuViewDelegate> {
    IBOutlet UIButton * btnDownArrow;
    
    IBOutlet UICollectionView * collectView;
    
    FeedListMenuView * menuView;
    
    SuperViewController * rightController;
    
    NSMutableArray * arrFeeds;
}

- (IBAction) button_click:(id)sender;

@end
