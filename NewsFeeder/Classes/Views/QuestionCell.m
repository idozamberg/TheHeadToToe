//
//  QuestionCell.m
//  HeadToToe
//
//  Created by ido zamberg on 10/12/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "QuestionCell.h"
#import "AdmissionQuestion.h"
#import "AppData.h"

@implementation QuestionCell
{
    HTTFile* questionVideo;
    XCDYouTubeVideoPlayerViewController* videoPlayerViewController;
}

@synthesize isChecked = _isChecked;
@synthesize cellModel = _cellModel;

- (void)awakeFromNib {
    // Initialization code
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeTextDown) name:@"ViewTapped" object:Nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(takeTextDown) name:@"ViewTappedFromInside" object:Nil];
    
}

- (void) setCellModel:(AdmissionQuestion *)cellModel
{
    _cellModel = cellModel;
    
    // Getting video
    questionVideo = [[AppData sharedInstance] videoIdentifierForTest:self.cellModel.text];
    
    // If we have a video set it up
    if (questionVideo)
    {
        // Initiating video player
        videoPlayerViewController = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:questionVideo.name];
        
        // Setting notifications
        NSNotificationCenter *defaultCenter = [NSNotificationCenter defaultCenter];
     //   [defaultCenter addObserver:self selector:@selector(videoPlayerViewControllerDidReceiveVideo:) name:XCDYouTubeVideoPlayerViewControllerDidReceiveVideoNotification object:videoPlayerViewController];
        [defaultCenter addObserver:self selector:@selector(moviePlayerPlaybackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:videoPlayerViewController.moviePlayer];
    }
}

- (void) takeTextDown
{
    [self.txtComment resignFirstResponder];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void) setIsChecked:(BOOL)isChecked
{
    _isChecked = isChecked;
    
    if (self.cellModel.wasChecked)
    {
        self.imgCheck.image = [UIImage imageNamed:@"check-on"];
    }
    else
    {
        self.imgCheck.image = [UIImage imageNamed:@"check-off"];
    }
    
    self.btnComment.hidden = !_isChecked;
    
    if (questionVideo)
    {
        self.btnVideo.hidden = !_isChecked;
    }
    else
    {
        self.btnVideo.hidden = YES;
    }
    
  
}

- (IBAction)commentClicked:(id)sender {
    
    YIPopupTextView* popupTextView = [[YIPopupTextView alloc] initWithPlaceHolder:@"Tapez vos commentaires ici" maxCount:100 buttonStyle:YIPopupTextViewButtonStyleRightDone];
    popupTextView.delegate = self;
    popupTextView.caretShiftGestureEnabled = YES;   // default = NO
    //popupTextView.editable = NO;                  // set editable=NO to show without keyboard
    
    // Show text view
    [popupTextView showInViewController:[AppData sharedInstance].currNavigationController];
    //[popupTextView showInView:self.view];
    //[popupTextView showInView:self.superview.superview.superview]; // recommended, especially for iOS7
}


- (IBAction)videoClicked:(id)sender {
    
    [[AppData sharedInstance].currNavigationController presentMoviePlayerViewControllerAnimated:videoPlayerViewController];
    
    [videoPlayerViewController.moviePlayer play];
}

- (IBAction)checkClicked:(id)sender {
    
    if (self.cellModel.wasChecked)
    {
        self.cellModel.wasChecked = NO;
        self.imgCheck.image = [UIImage imageNamed:@"check-off"];
        self.btnVideo.hidden = YES;
    }
    else
    {
        self.cellModel.wasChecked = YES;
        self.imgCheck.image = [UIImage imageNamed:@"check-on"];
        
        // Setting parameters
        [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:self.cellModel.text,@"Question Text", nil];
        
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Question check" Category:@"Questions" Label:self.cellModel.text];
        
    }

    // Hiding/Showing comment
    self.btnComment.hidden = !self.cellModel.wasChecked;
    
    if (questionVideo)
    {
        self.btnVideo.hidden = !self.cellModel.wasChecked;
    }
    else
    {
        self.btnVideo.hidden = YES;
    }
    
    // Showing input text for anamnes actuelle
    if (self.cellModel.wasChecked)
    {
        if ([self.cellModel.questionSection isEqualToString:@"Anamnèse actuelle"])
        {
            [self commentClicked:self];
        }
    }
    
    // Notifiying view was clicked
    [[NSNotificationCenter defaultCenter] postNotificationName:@"ViewTappedFromInside" object:Nil];
}

- (void)popupTextView:(YIPopupTextView*)textView willDismissWithText:(NSString*)text cancelled:(BOOL)cancelled
{
    if (![text isEqualToString:@""])
    {
        // Setting parameters
        [AnalyticsManager sharedInstance].flurryParameters = [NSDictionary dictionaryWithObjectsAndKeys:self.cellModel.text,@"Question Text", nil];
        
        // Sending analytics
        [AnalyticsManager sharedInstance].sendToFlurry = YES;
        [[AnalyticsManager sharedInstance] sendEventWithName:@"Comment added to question" Category:@"Questions" Label:self.cellModel.text];
    }
    
    self.cellModel.comment = text;
}


- (void) moviePlayerPlaybackDidFinish:(NSNotification *)notification
{
    NSError *error = notification.userInfo[XCDMoviePlayerPlaybackDidFinishErrorUserInfoKey];
    
    if (error)
    {
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil) message:error.localizedDescription delegate:nil cancelButtonTitle:NSLocalizedString(@"OK", nil) otherButtonTitles:nil];
        // [alertView show];
    }
}
@end
