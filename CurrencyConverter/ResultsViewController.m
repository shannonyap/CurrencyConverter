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
#define cirSize self.view.frame.size.height * 0.15

@interface ResultsViewController ()

@end

@implementation ResultsViewController

@synthesize dictMain, dictNext, exchangeRate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"Results";
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:42/255.0f green:62/255.0f blue:80/255.0f alpha: 1.0f];
    self.view.backgroundColor = lightGreen;
    [self parseCurrRateJSONWith: self.dictMain and: self.dictNext];
    UILabel *rate = [self createLabelWithFrame: CGRectMake(0, [UIApplication sharedApplication].statusBarFrame.size.height + self.navigationController.navigationBar.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.frame.size.height) * 0.15) withText: @"Exchange Rate: "];
    rate.backgroundColor = [UIColor colorWithRed: 108/255.0f green:122/255.0f blue:137/255.0f alpha: 1.0f];
    
    UILabel *baseLabel = [self createLabelWithFrame: CGRectMake(0, rate.frame.origin.y + rate.frame.size.height, rate.frame.size.width,  (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - [UIApplication sharedApplication].statusBarFrame.size.height) * 0.35) withText: [self.dictMain valueForKey: @"currCode"]];
    baseLabel.backgroundColor = [UIColor colorWithRed:58/255.0f green:83/255.0f blue:155/255.0f alpha: 1.0f];
    
    UILabel *convLabel = [self createLabelWithFrame: CGRectMake(0, baseLabel.frame.origin.y + baseLabel.frame.size.height, baseLabel.frame.size.width, baseLabel.bounds.size.height) withText: [self.dictNext valueForKey: @"currCode"]];
    convLabel.backgroundColor = [UIColor colorWithRed:75/255.0f green:119/255.0f blue:190/255.0f alpha: 1.0f];
    
    UIImageView *equalsCirc = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - (cirSize/2), convLabel.frame.origin.y - (cirSize/2) , cirSize, cirSize)];
    equalsCirc.backgroundColor = rate.backgroundColor;
    [self setRoundedView: equalsCirc toDiameter: cirSize];
    equalsCirc.layer.borderWidth = 2.0f;
    equalsCirc.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIImageView *equals = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - ((cirSize * 0.8)/2), convLabel.frame.origin.y - ((cirSize * 0.70)/2) , cirSize * 0.8, cirSize * 0.8)];
    equals.image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"signEquals" ofType: @"png" inDirectory: @"images"]];
    
    [self.view addSubview: rate];
    [self.view addSubview: baseLabel];
    [self.view addSubview: convLabel];
    [self.view addSubview: equalsCirc];
    [self.view addSubview: equals];
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

- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize {
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
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
