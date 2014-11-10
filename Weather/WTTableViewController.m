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
#import <AFNetworking/UIImageView+AFNetworking.h>



@interface WTTableViewController ()
@property(strong) NSDictionary *weather;
@property(nonatomic, strong) NSMutableDictionary *currentDictionary;
@property(nonatomic, strong) NSMutableDictionary *xmlWeather;
@property(nonatomic, strong) NSString *elementName;
@property(nonatomic, strong) NSMutableString *outstring;
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
    [self requstJSONWithCallBack];
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

//Plist and Json objects can be handled in same way
-(void)handleJSONOrPLISTSuccessRespond:(id)responseObject type:(int)type{
    self.weather = (NSDictionary *)responseObject;
    switch (type) {
        case 1: {
            self.title = @"Json Retrieved";
            break;
        }
        case 2: {
            self.title = @"Plist Retrieved";
            break;
        }
        default:
            break;
    }
    [self.tableView reloadData];
    NSLog(@"%@", self.weather);
}

-(void)handleXMLSuccessRespond:(id)responseObject {

    NSXMLParser *XMLParser = (NSXMLParser *)responseObject;
    [XMLParser setShouldProcessNamespaces:YES];

    XMLParser.delegate = self;
    [XMLParser parse];
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
        //Nu kjor vi
        [self handleJSONOrPLISTSuccessRespond: responseObject type:1];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [self showErrorDialog];
    }];

}
#pragma mark - WTClientDelegate

- (void)didFinishedLoadinWeatherJSONFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error {

    if (error == nil) {
        //Vi kjor nu
        [self handleJSONOrPLISTSuccessRespond: responseObject type:1];
    } else {
        [self showErrorDialog];
    }
}
- (void)didFinishedLoadinWeatherPLISTFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error {
    if (error == nil) {
        //Vi kjor nu
        [self handleJSONOrPLISTSuccessRespond: responseObject type:2];
    } else {
        [self showErrorDialog];
    }
}

- (void)didFinishedLoadinWeatherXMLFromServer:(AFHTTPRequestOperation *)operation responseObject:(id)responseObject error:(NSError *)error {
    if (error == nil) {
        //Vi kjor nu
        [self handleXMLSuccessRespond: responseObject];
    } else {
        [self showErrorDialog];
    }
}

-(void)requstJSONWithDelegate {

    /*WTClient *sharedClient = [WTClient sharedClient];
    sharedClient.delegate = self;
    [sharedClient loadWeatherJSONFromServer];*/

    [[[WTClient alloc] initWithDelegate:self] loadWeatherJSONFromServer];
}

- (IBAction)jsonTapped:(id)sender
{
    //[self requstJSONWithCallBack];
    [self requstJSONWithDelegate];

}

- (IBAction)plistTapped:(id)sender
{


    [[[WTClient alloc] initWithDelegate:self] loadWeatherPLISTFromServer];

}

- (IBAction)xmlTapped:(id)sender
{
    [[[WTClient alloc] initWithDelegate:self] loadWeatherXMLFromServer];
}

- (IBAction)clientTapped:(id)sender
{
    UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"AFHTTPSessionManager"
                                                             delegate:self
                                                    cancelButtonTitle:@"Cancel"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"HTTP GET", @"HTTP POST", nil];
    [actionSheet showFromBarButtonItem:sender animated:YES];
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
    if (!self.weather) {
        return 0;
    }
    switch (section) {
        case 0: {
            return 1;
        }
        case 1:{
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            return [upcomingWeather count];
        }
        default:{
            return 0;
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"WeatherCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    NSDictionary *dayWeather = nil;
    switch (indexPath.section) {
        case 0:
            dayWeather = [self.weather currentCondition];
            break;
        case 1: {
            NSArray *upcomingWeather = [self.weather upcomingWeather];
            dayWeather = upcomingWeather[indexPath.row];
        }
        default:
            break;
    }
    cell.textLabel.text = [dayWeather weatherDescription];


    NSURL *url = [NSURL URLWithString:dayWeather.weatherIconURL];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];

    UIImage *placehoderImage = [UIImage imageNamed:@"placeholder"];

    __weak UITableViewCell *weakCell = cell;

    [cell.imageView setImageWithURLRequest:request
                          placeholderImage:placehoderImage
                                   success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {

                                       weakCell.imageView.image = image;
                                       [weakCell setNeedsLayout];

                                   } failure:nil];



    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
}

#pragma mark - NSXMLParserDelegate


- (void)parserDidStartDocument:(NSXMLParser *)parser {

    NSLog(@"parserDidStartDocument");
    self.xmlWeather = [NSMutableDictionary dictionary];
}

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {

    NSLog(@"didStartElement");
    self.elementName = qName;
    if ([qName isEqualToString:@"current_condition"] || [qName isEqualToString:@"weather"] || [qName isEqualToString:@"request"]) {
        self.currentDictionary = [NSMutableDictionary dictionary];
    }
    self.outstring = [NSMutableString string];
}

- (void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string {
    NSLog(@"foundCharacters");
    if (!self.elementName) {
        return;
    }
    [self.outstring appendFormat:@"%@", string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName {
    NSLog(@"didEndElement");

    if ([qName isEqualToString:@"current_condition"] || [qName isEqualToString:@"request"]) {
        self.xmlWeather[qName] = @[self.currentDictionary];
        self.currentDictionary = nil;
    } else if ([qName isEqualToString:@"weather"]) {
        NSMutableArray *array = self.xmlWeather[@"weather"] ? : [NSMutableArray array];
        [array addObject:self.currentDictionary];
        self.xmlWeather[@"weather"] = array;

        self.currentDictionary = nil;
    } else if ([qName isEqualToString:@"value"]) {

    } else if ([qName isEqualToString:@"weatherDesc"] || [qName isEqualToString:@"weatherIconUrl"]) {
        NSDictionary *dictionary = @{@"value": self.outstring};
        NSArray *array = @[dictionary];
        self.currentDictionary[qName] = array;
    } else if (qName) {
        self.currentDictionary[qName] = self.outstring;
    }

    self.elementName = nil;
}

- (void) parserDidEndDocument:(NSXMLParser *)parser
{
    self.weather = @{@"data": self.xmlWeather};
    self.title = @"XML Retrieved";
    [self.tableView reloadData];
}





@end