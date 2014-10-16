//
//  SuperViewController.m
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperViewController.h"


@implementation SuperViewController


- (SuperViewController *) viewFromStoryboard
{
    return [SuperViewController viewFromStoryboard:NSStringFromClass([self class])];
}

+ (SuperViewController *) viewFromStoryboard:(NSString *)storyboardID
{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    SuperViewController * controller = [storyBoard instantiateViewControllerWithIdentifier:storyboardID];
    
    return controller;
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	[super viewDidLoad];
    
    [self resize];
}


- (void) viewWillAppear:(BOOL)animated
{
    ;
}

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void) setEnable:(BOOL)enable
{
    [self.view setUserInteractionEnabled:enable];
}


- (void) resize
{
    [self.view setFrame:CGRectMake( 0, 0, gScreenSize.width, gScreenSize.height )];
}


@end
