//
//  MainViewController.m
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/8/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "MainViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MainViewController ()

@end

@implementation MainViewController

@synthesize imgArr, cityView, nextCityView, cityCount, nextCityCount, endFrame, currArr;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [[UINavigationBar appearance] setBarTintColor:[UIColor colorWithRed: 38/255.0 green: 237/255.0 blue: 161/255.0f alpha: 1.0f]];
    imgArr = [self populateArr: imgArr : @"jpg" : @"city"];
    currArr = [self populateArr: currArr : @"png" : @"currency"];

    cityCount = 0;
    nextCityCount = 1;
    
    //city image
    self.cityView = [self getView: imgArr : CGRectMake(0, self.navigationBar.frame.size.height, self.view.frame.size.width, (self.view.frame.size.height - self.navigationBar.frame.size.height) / 3) :cityCount];
    // next city
    self.nextCityView = [self getView: imgArr : CGRectMake(-self.view.frame.size.width, cityView.frame.origin.y, cityView.frame.size.width, cityView.frame.size.height) : nextCityCount];
    
    // circle
    float cirSize = self.view.frame.size.height / 6.25;
    UIImageView *circ = [[UIImageView alloc] initWithFrame: CGRectMake(self.cityView.frame.size.width/2 - (cirSize / 2), (self.cityView.frame.size.height + self.navigationBar.frame.size.height) - (cirSize / 2), cirSize, cirSize)];
    circ.backgroundColor = [UIColor colorWithRed: 245/255.0f green:245/255.0f blue:245/255.0f alpha: 1.0f];
    circ.layer.borderWidth = 3;
    circ.layer.borderColor = [UIColor blackColor].CGColor;
    
    //search button
    UIImage *world = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"flag" ofType:@"png" inDirectory: @"images"]];
    UIImageView *worldView = [[UIImageView alloc] initWithImage: world];
    worldView.frame = CGRectMake(self.cityView.frame.size.width/2 - (cirSize * 0.95/ 2), (self.cityView.frame.size.height + self.navigationBar.frame.size.height) - (cirSize *0.95 / 2), cirSize * 0.95, cirSize * 0.95);
    
    // background gradient
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationBar.frame.size.height + self.cityView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationBar.frame.size.height - self.cityView.frame.size.height)];
    background.backgroundColor = [UIColor colorWithRed: 38/255.0 green: 237/255.0 blue: 161/255.0f alpha: 1.0f];
    
    // Blur effects
    UIImageView *leftBlur = [[UIImageView alloc] initWithFrame: CGRectMake(0, self.navigationBar.frame.size.height, (cityView.frame.size.width/2 - 0.5 * circ.bounds.size.width)/2, cityView.frame.size.height)];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = leftBlur.bounds;
    [leftBlur addSubview:visualEffectView];
    UIImageView *rightBlur = [[UIImageView alloc] initWithFrame: CGRectMake(cityView.frame.size.width/2 + 0.5 * circ.frame.size.width + leftBlur.frame.size.width, self.navigationBar.frame.size.height, (cityView.frame.size.width/2 - 0.5 * circ.bounds.size.width)/2 + 1, cityView.frame.size.height)];
    UIVisualEffectView *visualEffectView2 = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView2.frame = rightBlur.bounds;
    [rightBlur addSubview:visualEffectView2];
    
    // search button
    UIImageView *searchCirc = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - circ.frame.size.width/2, self.view.frame.size.height * 0.65, circ.frame.size.width, circ.frame.size.height)];
    searchCirc.backgroundColor = circ.backgroundColor;
    UIImageView *searchButton = [[UIImageView alloc] initWithImage: [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"search" ofType: @"png" inDirectory: @"images"]]];
    searchButton.frame = CGRectMake(searchCirc.frame.origin.x, searchCirc.frame.origin.y, cirSize * 0.8, cirSize * 0.8);
 //   searchButton.backgroundColor = [UIColor yellowColor];
    // Tell user to search for currency with label
    UILabel *choose = [[UILabel alloc] initWithFrame: CGRectMake(-self.view.frame.size.width,  self.view.frame.size.height / 2, self.view.frame.size.width,  self.view.frame.size.height/8)];
    choose.backgroundColor = [UIColor colorWithRed: 53/255.0 green: 212/255.0 blue: 151/255.0 alpha: 1.0f];
    [UILabel animateWithDuration: 1.25 delay: 0.5 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        choose.frame = CGRectMake(0, choose.frame.origin.y, choose.frame.size.width,  choose.frame.size.height);
    }completion: nil];
    choose.textAlignment = NSTextAlignmentLeft;
    choose.layer.masksToBounds = NO;
    choose.layer.shadowOffset = CGSizeMake(0, 1);
    choose.layer.shadowRadius = 1;
    choose.layer.shadowOpacity = 0.4;
    choose.font = [UIFont fontWithName: @"Raleway-ExtraLight" size: 30.0f];
    choose.textAlignment = NSTextAlignmentCenter;
    choose.text = @"Select base currency";
    
    [self.view addSubview: background];
    [self.view addSubview: choose];
    [self.view addSubview: searchCirc];
    [self.view addSubview: searchButton];
    [self.view addSubview: self.cityView];
    [self.view addSubview: nextCityView];
    [self.view addSubview: leftBlur];
    [self.view addSubview: rightBlur];
    [self.view addSubview: circ];
    [self.view addSubview: worldView];
    [self setRoundedView: circ toDiameter: cirSize];
    [self setRoundedView: searchCirc toDiameter: cirSize];
    
    // pop-up animation
    circ.transform = CGAffineTransformMakeScale(0.01, 0.01);
    worldView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration: 0.4 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        // animate it to the identity transform (100% scale)
        worldView.transform = CGAffineTransformIdentity;
        circ.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished){
    }];

    self.endFrame = CGRectMake(self.view.frame.size.width,cityView.frame.origin.y, cityView.frame.size.width, cityView.frame.size.height);
    // this is where the magic happens!
    NSTimer *t = [[NSTimer alloc] initWithFireDate: [NSDate dateWithTimeIntervalSinceNow: 2]
                                          interval: 15
                                            target: self
                                          selector: @selector(animateCity:)
                                          userInfo:nil repeats:YES];
    
    NSRunLoop *runner = [NSRunLoop currentRunLoop];
    [runner addTimer:t forMode: NSDefaultRunLoopMode];
    // Do any additional setup after loading the view.
}

