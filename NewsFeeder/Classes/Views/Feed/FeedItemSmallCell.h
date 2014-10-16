//
//  FeedItemSmallCell.h
//  NewsFeeder
//
//  Created by Harski Technology Holdings Pty. Ltd. on 10/4/13.
//  Copyright (c) 2013 Harski Technology Holdings Pty. Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedItemSmallCell : UICollectionViewCell {
    IBOutlet UILabel * lblTitle;
    IBOutlet UILabel * lblDesc;
    
    IBOutlet UIImageView * imgvwPhoto;
}

- (void) setFeedItemCell:(NSString *)title desc:(NSString *)desc photo:(NSString *)photo;

@end
