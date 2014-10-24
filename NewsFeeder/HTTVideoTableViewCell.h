//
//  HTTVideoTableViewCell.h
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XCDYouTubeVideoPlayerViewController.h"


@interface HTTVideoTableViewCell : UITableViewCell

@property (nonatomic, strong) XCDYouTubeVideoPlayerViewController *videoPlayerViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (weak, nonatomic) IBOutlet UIView *vwFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imgThumb;

- (void) loadMovieWithIdetifier : (NSString*) identifier;
- (void) loadThumbnailWithIdentifier  : (NSString*) identifier;
- (IBAction)playClick:(id)sender;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;

- (void) playMovie;

@end
