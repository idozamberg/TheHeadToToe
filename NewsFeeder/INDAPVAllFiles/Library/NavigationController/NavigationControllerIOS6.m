
/********************************************************************************\
 *
 * File Name       NavigationControllerIOS6.m
 * Author          $Author:: Yasika Patel       $: Author of last commit
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import "NavigationControllerIOS6.h"

@interface NavigationControllerIOS6 ()

@end

@implementation NavigationControllerIOS6

#pragma mark - Printer Method For iPhone

-(void)ShowPrinter:(BOOL)aBool
{
    boolPrinterShow=aBool;
}

#pragma mark - IOS6 Orientation Methods

- (BOOL)shouldAutorotate
{
    return NO;
}

-(NSUInteger)supportedInterfaceOrientations
{
    UIDeviceOrientation aInterfaceOrientationObj = [[UIDevice currentDevice] orientation];
    if (aInterfaceOrientationObj == UIInterfaceOrientationLandscapeLeft)
    {
        appDelObj.strOrientation = @"Landscape";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationLandscapeRight)
    {
        appDelObj.strOrientation = @"LandscapeRight";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationPortrait)
    {
        appDelObj.strOrientation = @"Portrait";
    }
    else if(aInterfaceOrientationObj == UIInterfaceOrientationPortraitUpsideDown)
    {
        appDelObj.strOrientation = @"PortraitUpsideDown";
    }

    if(boolPrinterShow==YES)
    {
        return UIInterfaceOrientationMaskPortrait;
    }
    else
        return UIInterfaceOrientationMaskPortrait;
    
}

#pragma mark -- Before IOS6 Orientation Methods

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationLandscapeLeft)
    {
        appDelObj.strOrientation = @"Landscape";
    }
    else if(interfaceOrientation == UIInterfaceOrientationLandscapeRight)
    {
        appDelObj.strOrientation = @"LandscapeRight";
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        appDelObj.strOrientation = @"Portrait";
    }
    else if(interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown)
    {
        appDelObj.strOrientation = @"PortraitUpsideDown";
    }
   
    
    if(boolPrinterShow==YES){
        if([appDelObj.strOrientation isEqualToString:@"PortraitUpsideDown"])
            return NO;
        else
            return YES;
    }
    else
        return YES;
}

@end
