
/********************************************************************************\
 *
 * File Name       INDAPVPreviewsMainToolbar.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/



#import <UIKit/UIKit.h>

#import "INDAPVToolbarView.h"

@class INDAPVPreviewsMainToolbar;

@protocol INDAPVPreviewsMainToolbarDelegate <NSObject>

@required // Delegate protocols

- (void)tappedInToolbar:(INDAPVPreviewsMainToolbar *)toolbar doneButton:(UIButton *)button;
- (void)tappedInToolbar:(INDAPVPreviewsMainToolbar *)toolbar showControl:(id)sender;

@end

@interface INDAPVPreviewsMainToolbar : INDAPVToolbarView
{
    UIButton *btnMultiPage;
    UIButton *btnBookmark;
    UILabel *titleLabel;
@private // Instance variables
}

@property (nonatomic, assign, readwrite) id <INDAPVPreviewsMainToolbarDelegate> delegate;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title;
-(void)SetFramesForOrientation;
@end
