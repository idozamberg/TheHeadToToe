//
//  HTTVideoTableViewCell.m
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "HTTVideoTableViewCell.h"
#import "XCDYouTubeVideo.h"
#import "AppData.h"
#import "AnalyticsManager.h"

@implementation HTTVideoTableViewCell

@synthesize cellModel;

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
    
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:identifier];
    
    //   self.videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = NO;
    
    [self.videoPlayerViewController presentInView:self.vwFrame];
    
    //[self.videoPlayerViewController.moviePlayer prepareToPlay];
    
    self.videoPlayerViewController.moviePlayer.shouldAutoplay = NO;
}

- (IBAction)playClick:(id)sender {
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Video was played" Category:@"Videos" Label:[NSString stringWithFormat:@"%@ - %@",cellModel.system,cellModel.name]];
    
    [self playMovie];
}

- (void) loadThumbnailWithIdentifier  : (NSString*) identifier
{
    [self.vwFrame.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imgThumb.image = Nil;
    
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:identifier];

    //_videoPlayerViewController.moviePlayer.backgroundPlaybackEnabled = NO;
    
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
  
    [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:self.videoPlayerViewController];
    [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:self.videoPlayerViewController.moviePlayer];
}

- (void) playMovie
{
    self.imgThumb.hidden = YES;
    self.btnPlay.hidden = YES;
    
  //  [self.videoPlayerViewController presentInView:self.vwFrame];
   [[AppData sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];

    [self.videoPlayerViewController.moviePlayer play];
}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
    XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
    //self.lblTitle.text = video.title;
    
    NSURL *thumbnailURL = video.mediumThumbnailURL ?: video.smallThumbnailURL;
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        
        [self.imgThumb performSelectorInBackground:@selector(setImage:) withObject:[UIImage imageWithData:data]];
                                                                                                               
       // self.imgThumb.image =
       
    }];
}

- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
  
    self.imgThumb.hidden = NO;
    self.btnPlay.hidden = NO;
    
    if (error)
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
       // [alertView show];
    }
}


@end
