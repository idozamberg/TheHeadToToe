//
//  WebVideoViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 4/1/15.
//  Copyright (c) 2015 Cristian Ronaldo. All rights reserved.
//

#import "WebVideoViewController.h"

@interface WebVideoViewController ()

@end

UIActivityIndicatorView* activity;

@implementation WebVideoViewController

@synthesize currentWebView;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.currentViewMode = viewModeInNavigation;
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_WEBVIDEO];

    activity = [UIActivityIndicatorView new];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.navigationController.delegate = Nil;
    
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
    if (self.currentViewMode == viewModeInNavigation)
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    }
}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation
{
    [activity startAnimating];
}

- (void) webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation
{
    [activity stopAnimating];
}

- (void) webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation withError:(NSError *)error
{
    [activity stopAnimating];

}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
