//
//  DecimalViewController.m
//  Calculator
//
//  Created by Shannon Yap on 5/7/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "DecimalViewController.h"
#import "MainViewController.h"
#import "NextCurrViewController.h"
#import "ResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

#define darkGreen [UIColor colorWithRed: 39/255.0 green: 174/255.0 blue: 96/255.0 alpha: 1.0f]

@interface DecimalViewController ()

@end

@implementation DecimalViewController

@synthesize console, opcode, opPrev, firstNum, secondNum, pressMore, equalPress, consoleColor, buttonArray, colorArray, colorCount, goToRoot;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Enter Amount";
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle: @"Convert" style: UIBarButtonItemStyleDone target: self action: @selector(convert)];
    self.navigationItem.rightBarButtonItem.tintColor = [UIColor blackColor];
    UIImageView *backgroundImage = [[UIImageView alloc] initWithImage: nil];
    backgroundImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    backgroundImage.userInteractionEnabled = YES; // enable touch events
    [self.view addSubview:backgroundImage];
    
    // Add colors to colorArray
    self.colorArray = [[NSMutableArray alloc] initWithObjects:
                       [UIColor colorWithRed: 72.0/255.0f green:137.0/255.0f blue:249.0/255.0f alpha:0.8f], // blue
                       [UIColor colorWithRed: 72.0/255.0f green:137.0/255.0f blue:249.0/255.0f alpha:1.0f],
                       [UIColor colorWithRed: 255.0/255.0f green:98/255.0f blue: 98/255.0f alpha: 0.8f], // red
                       [UIColor colorWithRed: 255.0/255.0f green:98/255.0f blue: 98/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 212/255.0f green:137.0/255.0f blue:255.0/255.0f alpha:0.8f], // purple
                       [UIColor colorWithRed: 212/255.0f green:137.0/255.0f blue:255.0/255.0f alpha:1.0f],
                       [UIColor colorWithRed: 255.0/255.0f green: 240/255.0f blue: 137.0/255.0f alpha: 0.8f], // yellow
                       [UIColor colorWithRed: 255.0/255.0f green: 240/255.0f blue: 137.0/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 255/255.0f green: 128/255.0f blue: 0/255.0f alpha: 0.8f], // orange
                       [UIColor colorWithRed: 255/255.0f green: 128/255.0f blue: 0/255.0f alpha: 1.0f],
                       [UIColor colorWithRed: 0/255.0f green: 191/255.0f blue: 220/255.0f alpha: 0.8f], // turquoise
                       [UIColor colorWithRed: 0/255.0f green: 191/255.0f blue: 220/255.0f alpha: 1.0f],
                       nil];
    
    // Blur effect to show calculator number screen
    UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, 149.55)];
    [[img layer] setBorderWidth: 0.25];
    [[img layer] setMasksToBounds: YES];
    [backgroundImage addSubview: img];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = img.bounds;
    [img addSubview:visualEffectView];
    
    // console color
    self.consoleColor = [[UIImageView alloc] initWithFrame: CGRectMake(0, 0, self.view.bounds.size.width, img.bounds.size.height)];
    [self.consoleColor setBackgroundColor: [self.colorArray objectAtIndex: 0]];
    self.consoleColor.userInteractionEnabled = YES;
    self.navigationController.navigationBar.barTintColor = self.consoleColor.backgroundColor;
    [self.view addSubview: self.consoleColor];
    
    // Swipe to change background color!
    UISwipeGestureRecognizer *swipeLeft = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(changeColorLeft:)];
    [swipeLeft setDirection: UISwipeGestureRecognizerDirectionLeft];
    [self.consoleColor addGestureRecognizer: swipeLeft];
    
    UISwipeGestureRecognizer *swipeRight = [[UISwipeGestureRecognizer alloc] initWithTarget: self action: @selector(changeColorRight:)];
    [swipeRight setDirection: UISwipeGestureRecognizerDirectionRight];
    [self.consoleColor addGestureRecognizer: swipeRight];
    
    // Console for showing calculator input
    self.console = [[UITextField alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, img.frame.size.height)];
    [self.console setUserInteractionEnabled: NO];
    [self.console setContentVerticalAlignment: UIControlContentVerticalAlignmentBottom];
    [self.console setTextAlignment: NSTextAlignmentRight];
    self.console.adjustsFontSizeToFitWidth = YES;
    [self.console setFont: [UIFont fontWithName: @"Arial" size: 70.0f]];
    self.console.minimumFontSize = 35.0f;
    [self.console setText: @""];
    [self.view addSubview: self.console];
    
    // Creating the number pad
    CGRect numPad = CGRectMake(0, img.bounds.size.height, self.view.bounds.size.width, self.view.bounds.size.height - img.bounds.size.height - self.tabBarController.tabBar.frame.size.height);
    self.buttonArray = [[NSMutableArray alloc] init];
    int x = 0;
    int y = 0;
    for(int i = 0; i < 19; i++){
        //Create the button
        UIButton *button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, (numPad.size.height/5 * y) + img.bounds.size.height, numPad.size.width/4, (numPad.size.height)/5)];
        // create enlarged 0 button
        if (i == 16) {
            button = [[UIButton alloc] initWithFrame: CGRectMake(numPad.size.width/4 * x, (numPad.size.height/5 * y) + img.bounds.size.height, numPad.size.width/2, numPad.size.height/5)];
            x++;
        }
        x++;
        if (x % 4 == 0 && x != 0) {
            x = 0;
            y++;
        }
        
        // button design
        button.backgroundColor = [UIColor colorWithRed: 245.0/255.0f green:245.0/255.0f blue:245.0/255.0f alpha: 1.0f];
        if (i == 0 || i == 1 || i == 2 || i == 3 || i == 7 || i == 11 || i == 15 || i == 18){
            button.backgroundColor = [self.colorArray objectAtIndex: 1];
        }
        button.tag = i;
        button.titleLabel.font = [UIFont systemFontOfSize: 30];
        [[button layer] setBorderWidth: 0.25];
        [[button layer] setMasksToBounds: YES];
        [[button layer] setBorderColor: [UIColor blackColor].CGColor];
        //button actions
        [button addTarget: self action: @selector(tapNumber:) forControlEvents:UIControlEventTouchDown];
        [button addTarget: self action: @selector(removeTap:) forControlEvents:UIControlEventTouchUpInside | UIControlEventTouchDragExit];
        // get all the text and populate the number pad.
        NSArray *numPadArr = [NSArray arrayWithObjects: @"C", @"%", @"+/-", @"÷", @"1", @"2", @"3", @"×", @"4", @"5", @"6", @"-", @"7", @"8", @"9", @"+", @"0", @".", @"=", nil];
        [button setTitle: [numPadArr objectAtIndex: (NSUInteger) i ] forState: UIControlStateNormal];
        [button setTitleColor: [UIColor blackColor] forState: UIControlStateNormal];
        //Store the button in our array
        [self.buttonArray addObject:button];
    }
    for(UIButton *buttons in self.buttonArray){
        if (buttons.tag == 0 || buttons.tag == 1 || buttons.tag == 2 || buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 18){
            [buttons setTitleColor: [UIColor colorWithRed: 200.0/255.0f green:200.0/255.0f blue:200.0/255.0f alpha: 1.0f] forState: UIControlStateNormal];
        }
        //add the button to the view
        [backgroundImage addSubview:buttons];
    }
}

