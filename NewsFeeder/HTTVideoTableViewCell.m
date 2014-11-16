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
@synthesize videoPlayerViewController = _videoPlayerViewController;

- (void)awakeFromNib {
    // Initialization code
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:_videoPlayerViewController];
    [defaultCenter removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_videoPlayerViewController];
   
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
    
    // Setting parameters
    [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:[NSString stringWithFormat:@"%@ - %@",cellModel.system,cellModel.fileDescription],@"Video Name", nil];
    
    // Sending analytics
    [AnalyticsManager sharedInstance].sendToFlurry = YES;
    [[AnalyticsManager sharedInstance] sendEventWithName:@"Video was played" Category:@"Videos" Label:[NSString stringWithFormat:@"%@ - %@",cellModel.system,cellModel.fileDescription]];
    
    [self playMovie];
}

- (void) loadThumbnailWithIdentifier  : (NSString*) identifier
{
    [self.vwFrame.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    self.imgThumb.image = Nil;
    
    // Initiating video player
    self.videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:identifier];
    
    // Setting notifications
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:_videoPlayerViewController];
    [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:_videoPlayerViewController.moviePlayer];
}

- (void) playMovie
{
    self.imgThumb.hidden = YES;
    self.btnPlay.hidden = YES;
    
    // Sending delegate
//    if ([self.delegate respondsToSelector:@selector(playClickedInVideoCellWithVideoPlayer:)])
//    {
//        [self.delegate playClickedInVideoCellWithVideoPlayer:_videoPlayerViewController];
//    }
//    else
//    {
//        [_videoPlayerViewController.moviePlayer play];
//        
//        [[AppDa  ta sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];
//    }
    [_videoPlayerViewController.moviePlayer play];
    
    [[AppData sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];
    
    /*else
    {
        [_videoPlayerViewController.moviePlayer play];
        //[_videoPlayerViewController presentInView:currentController.view];
        
        [[AppData sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];
    }
    */
    
  
   // [self.window.rootViewController.navigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];
 
    /*
    */
    
  //  [_videoPlayerViewController.moviePlayer play];
  //  [_videoPlayerViewController presentInView:self.vwFrame];
    
//    [self.window.rootViewController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];
    
  //  [[AppData sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:_videoPlayerViewController];

}

#pragma mark - Notifications

- (void) videoPlayerViewControllerDidReceiveVideo:(NSNotification *)notification
{
    XCDYouTubeVideo *video = notification.userInfo[XCDYouTubeVideoUserInfoKey];
    //self.lblTitle.text = video.title;
  
    // Creating queue
    NSOperationQueue* myQueue = [NSOperationQueue new];
    
    // Loading image asynchronously
    [myQueue addOperationWithBlock: ^ {
        
            // Loading image
            NSURL *thumbnailURL = video.mediumThumbnailURL ?: video.smallThumbnailURL;
            [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:thumbnailURL] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
                        // Update UI on the main thread.
                        [[NSOperationQueue mainQueue] addOperationWithBlock: ^ {
                            [self.imgThumb setImage:[UIImage imageWithData:data]];
                        }];
                        
                    }];
       
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
