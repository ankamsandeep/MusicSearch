//
//  AlbumFactory.m
//  MusicSearch
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "AlbumFactory.h"

#import "Album.h"

@implementation AlbumFactory

+ (void)albumsFromRawAlbums:(NSArray *)rawAlbums
                   successBlock:(void (^)(NSArray *))successBlock {
    
    __block NSMutableArray *albums = [NSMutableArray array];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        

        for (NSDictionary *rawAlbum in rawAlbums) {
        
            NSString *albumName = rawAlbum[@"collectionCensoredName"];
            NSString *artistName = rawAlbum[@"artistName"];
            NSString *trackName = rawAlbum[@"trackName"];
            NSString *albumImageURL = rawAlbum[@"artworkUrl60"];
            
            Album *album = [[Album alloc] initWithAlbumName:albumName albumImageURL:albumImageURL artistName:artistName trackName:trackName];
            [albums addObject:album];
        }
        
        dispatch_async(dispatch_get_main_queue(), ^{
            
            successBlock(albums);
        });
    });
}

@end
