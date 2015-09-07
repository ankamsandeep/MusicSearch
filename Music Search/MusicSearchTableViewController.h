//
//  TableViewController.h
//  Music Search
//
//  Created by Sandeep Ankam on 9/1/15.
//  Copyright (c) 2015 Sandeep Ankam. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MusicSearchTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) UISearchController *searchController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end
