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
@synthesize cyclecountCatalogs;

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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [cyclecountCatalogs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Parts", @"Parts");
    return title;
}
- (void)viewDidAppear:(BOOL)animated{
    [self loadCycleCountLocationCatalogs];
}

#pragma mark - Table view data source

-(void) loadCycleCountLocationCatalogs
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetCycleCountJobDetailLocationCatalogs *request = [[EWHGetCycleCountJobDetailLocationCatalogs alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getCycleCountJobDetailLocationCatalogs:cyclecountJob.CycleCountJobId locationId:location.Id isNew:1 user:user];
    }
}

-(void) getJobListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    cyclecountCatalogs = results;
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
    EWHCatalog *catalog = [cyclecountCatalogs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = catalog.ItemNumber;
    cell.detailTextLabel.text = catalog.ProgramName;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHCatalog *catalog = [cyclecountCatalogs objectAtIndex:indexPath.row];
//    [self performSegueWithIdentifier:@"ViewCycleCountJobLocation" sender:location];
}

@end
