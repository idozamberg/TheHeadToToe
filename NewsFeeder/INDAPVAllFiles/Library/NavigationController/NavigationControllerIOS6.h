
/********************************************************************************\
 *
 * File Name       NavigationControllerIOS6.h
 * Author          $Author:: Yasika Patel       $: Author of last commit
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

@interface NavigationControllerIOS6 : UINavigationController
{
    BOOL boolPrinterShow;
}
-(void)ShowPrinter:(BOOL)aBool;
@end
