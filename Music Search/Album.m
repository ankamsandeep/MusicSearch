//
//  Album.m
//  MusicSearch
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "Album.h"

@implementation Album

- (instancetype)initWithAlbumName:(NSString *)albumName
                       albumImageURL:(NSString *)albumImageURL
                       artistName:(NSString *)artistName
                        trackName:(NSString *)trackName {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _albumName = albumName;
    _artistName = artistName;
    _trackName = trackName;
    _albumImageURL = albumImageURL;
    
    return self;
}

@end
