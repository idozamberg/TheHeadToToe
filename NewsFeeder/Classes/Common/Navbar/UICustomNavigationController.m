//
//  UICustomNavigationController.m
//  MoneySocial
//
//  Created by Harski Technology Holdings Pty. Ltd. on 3/8/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "UICustomNavigationController.h"
#import "Global.h"

@interface UICustomNavigationController ()

@end

@implementation UICustomNavigationController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    [self.navigationBar setHidden:YES];
    [self.view setFrame:CGRectMake( 0, 0, gScreenSize.width, gScreenSize.height )];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
