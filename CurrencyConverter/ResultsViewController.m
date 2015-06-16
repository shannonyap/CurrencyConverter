//
//  ResultsViewController.m
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/15/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "ResultsViewController.h"
#import <QuartzCore/QuartzCore.h>

#define darkGreen [UIColor colorWithRed: 39/255.0 green: 174/255.0 blue: 96/255.0 alpha: 1.0f]
#define lightGreen [UIColor colorWithRed: 80/255.0 green: 200/255.0 blue: 120/255.0 alpha: 1.0f]
#define cirSize self.view.frame.size.height * 0.1

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize dictMain, dictNext, exchangeRate, amount, delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Results";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:63/255.0f green:195/255.0f blue:128/255.0f alpha: 1.0f];
    self.view.backgroundColor = lightGreen;
    [self parseCurrRateJSONWith: self.dictMain and: self.dictNext];
    UILabel *rate = [self createLabelWithFrame: CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) * 0.15) withText: [@"Exchange Rate:         " stringByAppendingString: [NSString stringWithFormat: @"%g", exchangeRate.doubleValue]]];
   // rate.font = [rate.font fontWithSize: 25.0f];
    rate.font = [UIFont fontWithName: @"Gotham Narrow" size: 25.0f];
    rate.textAlignment = NSTextAlignmentLeft;
    rate.backgroundColor = self.view.backgroundColor;
    
    UILabel *baseLabel = [self createLabelWithFrame: CGRectMake(0, rate.frame.origin.y + rate.frame.size.height + self.view.frame.size.height, rate.frame.size.width,  (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) * 0.35) withText: [[NSString stringWithFormat: @"%g", self.amount] stringByAppendingString: [@"    " stringByAppendingString: [self.dictMain valueForKey: @"currCode"]]]];
    baseLabel.backgroundColor = [UIColor colorWithRed:63/255.0f green:195/255.0f blue:128/255.0f alpha: 1.0f];
    baseLabel.textAlignment = NSTextAlignmentCenter;
    baseLabel.font = [UIFont fontWithName: @"Gotham Narrow" size: 35.0f];
    
    UILabel *convLabel = [self createLabelWithFrame: CGRectMake(0, baseLabel.frame.origin.y + baseLabel.frame.size.height + self.view.frame.size.height, baseLabel.frame.size.width, baseLabel.bounds.size.height) withText: [[NSString stringWithFormat: @"%g", self.amount * exchangeRate. doubleValue] stringByAppendingString:[@"    " stringByAppendingString: [self.dictNext valueForKey: @"currCode"]]]];
    convLabel.backgroundColor = baseLabel.backgroundColor;
    convLabel.textAlignment = NSTextAlignmentCenter;
    convLabel.font = baseLabel.font;
    
    UILabel *baseField = [self createLabelWithFrame:CGRectMake(baseLabel.frame.origin.x, baseLabel.frame.origin.y, baseLabel.frame.size.width, baseLabel.frame.size.height * 0.2) withText:[dictMain valueForKey: @"currency"]];
    baseField.font = [UIFont fontWithName: @"Gotham Narrow" size: 30.0f];
    baseField.textAlignment = NSTextAlignmentLeft;
    UILabel *convField = [self createLabelWithFrame:CGRectMake(baseLabel.frame.origin.x, convLabel.frame.origin.y, convLabel.frame.size.width, convLabel.frame.size.height * 0.2) withText:[dictNext valueForKey: @"currency"]];
    convField.font = [UIFont fontWithName: @"Gotham Narrow" size: 30.0f];
    convField.textAlignment = NSTextAlignmentLeft;
    
    UIImageView *equalsCirc = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - (cirSize/2), convLabel.frame.origin.y - 2 * self.view.frame.size.height - (cirSize/2) , cirSize, cirSize)];
    equalsCirc.backgroundColor = rate.backgroundColor;
    [self setRoundedView: equalsCirc toDiameter: cirSize];
    
    UIImageView *equals = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - ((cirSize * 0.6)/2), convLabel.frame.origin.y - 2 * self.view.frame.size.height - ((cirSize * 0.5)/2) , cirSize * 0.6, cirSize * 0.6)];
    equals.image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"signEquals" ofType: @"png" inDirectory: @"images"]];
    equals.transform = CGAffineTransformMakeScale(0.01, 0.01);
    equalsCirc.transform = CGAffineTransformMakeScale(0.01, 0.01);
    
    UIButton *back = [self createButtonWithFrame:CGRectMake(convLabel.frame.origin.x, convLabel.frame.origin.y, rate.frame.size.width / 2, rate.frame.size.height) withTag: 0];
    UIButton *new = [self createButtonWithFrame:CGRectMake(self.view.frame.size.width/ 2, back.frame.origin.y, back.frame.size.width, back.frame.size.height) withTag: 1];
    UIImageView *backIcon = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"back" ofType: @"png" inDirectory: @"widget"]]];
    backIcon.frame = CGRectMake(back.center.x - back.frame.size.width / 8, back.center.y - back.frame.size.width / 8, back.frame.size.width / 4, back.frame.size.width / 4);
    UIImageView *newIcon = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"new" ofType: @"png" inDirectory: @"widget"]]];
    newIcon.frame = CGRectMake(self.view.frame.size.width * 0.75 - back.frame.size.width / 8, back.center.y - back.frame.size.width / 8, back.frame.size.width / 4, back.frame.size.width / 4);
    
    [self.view addSubview: rate];
    [self.view addSubview: baseLabel];
    [self.view addSubview: convLabel];
    [self.view addSubview: equalsCirc];
    [self.view addSubview: equals];
    [self.view addSubview: baseField];
    [self.view addSubview: convField];
    [self.view addSubview: back];
    [self.view addSubview: new];
    [self.view addSubview: backIcon];
    [self.view addSubview: newIcon];
    
    [UILabel animateWithDuration: 1.0f delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        baseLabel.frame = CGRectMake(0, rate.frame.origin.y + rate.frame.size.height, rate.frame.size.width,  (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) * 0.35);
        baseField.frame = CGRectMake(baseLabel.frame.origin.x, baseLabel.frame.origin.y * 1.1, baseLabel.frame.size.width, baseLabel.frame.size.height * 0.2);
        [UILabel animateWithDuration: 1.0f delay: 0.75f options: UIViewAnimationOptionCurveEaseOut animations: ^{
            convLabel.frame = CGRectMake(0, baseLabel.frame.origin.y + baseLabel.frame.size.height, baseLabel.frame.size.width, baseLabel.bounds.size.height);
            convField.frame = CGRectMake(convLabel.frame.origin.x, convLabel.frame.origin.y * 1.1, convLabel.frame.size.width, convLabel.frame.size.height * 0.2);
        }completion: ^(BOOL finished){
            [UIImageView animateWithDuration: 0.5f delay: 0 options: UIViewAnimationOptionCurveEaseOut animations: ^{
                equalsCirc.transform = CGAffineTransformIdentity;
                equals.transform = CGAffineTransformIdentity;
            }completion: nil];
            [UIButton animateWithDuration: 0.65 delay: 0  options:UIViewAnimationOptionCurveEaseOut animations: ^{
                back.frame = CGRectMake(convLabel.frame.origin.x, convLabel.frame.origin.y + convLabel.frame.size.height, rate.frame.size.width / 2, rate.frame.size.height);
                new.frame = CGRectMake(new.frame.size.width, back.frame.origin.y, back.frame.size.width, back.frame.size.height);
                backIcon.frame = CGRectMake(back.center.x - backIcon.frame.size.width * 0.5, back.center.y - backIcon.frame.size.height * 0.5, backIcon.frame.size.width, backIcon.frame.size.height);
                newIcon.frame = CGRectMake(self.view.frame.size.width * 0.75 - backIcon.frame.size.width * 0.5, back.center.y - backIcon.frame.size.height * 0.5, backIcon.frame.size.width, backIcon.frame.size.height);
            }completion: nil];
        }];
    }completion: nil];
}

