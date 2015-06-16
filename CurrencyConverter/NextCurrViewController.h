//
//  NextCurrViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/11/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MainViewController.h"

@interface NextCurrViewController : UIViewController

@property (nonatomic,strong) MainViewController *methods;
@property UILabel *nextCurr;
@property UIImageView *worldIcon;

- (void) openSearch;
- (void) nextPage;
@end
