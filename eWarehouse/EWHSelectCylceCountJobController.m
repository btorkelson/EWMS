//
//  EWHSelectCylceCountJobController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import "EWHSelectCylceCountJobController.h"

@interface EWHSelectCylceCountJobController ()

@end



EWHRootViewController *rootController;

@implementation EWHSelectCylceCountJobController

@synthesize warehouse;
@synthesize cyclecountJobs;

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
    [self loadCycleCountJobs];
}

#pragma mark - Table view data source

-(void) loadCycleCountJobs
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetCycleCountJobs *request = [[EWHGetCycleCountJobs alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getCycleCountJobs:warehouse.Id withAuthHash:user.AuthHash];
    }
}

-(void) getJobListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    cyclecountJobs = results;
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
    return [cyclecountJobs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHCycleCountJob *job = [cyclecountJobs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = job.CycleCountJobNumber;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [EWHUtils.dateFormatter stringFromDate:job.DueDate]];
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHCycleCountJob *job = [cyclecountJobs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewCycleCountJobLocation" sender:job];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ViewCycleCountJobLocation"]) {
        EWHSelectCycleCountLocationController *selectController = [segue destinationViewController];
        selectController.warehouse=warehouse;
        selectController.cyclecountJob=sender;
    }
}

@end
