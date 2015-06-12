//
//  MainViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/8/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController

@property NSMutableArray *imgArr, *currArr;
@property UIImageView *cityView, *nextCityView, *go, *goBar;
@property int cityCount, nextCityCount;
@property CGRect endFrame;

- (UIImageView *) getView: (NSMutableArray *)arr : (CGRect)frame :(int) imgNum withTag: (int) tag;
- (NSMutableArray *) populateArr: (NSMutableArray *)arr :(NSString *)ext :(NSString *)dir;
- (UILabel *) createAnimLabel: (CGRect)frame withDisplay: (NSString *)text;
- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize; // method to make circles
- (void) animateCity:(NSTimer *)timer;
- (void) animateButton: (UIImageView *) circle :(UIImageView *) picture withDuration: (float)duration andDelay: (float)delay;
- (void) openSearch;
- (void) nextCurr;
- (void) removeTap;

@end
