//
//  EWHSelectSortJobController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import "EWHSelectSortJobController.h"

@interface EWHSelectSortJobController ()

@end

@implementation EWHSelectSortJobController

@synthesize warehouse;
@synthesize sortjobs;
EWHRootViewController *rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidAppear:(BOOL)animated{
    rootController.locations = nil;
    [self loadSortJobs];
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [sortjobs count];
}

-(void) loadSortJobs
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetSortJobsRequest *request = [[EWHGetSortJobsRequest alloc] initWithCallbacks:self callback:@selector(getSortJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getSortJobsRequest:warehouse.Id withAuthHash:user.AuthHash];
    }
}

-(void) getSortJobListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    sortjobs = results;
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



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHSortJob *job = [sortjobs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = job.JobName;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [EWHUtils.dateFormatter stringFromDate:job.JobDate], job.ProgramName];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHSortJob *job = [sortjobs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"SortScanPart" sender:job];
}

-(IBAction) refreshPressed: (id) sender
{
    [self sortjobs];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SortScanPart"]) {
        EWHSortScanPartsController  *scanPartsController = [segue destinationViewController];
        scanPartsController.warehouse = warehouse;
        scanPartsController.sortJob=sender;
    }
}


@end