- (void) parseCurrRateJSONWith:(NSDictionary *)mainDict and:(NSDictionary *)nextDict {
    NSData *theData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: [@"https://query.yahooapis.com/v1/public/yql?q=select%20*%20from%20csv%20where%20url%3D%22http%3A%2F%2Ffinance.yahoo.com%2Fd%2Fquotes.csv%3Fe%3D.csv%26f%3Dc4l1%26s%3D" stringByAppendingString: [[mainDict valueForKey: @"currCode"] stringByAppendingString: [[nextDict valueForKey: @"currCode"] stringByAppendingString: @"%3DX%22&format=json&diagnostics=true&callback="]]]]]
                                            returningResponse:nil
                                                        error:nil];
    NSError *e = nil;
    NSDictionary *exchangeInfo = [NSJSONSerialization JSONObjectWithData: theData options: NSJSONReadingMutableContainers error: &e];
    self.exchangeRate = [[[[exchangeInfo valueForKey: @"query"] valueForKey: @"results"] valueForKey: @"row"] valueForKey: @"col1"];
}

- (UILabel *) createLabelWithFrame:(CGRect)frame withText:(NSString *)text {
    UILabel *someLabel = [[UILabel alloc] initWithFrame: frame];
    someLabel.text = text;
    someLabel.layer.shadowOpacity = 0.4;
    someLabel.layer.shadowRadius = 2.0;
    someLabel.layer.shadowColor = [UIColor blackColor].CGColor;
    someLabel.layer.shadowOffset = CGSizeMake(1.0, 0.0);
    return someLabel;
}

- (UIButton *) createButtonWithFrame: (CGRect)frame withTag: (int)tag {
    UIButton *someButton = [[UIButton alloc] initWithFrame: frame];
    someButton.tag = tag;
    someButton.layer.shadowOpacity = 0.4;
    someButton.layer.shadowRadius = 2.0;
    someButton.layer.shadowColor = [UIColor blackColor].CGColor;
    someButton.layer.shadowOffset = CGSizeMake(1.0, 0.0);
    someButton.backgroundColor = self.view.backgroundColor;
    [someButton addTarget:self action:@selector(tap:) forControlEvents:UIControlEventTouchDown];
    return someButton;
}

- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize {
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (void) tap: (UIButton *)sender {
    if (sender.tag == 1) {
        [self.delegate addItemViewController:self didFinishEnteringItem: true];
    }
    [self.presentingViewController dismissViewControllerAnimated: YES completion: nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
