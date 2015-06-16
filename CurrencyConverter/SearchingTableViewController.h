//
//  SearchingTableViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/12/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchingTableViewController;

@protocol SearchingTableViewControllerDelegate <NSObject>
- (void) updateCurrFor: (SearchingTableViewController *) controller With: (NSDictionary *)updates;
@end

@interface SearchingTableViewController : UITableViewController 

@property (nonatomic, weak) id <SearchingTableViewControllerDelegate> delegate;

@property UIBarButtonItem *doneButton;
@property NSMutableArray *currency;
@property NSArray *searchResults;
@property (strong, nonatomic) UISearchController *searchController;

- (void) done;
- (NSMutableArray *) parseJSON;
@end
