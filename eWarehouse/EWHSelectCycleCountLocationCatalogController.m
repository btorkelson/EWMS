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
DTDevices *linea;

@implementation EWHSelectCycleCountLocationCatalogController

@synthesize warehouse;
@synthesize cyclecountJob;
@synthesize location;
@synthesize cyclecountCatalogs;

int totalQuantity;

- (void)viewDidLoad {
    [super viewDidLoad];
    totalQuantity = 0;
    [self loadCycleCountLocationCatalogs];
    
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ItemNumber == %@", barcode];
    NSArray *matches = [cyclecountCatalogs filteredArrayUsingPredicate:predicate];
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
//        [rootController displayAlert:@"Incorrect Part Number" withTitle:@"Cycle Count"];
        UIAlertController * alert = [UIAlertController
                                     alertControllerWithTitle:@"Cycle Count Part"
                                     message:@"Part Number not found. Do you want to add this part to this cycle count in this location?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        EWHCycleCountCatalogbyLocation *catalog = [[EWHCycleCountCatalogbyLocation alloc] init];
                                        catalog.ItemNumber=barcode;
                                        catalog.IsBulk=1;
                                        catalog.ScannedSerials = [[NSMutableArray alloc] init];
                                        catalog.ProgramName=@"";
                                        catalog.CycleCountJobId=cyclecountJob.CycleCountJobId;
                                        catalog.CycleCountJobDetailId=location.CycleCountJobDetailId;
                                        catalog.LocationId=location.Id;
                                        catalog.LocationName=location.Value;
                                        [cyclecountCatalogs addObject:catalog];
                                        [self performSegueWithIdentifier:@"CycleCountLocationBulk" sender:catalog];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       //Handle no, thanks button
                                   }];
        
        [alert addAction:yesButton];
        [alert addAction:noButton];
        
        [self presentViewController:alert animated:YES completion:nil];
        
        
    }
}

#pragma mark - Table view data source

-(void) loadCycleCountLocationCatalogs
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        if (cyclecountJob.CycleCountJobTypeId==1) {
            EWHGetCycleCountJobDetailLocationCatalogs *request = [[EWHGetCycleCountJobDetailLocationCatalogs alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getCycleCountJobDetailLocationCatalogs:cyclecountJob.CycleCountJobId locationId:location.Id isNew:1 user:user];
        } else if (cyclecountJob.CycleCountJobTypeId==3) {
            EWHGetCycleCountJobDetailByItem *request = [[EWHGetCycleCountJobDetailByItem alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getCycleCountJobDetailItemCatalogs:cyclecountJob.CycleCountJobId locationId:location.Id user:user];
        }
        	
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
    
    EWHTableViewCellforTransfer *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHCycleCountCatalogbyLocation *catalog = [cyclecountCatalogs objectAtIndex:indexPath.row];
    
    cell.lblQty.text=[NSString stringWithFormat:@"%li",(long)catalog.QuantityScanned];
    cell.lblStatus.text=catalog.ProgramName;
    cell.lblInventoryType.text=catalog.ItemNumber;
    //    txtInventoryType = catalog.InventoryTypeName;
    //    cell.detailTextLabel.text = catalog.InventoryStatusName;
    
    totalQuantity = totalQuantity+(int)catalog.QuantityScanned;
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{

    EWHTableViewCellforTransfer * cell = [tableView cellForRowAtIndexPath:indexPath];
    EWHUser *user = rootController.user;
    EWHCycleCountCatalogbyLocation *catalog = [cyclecountCatalogs objectAtIndex:indexPath.row];
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
    
    
}
- (IBAction)finishPressed:(id)sender {
    
//    if ([cyclecountCatalogs count]>=1){
//    } else {
//        [self validateScan:@"asdasdf"];
//
//    }
    self.navigationItem.rightBarButtonItem.enabled=false;
    [self sendCycleCountResults];
    
}

-(void) sendCycleCountResults
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if (totalQuantity== 0) {
        UIAlertController * alert2 = [UIAlertController
                                     alertControllerWithTitle:@"Confirm"
                                     message:@"Is this location empty?"
                                     preferredStyle:UIAlertControllerStyleAlert];
        
        
        
        UIAlertAction* yesButton = [UIAlertAction
                                    actionWithTitle:@"Yes"
                                    style:UIAlertActionStyleDefault
                                    handler:^(UIAlertAction * action) {
                                        if(user != nil){
                                            EWHProcessCycleCountDetailByLocation *request = [[EWHProcessCycleCountDetailByLocation alloc] initWithCallbacks:self callback:@selector(getSendCycleCountResultsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
                                            [request processCycleCountDetailByLocation:cyclecountCatalogs user:user];
                                        }
//                                        [self finishCycleCountDetail];
                                    }];
        
        UIAlertAction* noButton = [UIAlertAction
                                   actionWithTitle:@"No"
                                   style:UIAlertActionStyleDefault
                                   handler:^(UIAlertAction * action) {
                                       
                                       [rootController hideLoading];
                                       self.navigationItem.rightBarButtonItem.enabled=TRUE;
                                   }];
        
        [alert2 addAction:yesButton];
        [alert2 addAction:noButton];
        
        [self presentViewController:alert2 animated:YES completion:nil];
        
        
        
    } else {
        
        if(user != nil){
            EWHProcessCycleCountDetailByLocation *request = [[EWHProcessCycleCountDetailByLocation alloc] initWithCallbacks:self callback:@selector(getSendCycleCountResultsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request processCycleCountDetailByLocation:cyclecountCatalogs user:user];
        } 
        
    }
}



-(void) getSendCycleCountResultsCallback: (NSMutableArray*) results
{
//        [rootController showLoading];
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
            [request finishCycleCountJobDetail:location.CycleCountJobDetailId cycleCountJobId:cyclecountJob.CycleCountJobId user:user];
        }
    
}
-(void) finishCycleCountDetailCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    [rootController displayAlert:@"Success" withTitle:@"Complete"];
    [cyclecountCatalogs removeAllObjects];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CycleCountLocationBulk"]) {
        EWHCycleCountLocationBulkController *selectReceiptController = [segue destinationViewController];
        selectReceiptController.location= location;
        selectReceiptController.catalog=sender;
    } else if ([[segue identifier] isEqualToString:@"CycleCountLocationSerial"]) {
        EWHCycleCountLocationSerialController *selectReceiptController = [segue destinationViewController];
        selectReceiptController.location= location;
        selectReceiptController.catalog=sender;
    }
    
}
@end
