//
//  MenuItemCell.h
//  TapTag
//
//  Created by Harski Technology Holdings Pty. Ltd. on 9/14/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"

@interface MenuItemCell : SuperTableCell {
    IBOutlet UILabel * lblTitle;
    IBOutlet UIImageView * imgvwPhoto;
}

- (void) setCellContentWith:(int)type;
- (void) setCellContentWithLabel : (NSString*) text andImageName : (NSString*) name;

@end
