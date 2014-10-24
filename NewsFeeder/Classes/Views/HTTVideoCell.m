//
//  HTTVideoCell.m
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTVideoCell.h"


@implementation HTTVideoCell

@synthesize lblDescription,lblTitle,vwFrame;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void) loadMovieWithIdetifier : (NSString*) identifier
{
    [self.vwFrame.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:@"BUL_OXZyeKg"];
    
 //   self.videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = NO;
    
    [self.videoPlayerViewController presentInView:self.vwFrame];
    
    [self.videoPlayerViewController.moviePlayer prepareToPlay];
    
    self.videoPlayerViewController.moviePlayer.shouldAutoplay = NO;
}


@end