- (void) tapNumber:(UIButton *)sender {
    if (opcode != nil) {
        if ((pressMore != 1 || (pressMore == 1 && sender.tag != 1 && sender.tag != 2 && sender.tag != 3 && sender.tag != 7 && sender.tag != 11 && sender.tag != 15)) && (!(opPrev == NULL))){
            self.console.text = @"";
        }
        opcode = nil;
    }
    if (opcode == nil && equalPress > 0){
        if (sender.tag != 1 && sender.tag != 2 && sender.tag != 3 && sender.tag != 7 && sender.tag != 11 && sender.tag != 15 && sender.tag != 18){
            self.console.text = @"";
        }
        equalPress = 0;
    }
    if (sender.tag == 4 || sender.tag == 5 || sender.tag == 6 || sender.tag == 8 || sender.tag == 9 || sender.tag == 10 || sender.tag == 12 || sender.tag == 13 || sender.tag == 14 || sender.tag == 16){
        [sender setTitleColor: [UIColor colorWithRed:120.0/255.0f  green:120.0/255.0f blue:120.0/255.0f alpha:1.0f] forState: UIControlStateHighlighted];
        if ([self.console.text stringByAppendingString: sender.titleLabel.text].length <= 16) { // limit length to 16 bits
            self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text]; // append text
        }
    } else if (sender.tag == 17){
        if ([[self.console.text componentsSeparatedByString: @"."]count] - 1 == 0){
            if (equalPress != 1){
                self.console.text = [self.console.text stringByAppendingString: sender.titleLabel.text];// add a decimal point
            } else {
                self.console.text = @".0";
            }
        }
    } else if (sender.tag == 1){
      // percent op
        double percentile = [self.console.text doubleValue]/100.0;
        self.console.text = [NSString stringWithFormat: @"%g", percentile];
        
    } else if (sender.tag == 2){
        // negative or positive
        double sign = -[self.console.text doubleValue];
        if (sign == (int) sign){
            self.console.text = [NSString stringWithFormat: @"%d", (int) sign];
        } else {
            self.console.text = [NSString stringWithFormat: @"%g", sign];
        }
    } else {
        opcode = sender.titleLabel.text; // this means it is an operation
        [UIView animateWithDuration: 0.15 animations: ^{
            [self.console setAlpha: 0.0f];
        }completion: ^(BOOL finished){
            [self.console setAlpha: 1.0f];
        }];
    }
    if ([opcode containsString: @"+"] || [opcode containsString: @"-"] || [opcode containsString: @"×"] || [opcode containsString: @"÷"]){
        firstNum = [self.console.text doubleValue];
        opPrev = opcode;
        pressMore = 1; // used to detect if operator has already been pressed
        equalPress = 0; // reset the counter for equals
    } else if ([opcode containsString: @"="]){
        if (equalPress == 0){
                secondNum = [self.console.text doubleValue];
                if ([opPrev containsString: @"+"]){
                    self.console.text = [NSString stringWithFormat: @"%g", firstNum + secondNum];
                } else if ([opPrev containsString: @"-"]){
                    self.console.text = [NSString stringWithFormat: @"%g", firstNum - secondNum];
                } else if ([opPrev containsString: @"×"]){
                    self.console.text = [NSString stringWithFormat: @"%g", firstNum * secondNum];
                } else if ([opPrev containsString: @"÷"]) {
                    if (secondNum != 0){
                        self.console.text = [NSString stringWithFormat: @"%g", firstNum / secondNum];
                    } else {
                        self.console.text = @"NaN";
                    }
                }
        }
        equalPress = 1;
    }
    if (sender.tag == 0){
        // clear
        self.console.text = @"";
        opcode = nil;
        opPrev = nil;
        firstNum = 0;
        secondNum = 0;
        equalPress = 0;
        pressMore = 0;
    }
    sender.alpha = 0.8;
}

