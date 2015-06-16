//
//  DecimalViewController.h
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DecimalViewController : UIViewController

@property (nonatomic, strong) UITextField *console;
@property NSString *opcode;
@property NSString *opPrev;
@property double firstNum;
@property double secondNum;
@property int pressMore;
@property int equalPress;
@property int colorCount;
@property UIImageView *consoleColor;
@property NSMutableArray *buttonArray;
@property NSMutableArray *colorArray;

- (void) tapNumber :(UIButton *)sender;
- (void) removeTap :(UIButton *)sender;
- (void) changeColorLeft: (UISwipeGestureRecognizer *) swipe;
- (void) changeColorRight: (UISwipeGestureRecognizer *) swipe;
- (void) convert;
@end
