//
//  EWHSelectLocationControllerNEW.m
//  eWarehouse
//
//  Created by Brian Torkelson on 6/3/13.
//
//

#import "EWHSelectLocationControllerNEW.h"

@implementation EWHSelectLocationControllerNEW
{
}


@synthesize warehouse;
@synthesize shipment;
@synthesize shipmentLocations;
@synthesize location;

EWHRootViewController *rootController;
DTDevices *linea;

#pragma mark -
#pragma mark Table view data source

- (void) viewDidLoad{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.shipmentLocationsView = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    linea = [DTDevices sharedDevice];
	[linea connect];
    [linea addDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadLocationDetails];
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
-(void) loadLocationDetails
{
    [rootController showLoading];
        
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetLocationsforPickingRequestNEW *request = [[EWHGetLocationsforPickingRequestNEW alloc] initWithCallbacks:self callback:@selector(getLocationCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getLocationsForPickingRequestNEW:shipment.ShipmentId withAuthHash:user.AuthHash];
    }
}

-(void) getLocationCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    shipmentLocations = results;
    if ([shipmentLocations count] >0) {
        [self.tableView reloadData];
    } else {
        [rootController popToViewController:rootController.selectShipmentView animated:YES];
    }
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
    return [shipmentLocations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"LocationCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHLocation *binlocation = [shipmentLocations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = binlocation.Name;
    cell.detailTextLabel.text = @" ";
//    cell.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    cell.backgroundColor = [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.0];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", shipmentDetail.Type, shipmentDetail.LocationName];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
   EWHLocation *detail = [shipmentLocations objectAtIndex:indexPath.row];

//        [self performSegueWithIdentifier:@"SelectPart" sender:detail.Name];
    
    UITableViewCell * cell = [tableView cellForRowAtIndexPath:indexPath];
//    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle];
    
    EWHUser *user = rootController.user;
    if (user.EWAdmin) {
                    [self validateScan:cell.textLabel.text];
    } else {
        cell.detailTextLabel.text = @"Please scan";
    }
}

-(IBAction) refreshPressed: (id) sender
{
    [self loadLocationDetails];
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
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", barcode];
    NSArray *matches = [shipmentLocations filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
//    
//    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF == %@", barcode];
//    NSArray *matches = [colist2 filteredArrayUsingPredicate:predicate];
//    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHLocation *loc = [matches objectAtIndex:0];
        [self performSegueWithIdentifier:@"SelectPart" sender:loc.Name];
    }
    else {
        [rootController displayAlert:@"Incorrect Location" withTitle:@"Location"];
    }
//    if([matches count] > 0){
//        EWHShipmentDetail *detail = [matches objectAtIndex:0];
//        detail.IsScanned = YES;
//        if(location == nil)
//            [self performSegueWithIdentifier:@"SelectLocation" sender:detail];
//        else {
//            if(detail.IsScanned){
//                if(shipment.isContainer)
//                    [self performSegueWithIdentifier:@"ScanLocation" sender:detail];
//                else {
//                    if(detail.IsSerialized)
//                        [self performSegueWithIdentifier:@"GetSerializedPartData" sender:detail];
//                    else
//                        [self performSegueWithIdentifier:@"GetPartData" sender:detail];
//                    
//                }
//            }
//            else
//                [self performSegueWithIdentifier:@"ScanContainer" sender:detail];
//        }
//    }
//    else {
//        if(shipment.isContainer)
//            [rootController displayAlert:@"Incorrect container" withTitle:@"Shipment Details"];
//        else
//            [rootController displayAlert:@"Incorrect part" withTitle:@"Shipment Details"];
//    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectPart"]) {
        EWHShipmentDetailsControllerNEW *selectShipmentDetailsController = [segue destinationViewController];
        selectShipmentDetailsController.storagelocation = sender;
        selectShipmentDetailsController.shipment = shipment;
        selectShipmentDetailsController.warehouse = warehouse;
        selectShipmentDetailsController.location = location;
    }
    
    if ([[segue identifier] isEqualToString:@"ScanStorageLocation"]) {
        EWHShipmentDetailsControllerNEW *selectShipmentDetailsController = [segue destinationViewController];
//        selectShipmentDetailsController.storagelocation = sender;
        selectShipmentDetailsController.shipment = shipment;
        selectShipmentDetailsController.warehouse = warehouse;
        selectShipmentDetailsController.location = location;
    }
    else if([[segue identifier] isEqualToString:@"ScanContainer"]) {
        EWHScanContainerController *scanContainerController = [segue destinationViewController];
        scanContainerController.shipmentDetail = sender;
        scanContainerController.shipment = shipment;
        scanContainerController.warehouse = warehouse;
        scanContainerController.location = location;
    }
    else if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.shipmentDetail = sender;
        scanLocationController.shipment = shipment;
        scanLocationController.warehouse = warehouse;
        scanLocationController.location = location;
    }
    else if([[segue identifier] isEqualToString:@"GetPartData"]) {
        EWHGetPartDetailsController *getPartDataController = [segue destinationViewController];
        getPartDataController.shipmentDetail = sender;
        getPartDataController.shipment = shipment;
        getPartDataController.warehouse = warehouse;
        getPartDataController.location = location;
    }
    else if([[segue identifier] isEqualToString:@"GetSerializedPartData"]) {
        EWHGetSerializedPartDetailsController *getSerializedPartDataController = [segue destinationViewController];
        getSerializedPartDataController.shipmentDetail = sender;
        getSerializedPartDataController.shipment = shipment;
        getSerializedPartDataController.warehouse = warehouse;
        getSerializedPartDataController.location = location;
    }
}

@end
