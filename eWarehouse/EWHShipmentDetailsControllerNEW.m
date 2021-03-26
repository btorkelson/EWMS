//
//  EWHShipmentDetailsControllerNEW.m
//  eWarehouse
//
//  Created by Brian Torkelson on 6/6/13.
//
//

#import "EWHShipmentDetailsControllerNEW.h"

@implementation EWHShipmentDetailsControllerNEW
{
    
}

@synthesize warehouse;
@synthesize shipment;
@synthesize shipmentDetails;
@synthesize location;
@synthesize storagelocation;

EWHRootViewController *rootController;
DTDevices *linea;

#pragma mark -
#pragma mark Table view data source

- (void) viewDidLoad{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.shipmentDetailsView = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    linea = [DTDevices sharedDevice];
	[linea connect];
    [linea addDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadShipmentDetails];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) loadShipmentDetails
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetShipmentDetailsforPickingRequestNEW *request = [[EWHGetShipmentDetailsforPickingRequestNEW alloc] initWithCallbacks:self callback:@selector(getShipmentDetailsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        
        [request getShipmentDetailsForPickingRequestNEW:shipment.ShipmentId location:storagelocation withAuthHash:user.AuthHash];
         
    }
}

-(void) getShipmentDetailsCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    shipmentDetails = results;
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
    return [shipmentDetails count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ShipmentDetailCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHShipmentDetail *shipmentDetail = [shipmentDetails objectAtIndex:indexPath.row];
    
    cell.textLabel.text = shipment.isContainer? shipmentDetail.Number : shipmentDetail.PartNumber;
    if (shipment.isValidateLotNumber) {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@ LotNo: %@", shipmentDetail.Type, shipmentDetail.LocationName, shipmentDetail.LotNumber];
    } else {
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", shipmentDetail.Type, shipmentDetail.LocationName];
    }
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHShipmentDetail *detail = [shipmentDetails objectAtIndex:indexPath.row];
    detail.IsScanned = NO;
//    if(shipment.isValidateLotNumber){
//        [self performSegueWithIdentifier:@"ScanLotNumber" sender:detail];
//    } else {
        if(location == nil)
            [self performSegueWithIdentifier:@"SelectLocation" sender:detail];
        else
            if(shipment.isContainer)
                [self performSegueWithIdentifier:@"ScanLocation" sender:detail];
            else {
                if(detail.IsSerialized)
                    [self performSegueWithIdentifier:@"GetSerializedPartData" sender:detail];
                else
                    [self performSegueWithIdentifier:@"GetPartData" sender:detail];
                
            }
//    }
}

-(IBAction) refreshPressed: (id) sender
{
    [self loadShipmentDetails];
}

-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
        [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    //    if(self.navigationController.visibleViewController == self){
    [self stopScan];
    [self validateScan:barcode];
    //    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    //    if(self.navigationController.visibleViewController == self){
    [self stopScan];
    [self validateScan:barcode];
    //    }
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove for distribution
    //    switch (shipment.ShipmentId) {
    //        case 349927:
    //            barcode = @"14096";
    //            break;
    //        case 349928:
    //            barcode = @"Notepad bulk";
    //            break;
    //        case 349929:
    //            barcode = @"14097";
    //            break;
    //        case 349930:
    //            barcode = @"Scanner";
    //            break;
    //        case 349931:
    //            barcode = @"Scanner";
    //            break;
    //        default:
    //            break;
    //    }
    NSPredicate *predicate = shipment.isContainer ? [NSPredicate predicateWithFormat:@"Number == %@", barcode] :[NSPredicate predicateWithFormat:@"PartNumber == %@", barcode];
    NSArray *matches = [shipmentDetails filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHShipmentDetail *detail = [matches objectAtIndex:0];
        detail.IsScanned = YES;
        
//        if(shipment.isValidateLotNumber){
//            [self performSegueWithIdentifier:@"ScanLotNumber" sender:detail];
//        } else {
                if(location == nil)
                    [self performSegueWithIdentifier:@"SelectLocation" sender:detail];
                else {
               
            if(detail.IsScanned){
                if(shipment.isContainer)
                    [self performSegueWithIdentifier:@"ScanLocation" sender:detail];
                else {
                    if(detail.IsSerialized)
                        [self performSegueWithIdentifier:@"GetSerializedPartData" sender:detail];
                    else
                        [self performSegueWithIdentifier:@"GetPartData" sender:detail];
                    
                }
            }
            else
                [self performSegueWithIdentifier:@"ScanContainer" sender:detail];
            }
//        }
    }
    else {
        if(shipment.isContainer)
            [rootController displayAlert:@"Incorrect container" withTitle:@"Shipment Details"];
        else
            [rootController displayAlert:@"Incorrect part" withTitle:@"Shipment Details"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
        EWHSelectLocationController *selectLocationController = [segue destinationViewController];
        selectLocationController.shipmentDetail = sender;
        selectLocationController.shipment = shipment;
        selectLocationController.warehouse = warehouse;
        selectLocationController.storagelocation = storagelocation;
    }
    else if([[segue identifier] isEqualToString:@"ScanContainer"]) {
        EWHScanContainerController *scanContainerController = [segue destinationViewController];
        scanContainerController.shipmentDetail = sender;
        scanContainerController.shipment = shipment;
        scanContainerController.warehouse = warehouse;
        scanContainerController.location = location;
        scanContainerController.storagelocation = storagelocation;
    }
    else if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.shipmentDetail = sender;
        scanLocationController.shipment = shipment;
        scanLocationController.warehouse = warehouse;
        scanLocationController.location = location;
        scanLocationController.storagelocation = storagelocation;
    }
    else if([[segue identifier] isEqualToString:@"GetPartData"]) {
        EWHGetPartDetailsController *getPartDataController = [segue destinationViewController];
        getPartDataController.shipmentDetail = sender;
        getPartDataController.shipment = shipment;
        getPartDataController.warehouse = warehouse;
        getPartDataController.location = location;
        getPartDataController.storagelocation = storagelocation;
    }
    else if([[segue identifier] isEqualToString:@"GetSerializedPartData"]) {
        EWHGetSerializedPartDetailsController *getSerializedPartDataController = [segue destinationViewController];
        getSerializedPartDataController.shipmentDetail = sender;
        getSerializedPartDataController.shipment = shipment;
        getSerializedPartDataController.warehouse = warehouse;
        getSerializedPartDataController.location = location;
        getSerializedPartDataController.storagelocation = storagelocation;
    }
//    else if([[segue identifier] isEqualToString:@"ScanLotNumber"]) {
//        EWHScanLotNumberController *scanLotNumber = [segue destinationViewController];
//        scanLotNumber.shipmentDetail = sender;
//        scanLotNumber.shipment = shipment;
//        scanLotNumber.warehouse = warehouse;
//        scanLotNumber.location = location;
//        scanLotNumber.storagelocation = storagelocation;
//    }
}

@end

