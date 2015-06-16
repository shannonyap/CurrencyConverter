//
//  ResultsViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/15/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultsViewController : UIViewController

@property NSDictionary *dictMain, *dictNext;
@property int amount;
@property NSNumber *exchangeRate;
- (void) parseCurrRateJSONWith: (NSDictionary *)mainDict and: (NSDictionary *)nextDict;
- (UILabel *) createLabelWithFrame: (CGRect)frame withText: (NSString *)text;
- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize;

@end