- (void) removeTap:(UIButton *)sender {
    sender.alpha = 1;
}

- (void) changeColorLeft:(UISwipeGestureRecognizer *)swipe {
    if (colorCount > 10){
        colorCount = 0;
    }
    [UIImageView animateWithDuration: 0.5 animations: ^{
    [self.consoleColor setBackgroundColor: [self.colorArray objectAtIndex: colorCount]];
    self.navigationController.navigationBar.barTintColor = self.consoleColor.backgroundColor;
        }];
    for(UIButton *buttons in self.buttonArray){
        if (buttons.tag == 0 || buttons.tag == 1 || buttons.tag == 2 || buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 18){
            [UIButton animateWithDuration: 0.5 animations: ^{
                buttons.backgroundColor = [self.colorArray objectAtIndex: colorCount + 1];
            }];
        }
    }
    colorCount += 2;
}

- (void) changeColorRight:(UISwipeGestureRecognizer *)swipe {
    if (colorCount - 2 < 0){
        colorCount = 12;
    }
    colorCount--;
    for(UIButton *buttons in self.buttonArray){
        if (buttons.tag == 0 || buttons.tag == 1 || buttons.tag == 2 || buttons.tag == 3 || buttons.tag == 7 || buttons.tag == 11 || buttons.tag == 15 || buttons.tag == 18){
            [UIButton animateWithDuration: 0.5 animations: ^{
                buttons.backgroundColor = [self.colorArray objectAtIndex: colorCount];
            }];
        }
    }
    colorCount--;
    [UIImageView animateWithDuration: 0.5 animations: ^{
        [self.consoleColor setBackgroundColor: [self.colorArray objectAtIndex: colorCount]];
        self.navigationController.navigationBar.barTintColor = self.consoleColor.backgroundColor;
    }];
}

- (void) convert {
    MainViewController *main = [self.navigationController.viewControllers objectAtIndex: 0];
    NextCurrViewController *next = [self.navigationController.viewControllers objectAtIndex: 1];
    ResultsViewController *results = [[ResultsViewController alloc] init];
    results.delegate = self;
    results.dictMain = main.currInfo;
    results.dictNext = next.methods.currInfo;
    results.amount = self.console.text.doubleValue;
    UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:results];
    [self.navigationController presentViewController: navController animated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addItemViewController:(ResultsViewController *)controller didFinishEnteringItem:(BOOL)decision {
    self.goToRoot = decision;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = self.consoleColor.backgroundColor;
    if (self.goToRoot){
        [self.navigationController popToRootViewControllerAnimated: YES];
    }
}

- (void) viewWillDisappear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = darkGreen;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
