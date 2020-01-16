//
//  EWHCycleCountCatalogController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/16/20.
//

#import "EWHCycleCountCatalogController.h"

@interface EWHCycleCountCatalogController ()

@end

EWHRootViewController *rootController;
DTDevices *linea;

@implementation EWHCycleCountCatalogController

@synthesize warehouse;
@synthesize cyclecountJob;
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

- (void)viewDidAppear:(BOOL)animated{
    linea=[DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
    rootController.locations = nil;
    [self loadCycleCountLocations];
}

-(void)connectionState:(int)state {
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            //[btnScanUserName setHidden:true];
            //[scannerMsg setHidden:false];
            //[voltageLabel setHidden:true];
            //[battery setHidden:true];
            break;
        case CONN_CONNECTED:
            //[btnScanUserName setHidden:false];
            //[scannerMsg setHidden:true];
            //[self updateBattery];
            ////Z - remove in production
            ////            [linea setScanBeep:false volume:0 beepData:nil length:0];
            break;
    }
}


-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
        [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}


-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        //        txtNewLocation.text = barcode;
        [self validateScan:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        //        txtNewLocation.text = barcode;
        [self validateScan:barcode];
    }
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove in production
    //barcode = @"176761";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Value == %@", barcode];
    NSArray *matches = [cyclecountCatalogs filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHCycleCountJobDetail *location = [matches objectAtIndex:0];
        [self performSegueWithIdentifier:@"ViewCycleCountJobCatalogLocation" sender:location];
    }
    else {
        [rootController displayAlert:@"Incorrect part" withTitle:@"Cycle Count"];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
    return [cyclecountCatalogs count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Parts", @"Parts");
    return title;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHCycleCountJobDetail *location = [cyclecountCatalogs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = location.Value;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHCycleCountJobDetail *location = [cyclecountCatalogs objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ViewCycleCountJobCatalogLocation" sender:location];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ViewCycleCountJobCatalogLocation"]) {
        EWHCycleCountCatalogLocationController *selectController = [segue destinationViewController];
        selectController.warehouse=warehouse;
        selectController.cyclecountJob=cyclecountJob;
        selectController.catalog=sender;
    }
}

@end
