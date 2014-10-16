//
//  InviteCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"
#import "InviteCell.h"
#import "InviteItemData.h"

@protocol InviteCellDelegate;

@interface InviteCell : SuperTableCell {
    IBOutlet UIImageView * imgvwPhoto;
    IBOutlet UILabel * lblName;
    IBOutlet UILabel * lblAddr;
    
    IBOutlet UIButton * btnAdd;
}
@property (nonatomic, assign) id<InviteCellDelegate> delegate;


- (void) setInviteCellWith:(InviteItemData *)iid;

@end


@protocol InviteCellDelegate <NSObject>

- (void) didChooseFriend:(InviteCell *)ic;

@end