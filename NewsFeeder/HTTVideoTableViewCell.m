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
#import "WebVideoViewController.h"

@implementation HTTVideoTableViewCell

@synthesize cellModel;
@synthesize videoPlayerViewController = _videoPlayerViewController;

- (void)awakeFromNib {
    // Initialization code
    NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
    
    [defaultCenter removeObserver:self name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:_videoPlayerViewController];
    [defaultCenter removeObserver:self name:MPMoviePlayerPlaybackDidFinishNotification object:_videoPlayerViewController];
    
    [self loadThumbnailWithIdentifier:@""];
    
}

- (void) layoutSubviews
{
    [self.vwFrame setCenter:CGPointMake(self.frame.size.width / 2, self.frame.size.height / 2)];
    

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
    
  
    // Play file
    [self showVideoWithUrlString:cellModel.name];
    
}

- (void) showVideoWithUrlString : (NSString*) videoUrl
{
    // Creating web view controller
    WebVideoViewController* webViewVC = [WebVideoViewController new];
    
    // calculating frame
    CGRect frame = [[UIScreen mainScreen] applicationFrame];
    frame.origin.y = 64;
    
    // Creating web view
    WKWebViewConfiguration *theConfiguration = [[WKWebViewConfiguration alloc] init];
    WKWebView *wkWebView = [[WKWebView alloc] initWithFrame:frame configuration:theConfiguration];
    //webView.navigationDelegate = self;
    
    // Creating url nad request by string
    NSURL *nsurl=[NSURL URLWithString:videoUrl];
    NSURLRequest *nsrequest=[NSURLRequest requestWithURL:nsurl];
    
    // Setting delete
    [wkWebView setNavigationDelegate:webViewVC];
    
    // Loading request
    [wkWebView loadRequest:nsrequest];
    
    // Addind web view to VC
    [webViewVC.view addSubview:wkWebView];
    
    // Showing video
    [[AppData sharedInstance].currNavigationController pushViewController:webViewVC animated:YES];
    
    webViewVC.navBarView.lblTitle.text = cellModel.fileDescription;
}

- (void) loadThumbnailWithIdentifier  : (NSString*) identifier
{
    self.imgThumb.hidden = NO;
    self.imgThumb.image = [UIImage imageNamed:cellModel.thumb];
    NSLog(@"%@",cellModel.thumb);
}

- (void) playMovie
{


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
