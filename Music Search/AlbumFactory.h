//
//  AlbumFactory.h
//  MusicSearch
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlbumFactory : NSObject

+ (void)albumsFromRawAlbums:(NSArray *)rawAlbums
                   successBlock:(void (^)(NSArray *albums))successBlock;

@end
