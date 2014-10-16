//
//  FileCell.h
//  NewsFeeder
//
//  Created by ido zamberg on 10/11/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FileCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *lblFileName;
@property (weak, nonatomic) IBOutlet UILabel *lblFileDescription;

@end
