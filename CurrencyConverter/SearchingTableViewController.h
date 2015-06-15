//
//  SearchingTableViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/12/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchingTableViewController : UITableViewController

@property UIBarButtonItem *doneButton;
@property NSMutableArray *currency;

- (void) done;
- (NSMutableArray *) parseJSON;
@end
