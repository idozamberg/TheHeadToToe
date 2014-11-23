//
//  SuperViewController.m
//  
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/27/11.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperViewController.h"


@implementation SuperViewController
@synthesize currentViewMode = _currentViewMode;

- (SuperViewController *) viewFromStoryboard
{
    NSString* vcStoryBoardId = NSStringFromClass([self class]);
    SuperViewController* ipadVc;
    
    // Checking if it's an ipad
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
    {
        // Setting up story board id
        NSString* ipadVcId = [vcStoryBoardId stringByAppendingString:@"Ipad"];
        
        @try {
            // Trying to get the view controller from storyboard
            ipadVc = [SuperViewController viewFromStoryboard:ipadVcId];
        }
        @catch (NSException *exception) {
            // Falling for a normal view
            ipadVc = [SuperViewController viewFromStoryboard:vcStoryBoardId];
        }
        @finally {
            
        }
        
        return ipadVc;
    }
    
    return [SuperViewController viewFromStoryboard:vcStoryBoardId];
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
    self.navigationController.interactivePopGestureRecognizer.delegate = self;
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
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
