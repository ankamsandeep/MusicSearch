//
//  Lyrics.h
//  Music Search
//
//  Created by Sandeep Ankam on 9/2/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Lyrics : NSObject
@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSString *song;
@property (strong, nonatomic) NSString *lyrics;
@property (strong, nonatomic) NSString *lyricsURL;
@end

