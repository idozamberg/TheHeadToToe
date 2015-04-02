//
//  WebVideoViewController.h
//  HeadToToe
//
//  Created by ido zamberg on 4/1/15.
//  Copyright (c) 2015 Cristian Ronaldo. All rights reserved.
//

#import "CustomNavViewController.h"
#import "WebKit/WebKit.h"

@interface WebVideoViewController : CustomNavViewController <WKNavigationDelegate>

@property (nonatomic,strong) WKWebView* currentWebView;

@end
