//
//  EWHSelectCycleCountLocationCatalogController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/24/18.
//
//

#import "EWHSelectCycleCountLocationCatalogController.h"

@interface EWHSelectCycleCountLocationCatalogController ()

@end

EWHRootViewController *rootController;

@implementation EWHSelectCycleCountLocationCatalogController

@synthesize warehouse;
@synthesize cyclecountJob;
@synthesize location;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 0;
}

- (void)viewDidAppear:(BOOL)animated{
    rootController.locations = nil;
    [self loadCycleCountLocations];
}

#pragma mark - Table view data source

-(void) loadCycleCountLocations
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetCycleCountJobDetails *request = [[EWHGetCycleCountJobDetails alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getCycleCountJobDetails:cyclecountJob.CycleCountJobId cyclecountJobTypeId:cyclecountJob.CycleCountJobTypeId withAuthHash:user.AuthHash];
    }
}

-(void) getJobListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    cyclecountLocations = results;
    [self.tableView reloadData];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
    return [cyclecountLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHLocation *location = [cyclecountLocations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = location.Name;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHLocation *location = [cyclecountLocations objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewCycleCountJobLocation" sender:location];
}

@end
