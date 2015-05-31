//
//  AboutViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 5/30/15.
//  Copyright (c) 2015 Cristian Ronaldo. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

@end

@implementation AboutViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // Insert Navigation Bar
    [self insertNavBarWithScreenName:SCREEN_ABOUT];
    
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) didClickNavBarLeftButton
{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"LeftSideBarButtonClicked" object:Nil];
    
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
