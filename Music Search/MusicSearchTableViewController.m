//
//  TableViewController.m
//  Music Search
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import "MusicSearchTableViewController.h"

#import "Album.h"
#import "AlbumTableViewCell.h"
#import "LyricsViewController.h"

#import "NetworkManager.h"

static NSString *const cellIdentifier = @"AlbumCell";

@interface MusicSearchTableViewController ()
@property (strong, nonatomic) NSArray *searchResults;
@end

@implementation MusicSearchTableViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    [self setupSearchController];
    [self setupSearchBar];
    [self setupTableView];
    
    [self.view bringSubviewToFront:self.activityIndicator];
}

- (void)setupSearchController {
    
    self.searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
    self.searchController.dimsBackgroundDuringPresentation = NO;
    self.searchController.searchBar.delegate = self;
}

- (void)setupSearchBar {
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 70, 320, 44)];
    searchBar.scopeButtonTitles = @[NSLocalizedString(@"ScopeButtonMusic",@"Song")];
    searchBar.delegate = self;
    self.tableView.tableHeaderView = searchBar;
}

- (void)setupTableView {
    
    UINib *cellNib = [UINib nibWithNibName:@"NewAlbumCell" bundle:nil];
    [self.tableView registerNib:cellNib forCellReuseIdentifier:@"AlbumCell"];
}

#pragma mark - UISearchBarDelegate

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar {
    
    searchBar.showsCancelButton = YES;
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    
    searchBar.text = @"";
    searchBar.showsCancelButton = NO;
    [searchBar resignFirstResponder];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    
    [searchBar resignFirstResponder];
    searchBar.showsCancelButton = NO;
    
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
    
    __weak __typeof__(self) weakSelf = self;
    
    NetworkManager *manager = [[NetworkManager alloc] init];
    [manager getSearchResultsForSearchText:searchBar.text successBlock:^(NSArray *results) {
        
        __typeof__(self) strongSelf = weakSelf;
        strongSelf.searchResults = results;
        [strongSelf.activityIndicator stopAnimating];
        [strongSelf.tableView reloadData];
        
    } failureBlock:^(NSError *error){
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Error in searching" delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil, nil];
        [alert show];
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return self.searchResults.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    AlbumTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier forIndexPath:indexPath];
    
    Album *album = nil;
    if (self.searchResults.count > 0) {
        
        album = self.searchResults[indexPath.row];
        [cell configureCellWithAlbum:album];
    }
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
  
  [self performSegueWithIdentifier:@"LyricsScreen" sender:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return 101.0f;
}

#pragma mark - UINavigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
  
  NSIndexPath *indexPath = (NSIndexPath *)sender;
  
  AlbumTableViewCell *cell = (AlbumTableViewCell *) [self.tableView cellForRowAtIndexPath:indexPath];
  
  if ([segue.identifier isEqualToString:@"LyricsScreen"]) {
    LyricsViewController *lyricsViewController = (LyricsViewController *)segue.destinationViewController;
    lyricsViewController.album = self.searchResults[indexPath.row];
    lyricsViewController.albumImage = cell.image;
  }
}

@end
