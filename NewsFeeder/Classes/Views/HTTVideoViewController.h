//
//  HTTVideoViewController.h
//  HeadToToe
//
//  Created by ido zamberg on 22/10/14.
//  Copyright (c) 2014 Cristian Ronaldo. All rights reserved.
//

#import "CustomNavViewController.h"
#import "XCDYouTubeVideoPlayerViewController.h"
#import "HTTVideoTableViewCell.h"

@interface HTTVideoViewController : CustomNavViewController <videoCellProtocol,UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tblVideos;
@property (nonatomic,strong) NSMutableArray* filesList;
@property (nonatomic,strong) NSString*       system;
@property (weak, nonatomic) IBOutlet UIButton *btnPlay;
- (IBAction)playClick:(id)sender;




@end
