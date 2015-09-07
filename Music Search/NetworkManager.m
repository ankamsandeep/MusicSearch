//
//  NetworkManager.m
//  MusicSearch
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "NetworkManager.h"
#import "AlbumFactory.h"

NSString *const baseURL = @"https://itunes.apple.com/search?term=";

@interface NetworkManager ()

@property (strong, nonatomic) NSXMLParser *parser;
@property (strong, nonatomic) NSMutableArray *response;
@property (strong, nonatomic) NSMutableDictionary *responseDictionary;

@property (strong, nonatomic) NSMutableString *checkSumString;
@property (strong, nonatomic) NSMutableString *artist;
@property (strong, nonatomic) NSMutableString *song;
@property (strong, nonatomic) NSString *currentElement;

@property (strong, nonatomic) NSString *artistName;
@property (strong, nonatomic) NSString *songName;
@property (copy, nonatomic) void (^successBlock)(NSDictionary *response);

@end

@implementation NetworkManager

+ (instancetype)sharedInstance {
    
    static NetworkManager *sharedInstance = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedInstance = [[NetworkManager alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype) init {
    
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _response = [NSMutableArray array];
    _responseDictionary = [NSMutableDictionary dictionary];
    
    return self;
}

- (void)getSearchResultsForSearchText:(NSString *)searchText
                         successBlock:(void (^)(NSArray *))successBlock
                         failureBlock:(void (^)(NSError *))failureBlock {
    
    
    
    NSString *formattedString = [NSString stringWithFormat:@"%@%@", baseURL, [self searchTextForQuering:searchText]];
    
    NSURL *url = [NSURL URLWithString:formattedString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      NSError *serializationError = nil;
                                      NSDictionary *rawResponse = [NSJSONSerialization JSONObjectWithData:data
                                                                                                  options:NSJSONReadingAllowFragments
                                                                                                    error:&serializationError];
                                      
                                      if (error || serializationError) {
                                          failureBlock(error);
                                      }
                                      else {
                                          [AlbumFactory albumsFromRawAlbums:rawResponse[@"results"] successBlock:^(NSArray *albums){
                                              successBlock(albums);
                                          }];
                                      }
                                  }];
    
    [task resume];
}

- (NSString *)searchTextForQuering:(NSString *)searchText {
    
    return [searchText stringByReplacingOccurrencesOfString:@" " withString:@"+"];
}

#pragma mark - Lyrics

- (void)getLyricsForSong:(NSString *)trackName
              artistName:(NSString *)artistName
            successBlock:(void (^)(NSDictionary *))successBlock
            failureBlock:(void (^)(NSError *))failureBlock {
    
    
    self.artistName = artistName;
    self.songName = trackName;
    self.successBlock = successBlock;
    
    NSString *formattedString = [NSString stringWithFormat:@"http://api.chartlyrics.com/apiv1.asmx/SearchLyric?artist=%@&song=%@", artistName, trackName];
    NSString *encodedSearchString = [formattedString stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSURL *url = [NSURL URLWithString:encodedSearchString];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    
    __weak __typeof__(self) weakSelf = self;
    
    NSURLSessionDataTask *task = [session dataTaskWithRequest:request completionHandler:
                                  ^(NSData *data, NSURLResponse *response, NSError *error) {
                                      
                                      __typeof__(self) strongSelf = weakSelf;
                                      strongSelf.parser = [[NSXMLParser alloc] initWithData:data];
                                      strongSelf.parser.delegate = strongSelf;
                                      [strongSelf.parser parse];
                                      
                                  }];
    
    [task resume];
}

#pragma mark - NSXMLParserDelegate

- (void)parserDidEndDocument:(NSXMLParser *)parser {
    
    self.successBlock(self.responseDictionary);
}

- (void)parser:(NSXMLParser *)parser parseErrorOccurred:(NSError *)parseError {
    
    NSLog(@"%@", [parseError localizedDescription]);
}

- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName
  namespaceURI:(NSString *)namespaceURI
 qualifiedName:(NSString *)qName
    attributes:(NSDictionary *)attributeDict{
    
    if ([elementName isEqualToString:@"SearchLyricResult"]) {
        
        self.checkSumString = [NSMutableString string];
        self.artist = [NSMutableString string];
        self.song = [NSMutableString string];
    }
    
    self.currentElement = elementName;
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    
    if ([self.currentElement isEqualToString:@"Artist"]) {
        
        [self.artist appendString:string];
    }
    else if ([self.currentElement isEqualToString:@"Song"]) {
        
        [self.song appendString:string];
    }
    else if([self.currentElement isEqualToString:@"LyricChecksum"]) {
        
        [self.checkSumString appendString:string];
    }
}

- (void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName{
    
    if ([elementName isEqualToString:@"SearchLyricResult"]) {
        
        NSString *tempSong = [self.song stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tempArtist = [self.artist stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *tempChecksum = [self.checkSumString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        NSString *formattedString = [NSString stringWithFormat:@"%@+%@", tempSong, tempArtist];
        [self.responseDictionary setObject:tempChecksum forKey:formattedString];
    }
}

@end
