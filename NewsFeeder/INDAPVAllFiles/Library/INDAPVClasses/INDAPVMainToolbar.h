
/********************************************************************************\
 *
 * File Name       INDAPVMainToolbar.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

#import "INDAPVToolbarView.h"
#import <MessageUI/MessageUI.h>
#import <MessageUI/MFMailComposeViewController.h>

@class INDAPVMainToolbar;
@class INDAPVDocument;

@protocol INDAPVMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar emailButton:(UIButton *)button;
- (void)tappedInToolbar:(INDAPVMainToolbar *)toolbar SettingButton:(UIButton *)button;
@end

@interface INDAPVMainToolbar : INDAPVToolbarView  <UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate>
{
@private // Instance variables

	UIButton *markButton;

	UIImage *markImageN;
	UIImage *markImageY;
    
    UIButton *btnDone;
    UIButton *btnSetting;
    UIButton *btnExport;
    UIButton *btnMail;

    
    
}

@property (nonatomic, assign, readwrite) id <INDAPVMainToolbarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame document:(INDAPVDocument *)object;

- (void)setBookmarkState:(BOOL)state;

- (void)hideToolbar;
- (void)showToolbar;

//Y
-(void)SetFramesForOrientation;
//end

@end
