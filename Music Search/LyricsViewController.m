//
//  LyricsViewController.m
//  Music Search
//
//  Created by Sandeep Ankam on 9/2/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "LyricsViewController.h"
#import "Album.h"
#import "NetworkManager.h"

@interface LyricsViewController ()

@property (weak, nonatomic) IBOutlet UILabel *albumName;
@property (weak, nonatomic) IBOutlet UILabel *trackName;
@property (weak, nonatomic) IBOutlet UILabel *artistName;

@property (weak, nonatomic) IBOutlet UIImageView *albumImageView;
@property (weak, nonatomic) IBOutlet UILabel *songName;
@property (weak, nonatomic) IBOutlet UILabel *lyricURL;
@property (weak, nonatomic) IBOutlet UITextView *lyricsTextView;

@end

@implementation LyricsViewController

#pragma mark - View Lifecycle

- (void)viewDidLoad {
  
  [super viewDidLoad];
  
  self.albumName.text = self.album.albumName;
  self.trackName.text = self.album.trackName;
  self.artistName.text = self.album.artistName;
  self.albumImageView.image = self.albumImage;
  
  [self lyricsForSong:self.album.trackName artistName:self.album.artistName];
}

- (void)lyricsForSong:(NSString *)trackName artistName:(NSString *)artistName {
  
  NetworkManager *manager = [NetworkManager sharedInstance];
  
  [manager getLyricsForSong:trackName artistName:artistName
               successBlock:^(NSDictionary *response)
   {
       
       for (NSString *string in [response allKeys]) {
           
           NSLog(@"%@", string);
       }
       
       NSLog(@"%@", response);

   } failureBlock:^(NSError *error){
     
   }];
}

@end
