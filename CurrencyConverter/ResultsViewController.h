//
//  ResultsViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/15/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ResultsViewController;

@protocol ResultsViewControllerDelegate <NSObject>
- (void)addItemViewController:(ResultsViewController *)controller didFinishEnteringItem:(BOOL) decision;
@end

@interface ResultsViewController : UIViewController
@property (nonatomic, weak) id <ResultsViewControllerDelegate> delegate;
@property NSDictionary *dictMain, *dictNext;
@property double amount;
@property NSNumber *exchangeRate;

- (void) parseCurrRateJSONWith: (NSDictionary *)mainDict and: (NSDictionary *)nextDict;
- (UILabel *) createLabelWithFrame: (CGRect)frame withText: (NSString *)text;
- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;
- (UIButton *) createButtonWithFrame: (CGRect)frame withTag: (int)tag;
- (void) tap: (UIButton *)sender;
@end