- (UIImageView *) getView: (NSMutableArray *) arr : (CGRect)frame :(int)imgNum {
    UIImageView *someView = [[UIImageView alloc] initWithImage: [arr objectAtIndex: imgNum]];
    someView.frame = frame;
    if ([arr objectAtIndex: imgNum] != [currArr objectAtIndex: imgNum]){
        someView.layer.masksToBounds = NO;
        someView.layer.shadowOffset = CGSizeMake(0, 3);
        someView.layer.shadowRadius = 2;
        someView.layer.shadowOpacity = 0.4;
    }
    return someView;
}

- (NSMutableArray *) populateArr:(NSMutableArray *)arr :(NSString *)ext :(NSString *)dir {
    NSArray *imagePaths = [[NSBundle mainBundle] pathsForResourcesOfType: ext inDirectory: dir];
    arr = [[NSMutableArray alloc] initWithCapacity: imagePaths.count];
    for (NSString *path in imagePaths) {
        [arr addObject: [UIImage imageWithContentsOfFile: path]];
    }
    return arr;
}

- (void) animateCity:(NSTimer *)timer {
    [UIView animateWithDuration: 2 delay: 10 options: UIViewAnimationOptionCurveEaseOut animations: ^{
        self.nextCityView.frame = self.cityView.frame;
        self.cityView.frame = endFrame;
    }completion:^(BOOL finished) {
        cityCount++;
        nextCityCount++;
        if (cityCount == imgArr.count) {
            cityCount = 0;
        }
        
        if (nextCityCount == imgArr.count) {
            nextCityCount = 0;
        }
        self.nextCityView.frame = CGRectMake(-self.view.frame.size.width, self.cityView.frame.origin.y, self.cityView.frame.size.width, self.cityView.frame.size.height);
        self.cityView.frame = CGRectMake(0, self.cityView.frame.origin.y, self.cityView.frame.size.width, self.cityView.frame.size.height);
        self.cityView = [self.cityView initWithImage: [imgArr objectAtIndex: cityCount]];
        self.nextCityView = [self.nextCityView initWithImage: [imgArr objectAtIndex: nextCityCount]];
    }];
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
