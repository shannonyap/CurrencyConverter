//
//  MainViewController.m
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/8/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "MainViewController.h"
#import "NextCurrViewController.h"
#import "SearchingTableViewController.h"
#import <QuartzCore/QuartzCore.h>

#define circGray [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]
#define darkGreen [UIColor colorWithRed: 39/255.0 green: 174/255.0 blue: 96/255.0 alpha: 1.0f]
#define lightGreen [UIColor colorWithRed: 80/255.0 green: 200/255.0 blue: 120/255.0 alpha: 1.0f]
#define cirSize self.view.frame.size.height / 6.25

@interface MainViewController () <SearchingTableViewControllerDelegate>

@end

@implementation MainViewController

@synthesize imgArr, cityView, nextCityView, cityCount, nextCityCount, endFrame, currArr, go, goBar, choose, worldView, currInfo, goButton;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"Base Currency";
    self.view.backgroundColor = [UIColor blackColor];
    self.navigationController.navigationBar.barTintColor = darkGreen;
    imgArr = [self populateArr: imgArr : @"png" : @"flags"];
    currArr = [self populateArr: currArr : @"png" : @"images"];

    cityCount = arc4random_uniform((int)imgArr.count - 1);
    nextCityCount = cityCount + 1;
    
    //city image
    self.cityView = [self getView: imgArr : CGRectMake(0, self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 3) :cityCount withTag: 1];
    // next city
    self.nextCityView = [self getView: imgArr : CGRectMake(-self.view.frame.size.width, cityView.frame.origin.y, cityView.frame.size.width, cityView.frame.size.height) : nextCityCount withTag: 1];

    // circle
    UIImageView *circ = [[UIImageView alloc] initWithFrame: CGRectMake(self.cityView.frame.size.width/2 - (cirSize / 2), (self.cityView.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height) - (cirSize / 2), cirSize, cirSize)];
    circ.backgroundColor = circGray;
    circ.layer.borderWidth = 3;
    circ.layer.borderColor = [UIColor blackColor].CGColor;
    self.worldView = [self getView: currArr :CGRectMake(self.cityView.frame.size.width/2 - (cirSize * 0.95/ 2), (self.cityView.frame.size.height + self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height) - (cirSize *0.95 / 2), cirSize * 0.95, cirSize * 0.95) : 1 withTag: -1];
    // background gradient
    UIView* background = [[UIView alloc] initWithFrame:CGRectMake(0, self.navigationController.navigationBar.frame.size.height + self.cityView.frame.size.height, self.view.frame.size.width, self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height - self.cityView.frame.size.height)];
    background.backgroundColor = [UIColor colorWithRed: 80/255.0 green: 200/255.0 blue: 120/255.0 alpha: 1.0f];
    
    // search button
    UIImageView *searchCirc = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - circ.frame.size.width/2, self.view.frame.size.height * 0.675, cirSize, cirSize)];
    searchCirc.backgroundColor = circ.backgroundColor;
    UIImageView *searchButton = [self getView: currArr :CGRectMake(searchCirc.frame.origin.x + (searchCirc.bounds.size.width/2 - (cirSize * 0.7 / 2)), searchCirc.frame.origin.y + (searchCirc.bounds.size.height/2 - (cirSize * 0.75 / 2)), cirSize * 0.7, cirSize * 0.7) : 2 withTag: -1];
    searchButton.tag = 1;
    UIButton *searching = [[UIButton alloc] initWithFrame: searchCirc.frame];
    [searching addTarget: self action: @selector(openSearch) forControlEvents: UIControlEventTouchUpInside];
    searching.userInteractionEnabled = NO;
    
    // Tell user to search for currency with label
    self.choose = [self createAnimLabel: CGRectMake(-self.view.frame.size.width,  self.view.frame.size.height * 0.525, self.view.frame.size.width,  (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 8 ) withDisplay: @"Select base currency"];
    
    // Next currency button
    self.goBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - self.choose.frame.size.height, self.view.frame.size.width, self.choose.frame.size.height)];
    self.goBar.backgroundColor = self.choose.backgroundColor;
    self.go = [self getView: currArr : CGRectMake(self.view.frame.size.width/2 - self.choose.bounds.size.width / 16,  goBar.frame.origin.y + (choose.bounds.size.height/2 - self.choose.bounds.size.height * 0.35), self.choose.bounds.size.width / 8, self.choose.bounds.size.height * 0.7) : 0 withTag: -1];
    self.goBar.layer.shadowOffset = CGSizeMake(1, 0);
    self.goBar.layer.shadowRadius = 2;
    self.goBar.layer.shadowOpacity = 0.4;
    self.goButton = [[UIButton alloc] initWithFrame: self.goBar.frame];
    [self.goButton addTarget: self action: @selector(nextCurr) forControlEvents: UIControlEventTouchDown];
    [self.goButton addTarget: self action: @selector(removeTap) forControlEvents: UIControlEventTouchUpInside];
    
    [self.view addSubview: background];
    [self.view addSubview: self.choose];
    [self.view addSubview: searchCirc];
    [self.view addSubview: searchButton];
    [self.view addSubview: self.cityView];
    [self.view addSubview: nextCityView];
    [self.view addSubview: circ];
    [self.view addSubview: self.worldView];
    [self setRoundedView: circ toDiameter: cirSize];
    [self setRoundedView: searchCirc toDiameter: cirSize];
    [self.view addSubview: searching];
    [self.view addSubview: self.goBar];
    [self.view addSubview: self.go];
    [self.view addSubview: self.goButton];
    
    // Animations
    searchCirc.transform = CGAffineTransformMakeScale(0.01, 0.01);
    searchButton.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self animateButton:circ : self.worldView withDuration: 0.3f andDelay: 0];
    [UILabel animateWithDuration: 1 delay: 0.5 options: 0 animations: ^{
        self.choose.frame = CGRectMake(0, self.choose.frame.origin.y, self.choose.frame.size.width,  self.choose.frame.size.height);
    }completion:  ^(BOOL finished){
        [self animateButton: searchButton : searchCirc withDuration: 0.3f andDelay: 0];
        searching.userInteractionEnabled = YES;
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

- (UIImageView *) getView: (NSMutableArray *) arr : (CGRect)frame :(int)imgNum withTag :(int)tag {
    UIImageView *someView = [[UIImageView alloc] initWithImage: [arr objectAtIndex: imgNum]];
    someView.frame = frame;
    if (tag == 1){
        someView.layer.masksToBounds = NO;
        someView.layer.shadowOffset = CGSizeMake(0, 1);
        someView.layer.shadowRadius = 2;
        someView.layer.shadowOpacity = 0.4;
        [someView.layer setBorderColor: [[UIColor blackColor] CGColor]];
        [someView.layer setBorderWidth: 2.0];
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
    [UIView animateWithDuration: 1 delay: 10 options: UIViewAnimationOptionCurveEaseOut animations: ^{
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

- (void) animateButton:(UIImageView *)circle :(UIImageView *)picture withDuration:(float)duration andDelay:(float)delay {
    circle.transform = CGAffineTransformMakeScale(0.01, 0.01);
    picture.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView animateWithDuration: duration delay: delay options:UIViewAnimationOptionCurveEaseOut animations:^{
        circle.transform = CGAffineTransformIdentity;
        picture.transform = CGAffineTransformIdentity;
    } completion: nil];
}
- (void) setRoundedView:(UIImageView *)roundedView toDiameter:(float)newSize {
    CGPoint saveCenter = roundedView.center;
    CGRect newFrame = CGRectMake(roundedView.frame.origin.x, roundedView.frame.origin.y, newSize, newSize);
    roundedView.frame = newFrame;
    roundedView.layer.cornerRadius = newSize / 2.0;
    roundedView.center = saveCenter;
}

- (UILabel *) createAnimLabel:(CGRect)frame withDisplay: (NSString *)text {
    UILabel *someLabel = [[UILabel alloc] initWithFrame: frame];
    someLabel.backgroundColor = darkGreen;
    someLabel.layer.shadowOffset = CGSizeMake(0, 1);
    someLabel.layer.shadowRadius = 1;
    someLabel.layer.shadowOpacity = 0.4;
    someLabel.font = [UIFont fontWithName: @"Raleway-ExtraLight" size: (someLabel.bounds.size.height/3)];
    someLabel.textAlignment = NSTextAlignmentCenter;
    someLabel.text = text;
    return someLabel;
}

- (void) openSearch {
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews) {
        if (subview.tag == 1){
            [UIView animateWithDuration: 0.5 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                subview.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,1.0);
                subview.layer.transform = CATransform3DConcat(subview.layer.transform, CATransform3DMakeRotation(M_PI,0.0,0.0,1.0));
            } completion: ^(BOOL finished){
                SearchingTableViewController *searchCountry = [[SearchingTableViewController alloc] initWithNibName: nil bundle: nil];
                searchCountry.delegate = self;
                UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:searchCountry];
                [self.navigationController presentViewController: navController animated: YES completion: nil];
            }];
        }
    }
}

- (void) nextCurr {
    self.goBar.alpha = 0.6;
    self.go.alpha = 0.4;
}

- (void) removeTap {
    self.goBar.alpha = 1.0;
    self.go.alpha = 1.0;
    if (self.currInfo != NULL){
        NextCurrViewController *nextCurr = [[NextCurrViewController alloc] init];
        [self.navigationController pushViewController: nextCurr animated: YES];
    }
}

- (void) updateCurrFor:(SearchingTableViewController *)controller With:(NSDictionary *)updates {
    self.choose.text = [[updates valueForKey: @"name"] stringByAppendingString:  [@" - " stringByAppendingString: [updates valueForKey: @"currency"]]];
    self.worldView.image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [updates valueForKey: @"name"] ofType: @"png" inDirectory: @"roundIcons"]];
    self.currInfo = updates;
}

- (void) viewWillAppear:(BOOL)animated {
    self.navigationController.navigationBar.barTintColor = lightGreen;
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
