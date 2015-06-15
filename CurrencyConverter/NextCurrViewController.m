//
//  NextCurrViewController.m
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/11/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "NextCurrViewController.h"

#define circGray [UIColor colorWithRed:227/255.0 green:227/255.0 blue:227/255.0 alpha:1.0]
#define lightGreen [UIColor colorWithRed: 80/255.0 green: 200/255.0 blue: 120/255.0 alpha: 1.0f]
#define cirSize self.view.frame.size.height / 6.25

@interface NextCurrViewController ()

@end

@implementation NextCurrViewController

@synthesize methods;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = lightGreen;
    self.title = @"Conversion"; // set the title of the viewcontroller to the label
    self.methods = [[MainViewController alloc] init];
    self.methods.imgArr = [self.methods populateArr: self.methods.imgArr : @"png" : @"images"];
    
    // Get the circles!
    UIImageView *circ = [[UIImageView alloc] initWithFrame: CGRectMake(self.view.frame.size.width / 2 - (cirSize / 2),  self.view.frame.size.height * 0.2, cirSize, cirSize)];
    circ.backgroundColor = circGray;
    UIImageView *worldIcon = [[UIImageView alloc] initWithImage: [self.methods.imgArr objectAtIndex: 1]];
    worldIcon.frame = CGRectMake(self.view.frame.size.width/2 - (cirSize * 0.95/ 2), circ.frame.origin.y + (cirSize/2 - cirSize * 0.475), cirSize * 0.95, cirSize * 0.95);
    circ.layer.borderWidth = 3;
    circ.layer.borderColor = [UIColor blackColor].CGColor;
    
    UIImageView *searchCirc = [[UIImageView alloc] initWithFrame: CGRectMake(circ.frame.origin.x + (circ.bounds.size.width/2 - (cirSize * 0.7 / 2)), self.view.frame.size.height * 0.65, cirSize * 0.7, cirSize * 0.7)];
    searchCirc.backgroundColor = circGray;
    UIImageView *searchIcon = [[UIImageView alloc] initWithImage: [self.methods.imgArr objectAtIndex: 2]];
    searchIcon.frame = searchCirc.frame;
    searchIcon.tag = 1;
    UIButton *searching = [[UIButton alloc] initWithFrame: searchCirc.frame];
    [searching addTarget: self action: @selector(openSearch) forControlEvents: UIControlEventTouchUpInside];
    
    // Labels to tell user
    UILabel *nextCurr = [self.methods createAnimLabel: CGRectMake(self.view.frame.size.width * 2, self.view.frame.size.height * 0.45, self.view.frame.size.width, (self.view.frame.size.height - self.navigationController.navigationBar.frame.size.height) / 8 ) withDisplay: @"Select conversion currency"];
    self.methods.goBar = [[UIImageView alloc] initWithFrame: CGRectMake(0, self.view.frame.size.height - nextCurr.frame.size.height, self.view.frame.size.width, nextCurr.frame.size.height)];
    self.methods.goBar.backgroundColor = nextCurr.backgroundColor;
    self.methods.goBar .layer.shadowOffset = CGSizeMake(1, 0);
    self.methods.goBar .layer.shadowRadius = 2;
    self.methods.goBar .layer.shadowOpacity = 0.4;
    self.methods.go = [[UIImageView alloc] initWithImage: [self.methods.imgArr objectAtIndex: 0]];
    self.methods.go.frame = CGRectMake(self.view.frame.size.width/2 - nextCurr.bounds.size.width / 16,  self.methods.goBar.frame.origin.y + (nextCurr.bounds.size.height/2 - nextCurr.bounds.size.height * 0.35), nextCurr.bounds.size.width / 8, nextCurr.bounds.size.height * 0.7);
    
    UIButton *goButton = [[UIButton alloc] initWithFrame: self.methods.goBar.frame];
    [goButton addTarget: self action: @selector(nextCurr) forControlEvents: UIControlEventTouchDown];
    [goButton addTarget: self action: @selector(removeTap) forControlEvents: UIControlEventTouchUpInside];
    
    // blur
    UIImageView *img = [[UIImageView alloc] initWithFrame: CGRectMake(0,self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height, self.view.frame.size.width, nextCurr.frame.origin.y - [UIApplication sharedApplication].statusBarFrame.size.height - self.navigationController.navigationBar.bounds.size.height)];
    [self.view addSubview: img];
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
    visualEffectView.frame = img.bounds;
  //  [img addSubview:visualEffectView];
    
    [self.methods setRoundedView: circ toDiameter: cirSize];
    [self.methods setRoundedView: searchCirc toDiameter: cirSize];
    [self.view addSubview: circ];
    [self.view addSubview: worldIcon];
    [self.view addSubview: nextCurr];
    [self.view addSubview: searchCirc];
    [self.view addSubview: searchIcon];
    [self.view addSubview: searching];
    [self.view addSubview: self.methods.goBar];
    [self.view addSubview: self.methods.go];
    [self.view addSubview: goButton];
    
    [self.methods animateButton: circ : worldIcon withDuration: 0.4f andDelay: 0];
    searchCirc.transform = CGAffineTransformMakeScale(0.01, 0.01);
    searchIcon.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UILabel animateWithDuration: 1 delay: 0 options: 0 animations: ^{
        nextCurr.frame = CGRectMake(0, nextCurr.frame.origin.y, nextCurr.frame.size.width,  nextCurr.frame.size.height);
    }completion:  ^(BOOL finished){
        [self.methods animateButton: searchIcon : searchCirc withDuration: 0.3f andDelay: 0];
    }];
}

- (void) openSearch {
    NSArray *subviews = [self.view subviews];
    for (UIView *subview in subviews) {
        if (subview.tag == 1){
            [UIView animateWithDuration: 0.75 delay:0 options:UIViewAnimationOptionTransitionNone animations:^{
                subview.layer.transform = CATransform3DMakeRotation(M_PI,0.0,0.0,1.0);
                subview.layer.transform = CATransform3DConcat(subview.layer.transform, CATransform3DMakeRotation(M_PI,0.0,0.0,1.0));
            } completion: ^(BOOL finished){
                UIViewController *lol = [[UIViewController alloc] init];
                lol.view.backgroundColor = [UIColor whiteColor];
                [self.navigationController presentViewController: lol animated: YES completion: nil];
            }];
        }
    }
}

- (void) nextCurr {
    self.methods.goBar.alpha = 0.6;
    self.methods.go.alpha = 0.4;
}

- (void) removeTap {
    self.methods.goBar.alpha = 1.0;
    self.methods.go.alpha = 1.0;
    UIViewController *calc = [[UIViewController alloc] init];
    [self.navigationController pushViewController: calc animated: YES];
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
