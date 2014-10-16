//
//  SettingPersonCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperTableCell.h"

@interface SettingPersonCell : SuperTableCell {
    IBOutlet UILabel * lblName;
    IBOutlet UILabel * lblMail;
    
    IBOutlet UIImageView * imgvwPhoto;
}

- (void) setCellContentWith:(NSString *)name mail:(NSString *)mail photo:(NSString *)photo;

@end
