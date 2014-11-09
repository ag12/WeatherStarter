//
//  WTTableViewController.m
//  Weather
//
//  Created by Scott on 26/01/2013.
//  Updated by Joshua Greene 16/12/2013.
//
//  Copyright (c) 2013 Scott Sherwood. All rights reserved.
//

#import "WTTableViewController.h"
#import "WeatherAnimationViewController.h"
#import "NSDictionary+weather.h"
#import "NSDictionary+weather_package.h"

#import "WTClient.h"




@interface WTTableViewController ()
@property(strong) NSDictionary *weather;
@end

@implementation WTTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.navigationController.toolbarHidden = NO;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if([segue.identifier isEqualToString:@"WeatherDetailSegue"]){
        UITableViewCell *cell = (UITableViewCell *)sender;
        NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
        
        WeatherAnimationViewController *wac = (WeatherAnimationViewController *)segue.destinationViewController;
        
        NSDictionary *w;
        switch (indexPath.section) {
            case 0: {
                w = self.weather.currentCondition;
                break;
            }
            case 1: {
                w = [self.weather upcomingWeather][indexPath.row];
                break;
            }
            default: {
                break;
            }
        }
        wac.weatherDictionary = w;
    }
}
#pragma mark - Helper method(DRY)

-(void)handleSuccessRespond:(id)responseObject {
    self.weather = (NSDictionary *)responseObject;
    self.title = @"Json Retrieved";
    [self.tableView reloadData];
    NSLog(@"%@", self.weather);
}
-(void)showErrorDialog {
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problems downloading data" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

#pragma mark - Actions

- (IBAction)clear:(id)sender
{
    self.title = @"";
    self.weather = nil;
    [self.tableView reloadData];
}

-(void)requstJSONWithCallBack {

    WTClient *sharedClient = [WTClient sharedClient];
    [sharedClient loadJSONFromServerWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self handleSuccessRespond: responseObject];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorDialog];
    }];

}

- (void)didFinishedLoadinWeatherJSONFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error {

    if (error == nil) {
        //Vi kjor nu
        [self handleSuccessRespond: responseObject];
    } else {
        [self showErrorDialog];
    }
}

-(void)requstJSONWithDelegate {
    WTClient *sharedClient = [WTClient sharedClient];
    sharedClient.delegate = self;
    [sharedClient loadWeatherJSONFromServer];
}

- (IBAction)jsonTapped:(id)sender
{
    //[self requstJSONWithCallBack];
    [self requstJSONWithDelegate];

}

- (IBAction)plistTapped:(id)sender
{
    
}

- (IBAction)xmlTapped:(id)sender
{
    
}

- (IBAction)clientTapped:(id)sender
{
    
}

- (IBAction)apiTapped:(id)sender
{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}

@end