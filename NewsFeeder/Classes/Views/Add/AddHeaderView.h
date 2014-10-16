//
//  AddHeaderView.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import "SuperView.h"

@interface AddHeaderView : SuperView {
    IBOutlet UILabel * lblTitle;
}

- (void) setTitle:(NSString *)title;

@end
