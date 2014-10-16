//
//  FeedListMenuView.h
//  NewsFeeder
//
//  Created by Cristian Ronaldo on 10/27/13.
//  Copyright (c) 2013 Cristian Ronaldo. All rights reserved.
//

#import "SuperView.h"

@protocol FeedListMenuViewDelegate;

@interface FeedListMenuView : SuperView {
    NSMutableArray * arrMenus;
}
@property (nonatomic, assign) id<FeedListMenuViewDelegate> delegate;

- (void) showWithTitles:(NSArray *)arrTitles;
- (void) hide;

@end


@protocol FeedListMenuViewDelegate <NSObject>

- (void) didClickFeedListMenu:(FeedListMenuView *)flmv index:(int)index;

@end