//
//  FeedBackViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 5/25/15.
//  Copyright (c) 2015 Cristian Ronaldo. All rights reserved.
//

#import "FeedBackViewController.h"

@interface FeedBackViewController ()

@end

@implementation FeedBackViewController
{
    UIActivityIndicatorView* activity ;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_FEEDBACK];
    
    activity = [UIActivityIndicatorView new];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    activity.center = self.view.center;
    activity.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:activity];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didClickNavBarLeftButton
{
    [self.twFeedbackText resignFirstResponder];

    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    
}


-(void)displayComposerSheet
{
    MFMailComposeViewController *picker = [[MFMailComposeViewController alloc] init];
    picker.mailComposeDelegate = self;
    
    [picker setSubject:@"Feedback!"];
    
    // Set up the recipients.
    NSArray *toRecipients = [NSArray arrayWithObjects:@"headtotoegeneva@gmail.com",
                             nil];
  
    
    [picker setToRecipients:toRecipients];

    
    // Fill out the email body text.
    NSString *emailBody = self.twFeedbackText.text;
    [picker setMessageBody:emailBody isHTML:NO];
    
    [activity startAnimating];
    
    // Present the mail composition interface.
    [self presentModalViewController:picker animated:YES];
}

// The mail compose view controller delegate method
- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error
{
    [activity stopAnimating];
    [self dismissModalViewControllerAnimated:YES];
    
    
    // If user sent
    if (result == MFMailComposeResultSent)
    {
        [UIHelper showAlertWithTitle:@"Thanks!" message:@"Votre feedback a été bien enovyé, nous vous remercions!" receiver:Nil cancelButtonTitle:@"OK" otherButtons:Nil];
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self.twFeedbackText resignFirstResponder];
}


- (IBAction)feedbackClicked:(id)sender {
    [self displayComposerSheet];
}
@end
