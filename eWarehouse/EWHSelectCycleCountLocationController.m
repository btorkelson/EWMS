//
//  EWHSelectCycleCountLocationController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHSelectCycleCountLocationController.h"

@interface EWHSelectCycleCountLocationController ()

@end

EWHRootViewController *rootController;
@implementation EWHSelectCycleCountLocationController

@synthesize warehouse;
@synthesize cyclecountJob;
@synthesize cyclecountLocations;

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

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Locations", @"Locations");
    return title;
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
    [self performSegueWithIdentifier:@"ViewCycleCountJobLocationCatalog" sender:location];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ViewCycleCountJobLocationCatalog"]) {
        EWHSelectCycleCountLocationCatalogController *selectController = [segue destinationViewController];
        selectController.warehouse=warehouse;
        selectController.cyclecountJob=cyclecountJob;
        selectController.location=sender;
    }
}

@end
