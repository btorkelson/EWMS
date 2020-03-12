//
//  EWHCycleCountCatalogLocationController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/16/20.
//

#import "EWHCycleCountCatalogLocationController.h"

@interface EWHCycleCountCatalogLocationController ()

@end

EWHRootViewController *rootController;
DTDevices *linea;

@implementation EWHCycleCountCatalogLocationController

@synthesize warehouse;
@synthesize cyclecountJob;
@synthesize catalog;
@synthesize cyclecountLocations;

int totalQuantity;

- (void)viewDidLoad {
    [super viewDidLoad];
    totalQuantity = 0;
    [self loadCycleCountCatalogLocations];
    
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
    return [cyclecountLocations count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Locations", @"Locations");
    return title;
}
- (void)viewDidAppear:(BOOL)animated{
    linea=[DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
    
    totalQuantity=0;
    [self.tableView reloadData];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"LocationName == %@", barcode];
    NSArray *matches = [cyclecountLocations filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHCycleCountCatalogbyLocation *catalog = [matches objectAtIndex:0];
        if (catalog.IsBulk==1) {
            [self performSegueWithIdentifier:@"CycleCountLocationBulk" sender:catalog];
        } else {
            [self performSegueWithIdentifier:@"CycleCountLocationSerial" sender:catalog];
        }
    }
    else {
                [rootController displayAlert:@"Incorrect Location" withTitle:@"Cycle Count"];
        
    }
}

#pragma mark - Table view data source

-(void) loadCycleCountCatalogLocations
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetCycleCountJobDetailCatalogLocations *request = [[EWHGetCycleCountJobDetailCatalogLocations alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getCycleCountJobDetailCatalogLocations:cyclecountJob.CycleCountJobId catalogId:catalog.Id user:user];
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

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    EWHTableViewCellforTransfer *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHCycleCountCatalogbyLocation *catalog = [cyclecountLocations objectAtIndex:indexPath.row];
    
    cell.lblQty.text=[NSString stringWithFormat:@"%li",(long)catalog.QuantityScanned];
    cell.lblStatus.text=catalog.ProgramName;
    cell.lblInventoryType.text=catalog.LocationName;
    //    txtInventoryType = catalog.InventoryTypeName;
    //    cell.detailTextLabel.text = catalog.InventoryStatusName;
    
    totalQuantity = totalQuantity+(int)catalog.QuantityScanned;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    EWHTableViewCellforTransfer * cell = [tableView cellForRowAtIndexPath:indexPath];
    EWHUser *user = rootController.user;
    EWHCycleCountCatalogbyLocation *catalog = [cyclecountLocations objectAtIndex:indexPath.row];
    if (user.EWAdmin) {
        //    [self performSegueWithIdentifier:@"ViewCycleCountJobLocation" sender:location];
        if (catalog.IsBulk==1) {
            [self performSegueWithIdentifier:@"CycleCountLocationBulk" sender:catalog];
        } else {
            [self performSegueWithIdentifier:@"CycleCountLocationSerial" sender:catalog];
        }
    } else {
        cell.lblQty.text=[NSString stringWithFormat:@"Please scan %li",(long)catalog.QuantityScanned];
        
    }
    
    //    [self performSegueWithIdentifier:@"ViewCycleCountJobLocation" sender:location];
}
- (IBAction)finishPressed:(id)sender {
    
    //    if ([cyclecountCatalogs count]>=1){
    self.navigationItem.rightBarButtonItem.enabled=false;
    [self sendCycleCountResults];
    //    } else {
    //        [self validateScan:@"asdasdf"];
    //
    //    }
}

-(void) sendCycleCountResults
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if (totalQuantity== 0) {
        UIAlertController * alert2 = [UIAlertController
                                      alertControllerWithTitle:@"Confirm"
                                      message:@"Please confirm there are 0 in inventory"
                                      preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        [self finishCycleCountDetail];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       self.navigationItem.rightBarButtonItem.enabled=TRUE;
                                       [rootController hideLoading];
                                   }];
        
        [alert2 addAction:yesButton];
        [alert2 addAction:noButton];
        
        [self presentViewController:alert2 animated:YES completion:nil];
        
        
        
    } else {
        
        if(user != nil){
            EWHProcessCycleCountDetailByLocation *request = [[EWHProcessCycleCountDetailByLocation alloc] initWithCallbacks:self callback:@selector(getSendCycleCountResultsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request processCycleCountDetailByLocation:cyclecountLocations user:user];
        }
        
    }
}



-(void) getSendCycleCountResultsCallback: (NSMutableArray*) results
{
    //    [rootController hideLoading];
    //    [self.navigationController popViewControllerAnimated:YES];
    [self finishCycleCountDetail];
}

-(void) finishCycleCountDetail
{
    //    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHFinichCycleCountJobDetail *request = [[EWHFinichCycleCountJobDetail alloc] initWithCallbacks:self callback:@selector(finishCycleCountDetailCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //            EWHCycleCountCatalogbyLocation *catalog = [cyclecountCatalogs objectAtIndex:0];
        [request finishCycleCountJobDetail:catalog.CycleCountJobDetailId cycleCountJobId:cyclecountJob.CycleCountJobId user:user];
    }
    
}
-(void) finishCycleCountDetailCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    [rootController displayAlert:@"Success" withTitle:@"Complete"];
    
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CycleCountLocationBulk"]) {
        EWHCycleCountLocationBulkController *selectReceiptController = [segue destinationViewController];
        selectReceiptController.location= catalog;
        selectReceiptController.catalog=sender;
    } else if ([[segue identifier] isEqualToString:@"CycleCountLocationSerial"]) {
        EWHCycleCountLocationSerialController *selectReceiptController = [segue destinationViewController];
        selectReceiptController.location= catalog;
        selectReceiptController.catalog=sender;
    }
    
}
@end
