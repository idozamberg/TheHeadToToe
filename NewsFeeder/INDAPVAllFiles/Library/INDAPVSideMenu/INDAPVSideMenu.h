
/********************************************************************************\
 *
 * File Name       INDAPVSideMenu.h
 * Version         $Revision:: 01               $: Revision of last commit
 * Modified        $Date:: 2013-09-13 12:09:06# $: Date of last commit
 *
 * Copyright(c) 2013 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import <UIKit/UIKit.h>

typedef enum {
    INDAPVSideMenuPositionLeft,
    INDAPVSideMenuPositionRight,
    INDAPVSideMenuPositionTop,
    INDAPVSideMenuPositionBottom
} INDAPVSideMenuPosition;

@interface INDAPVSideMenu : UIView

/**
 Current state of the side menu.
 */
@property (nonatomic, assign, readonly) BOOL isOpen;

/**
 Spacing between each menu item and the next. This will be the horizontal spacing between items in case the menu is added on the top/bottom, or vertical spacing in case the menu is added on the left/right.
 */
@property (nonatomic, assign) CGFloat itemSpacing;

/**
 Duration of the opening/closing animation.
 */
@property (nonatomic, assign) CGFloat animationDuration;

/**
 Position the side menu will be added at.
 */
@property (nonatomic, assign) INDAPVSideMenuPosition menuPosition;

/**
 Initialize the menu with an array of items.
 
 @param items An array of `UIView` objects.
 */
- (id)initWithItems:(NSArray *)items;

/**
 Show all menu items with animation.
 */
- (void)open;

/**
 Hide all menu items with animation.
 */
- (void)close;

@end

///--------------------------------
/// @name UIView+MenuActionHandlers
///--------------------------------

/**
 A category on UIView to attach a given block as an action for a single tap gesture.
 Credit: http://www.cocoanetics.com/2012/06/associated-objects/
 
 @param block The block to execute.
 */
@interface UIView (MenuActionHandlers)

- (void)setMenuActionWithBlock:(void (^)(void))block;

@end