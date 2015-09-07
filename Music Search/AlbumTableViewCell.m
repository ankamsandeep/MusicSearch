//
//  AlbumTableViewCell.m
//  Music Search
//
//  Created by Sandeep Ankam on 9/2/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "AlbumTableViewCell.h"
#import "Album.h"

@interface AlbumTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *artistName;
@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UIImageView *albumImage;
@end

@implementation AlbumTableViewCell

- (void)configureCellWithAlbum:(Album *)album {
    
    self.albumName.text = album.albumName;
    self.artistName.text = album.artistName;
    self.trackName.text = album.trackName;
    
    [self setupAlbumImageFromURL:album.albumImageURL];
}

- (void)setupAlbumImageFromURL:(NSString *)albumImageURL {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURL *url = [NSURL URLWithString:albumImageURL];
        NSData *data = [NSData dataWithContentsOfURL:url];
        self.image = [UIImage imageWithData:data];
      
        dispatch_async(dispatch_get_main_queue(), ^{
            self.albumImage.image = self.image;
        });
    });
}

@end
