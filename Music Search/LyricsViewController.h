//
//  LyricsViewController.h
//  Music Search
//
//  Created by Sandeep Ankam on 9/2/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Album;

@interface LyricsViewController : UIViewController
@property (strong, nonatomic) Album *album;
@property (strong, nonatomic) UIImage *albumImage;
@end
