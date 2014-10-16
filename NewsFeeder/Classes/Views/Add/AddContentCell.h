//
//  AddContentCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"
#import "NewsItemData.h"

@protocol AddContentCellDelegate;

@interface AddContentCell : SuperTableCell {
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblSubscribes;
    IBOutlet UIImageView * imgvwIcon;
    
    IBOutlet UIButton * btnAdd;
}
@property (nonatomic, assign) id<AddContentCellDelegate> delegate;


- (void) setAddContentCellWith:(NewsItemData *)data;
- (IBAction) button_click:(id)sender;

@end


@protocol AddContentCellDelegate <NSObject>

- (void) willAddFeed:(AddContentCell *)acc;

@end