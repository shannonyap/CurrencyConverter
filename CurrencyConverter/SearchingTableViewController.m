//
//  SearchingTableViewController.m
//  CurrencyConverter
//
//  Created by Shannon Yap on 6/12/15.
//  Copyright (c) 2015 SYXH. All rights reserved.
//

#import "SearchingTableViewController.h"

#define darkGreen [UIColor colorWithRed: 39/255.0 green: 174/255.0 blue: 96/255.0 alpha: 1.0f]
#define lightGreen [UIColor colorWithRed: 80/255.0 green: 200/255.0 blue: 120/255.0 alpha: 1.0f]

@interface SearchingTableViewController ()  <UISearchBarDelegate>

@end

@implementation SearchingTableViewController

@synthesize doneButton, currency;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    self.title = @"Choose Currency";
    self.navigationController.navigationBar.barTintColor = darkGreen;
    self.doneButton = [[UIBarButtonItem alloc] initWithTitle: @"Done" style: UIBarButtonItemStyleDone target: self action: @selector(done)];
    self.navigationItem.leftBarButtonItem = self.doneButton;
    
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame: CGRectMake(0, 0, self.view.frame.size.width, 44)];
    searchBar.delegate = self;
    searchBar.barTintColor = darkGreen;
    searchBar.placeholder = @"Search for country name";
    self.tableView.tableHeaderView = searchBar;
    self.currency = [self parseJSON];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) done {
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (NSMutableArray *) parseJSON {
    NSData *theData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: @"http://country.io/currency.json"]]
                                            returningResponse:nil
                                                        error:nil];
    NSError *e = nil;
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData: theData options: NSJSONReadingMutableContainers error: &e];
    NSArray *l = [dict allValues];
    
    theData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: @"http://country.io/names.json"]]
                                    returningResponse:nil
                                                error:nil];
    dict =[NSJSONSerialization JSONObjectWithData: theData options: NSJSONReadingMutableContainers error: &e];
    NSArray *b = [dict allValues];
    
    theData = [NSURLConnection sendSynchronousRequest:[NSURLRequest requestWithURL: [NSURL URLWithString: @"http://www.localeplanet.com/api/auto/currencymap.json?name=Y"]]
                                    returningResponse:nil
                                                error:nil];
    dict = [NSJSONSerialization JSONObjectWithData: theData options: NSJSONReadingMutableContainers error: &e];
    NSMutableArray *sad = [[NSMutableArray alloc] init];
    for (int i = 0; i < l.count; i++) {
        NSDictionary *ha = [dict objectForKey: [l objectAtIndex: i]];
        if ([ha objectForKey: @"name"] != NULL) {
            NSDictionary *ob = [[NSDictionary alloc] initWithObjectsAndKeys: [b objectAtIndex: i], @"name", [l objectAtIndex: i], @"currCode", [ha objectForKey: @"name"], @"currency", nil];
            [sad addObject: ob];
        }
    }
    NSArray *lolz = [[NSArray alloc] initWithArray: sad];
    NSSortDescriptor *descriptor = [[NSSortDescriptor alloc] initWithKey:@"name"  ascending:YES];
    lolz= [lolz sortedArrayUsingDescriptors:[NSArray arrayWithObjects:descriptor,nil]];
    sad = [lolz copy];
    return sad;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return self.currency.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Return the number of rows in the section.
    return 1;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"countryCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"countryCell"];
 
    if (cell == nil) {
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    //etc.
    NSDictionary *dict = [self.currency objectAtIndex: indexPath.section];
    cell.textLabel.text = [dict objectForKey: @"name"];
    NSLog(@"%@", dict);
    cell.imageView.image = [[UIImage alloc] initWithContentsOfFile: [[NSBundle mainBundle] pathForResource: [[dict objectForKey: @"name"] stringByReplacingOccurrencesOfString: @"-" withString: @" "] ofType:@"png" inDirectory: @"roundIcons"]];
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
