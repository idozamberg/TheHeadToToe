//
//  SplashViewController.m
//  HeadToToe
//
//  Created by ido zamberg on 18/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "SplashViewController.h"
#import "MenuViewController.h"

@interface SplashViewController ()

@end

@implementation SplashViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    SuperViewController* menuVC = (SuperViewController *)[[UICustomNavigationController alloc] initWithRootViewController:[[MenuViewController alloc] viewFromStoryboard]];
    
    sleep(2);
    
    [self.navigationController pushViewController:menuVC animated:YES];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
