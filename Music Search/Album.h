//
//  Album.h
//  MusicSearch
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Album : NSObject

@property (strong, nonatomic) NSString *trackName;
@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSString *albumName;
@property (strong, nonatomic) UIImage *albumImage;
@property (strong, nonatomic) NSString *albumImageURL;


- (instancetype)initWithAlbumName:(NSString *)albumName
                       albumImageURL:(NSString *)albumImageURL
                       artistName:(NSString *)artistName
                        trackName:(NSString *)trackName;
@end
