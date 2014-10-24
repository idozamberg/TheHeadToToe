//
//  HTTVideoCell.h
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDYouTubeVideoPlayerViewController.h"

@interface HTTVideoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *vwFrame;
@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;

- (void) loadMovieWithIdetifier : (NSString*) identifier;
@end
