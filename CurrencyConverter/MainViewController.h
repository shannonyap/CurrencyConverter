//
//  MainViewController.h
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/8/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MainViewController : UINavigationController

@property NSMutableArray *imgArr, *currArr;
@property UIImageView *cityView, *nextCityView;
@property int cityCount, nextCityCount;
@property CGRect endFrame;

- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize; // method to make circles
- (void) animateCity:(NSTimer *)timer;
- (UIImageView *) getView: (NSMutableArray *)arr : (CGRect)frame :(int) imgNum;
- (NSMutableArray *) populateArr: (NSMutableArray *)arr :(NSString *)ext :(NSString *)dir;
@end
