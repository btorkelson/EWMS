//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHPickShipmentScanLocationController.h"

@implementation EWHPickShipmentScanLocationController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;
@synthesize quantity;
@synthesize serialNumbers;
@synthesize storagelocation;

EWHRootViewController *rootController;
DTDevices *linea;
NSString *location;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;    
}

- (void)viewWillAppear:(BOOL)animated
{
    linea=[DTDevices sharedDevice];
	[linea connect];
	[linea addDelegate:self];
	//update display according to current linea state
	[self connectionState:linea.connstate];
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

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Shipment Info", @"Shipment Info");;
            break;
        case 1:
            title = NSLocalizedString(@"Pick Shipment Data", @"Pick Shipment Data");;
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return 3;
            break;
        case 1:
            if(shipment.isContainer)
                return 3;
            else
                return 4;
            break;
        default:
            break;
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ReceiptCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set the text in the cell for the section/row.
    
    NSString *cellTitle = nil;
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellTitle = @"Program";
                    cellText = shipment.ProgramName;
                    break;
                case 1:
                    cellTitle = @"Shipment";
                    cellText = shipment.ShipmentNumber;
                    break;
                case 2:
                    cellTitle = @"Received";
                    cellText = [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate];
                    break;
                default:
                    break;
            }
            break;
        case 1:
            switch (indexPath.row) {
                case 0:
                    cellTitle = @"Number";
                    cellText = shipment.isContainer ? shipmentDetail.Number : shipmentDetail.PartNumber;
                    break;
                case 1:
                    cellTitle = @"Type";
                    cellText = shipmentDetail.Type;
                    break;
                case 2:
                    cellTitle = @"Location";
                    cellText = shipmentDetail.LocationName;
                    break;
                case 3:
                    if(shipmentDetail.IsSerialized){
                        cellTitle = @"Serial#";
                        cellText = serialNumbers;
                    }
                    else {
                        cellTitle = @"Quantity";
                        cellText = [NSString stringWithFormat:@"%d", quantity];
                    }
                    break;
                default:
                    break;
            }
        default:
            break;
    }
    
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = cellText;

    return cell;
}

-(IBAction)scanLocationDown:(id)sender;
{
	NSError *error = nil;
	[linea startScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(IBAction)scanLocationUp:(id)sender;
{
    [self stopScan];
}

-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
        [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
            [btnScanLocation setHidden:true];
            [scannerMsg setHidden:false];
            [voltageLabel setHidden:true];
            [battery setHidden:true];
			break;
		case CONN_CONNECTED:
            [btnScanLocation setHidden:false];
            [scannerMsg setHidden:true];
            [self updateBattery];
            //Z - remove in production
//            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    if(self.navigationController.visibleViewController == self){
//        [self stopScan];
        [self pickShipment];
    }
    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
//        [self stopScan];
        [self pickShipment];
    }
    [self updateBattery];
}

-(void)updateBattery
{
    NSError *error=nil;
    
    int percent;
    float voltage;
    
	if([linea getBatteryCapacity:&percent voltage:&voltage error:&error])
    {
//        [voltageLabel setText:[NSString stringWithFormat:@"%d%%,%.1fv",percent,voltage]];
        [voltageLabel setText:[NSString stringWithFormat:@"%d%%",percent]];
      [battery setHidden:FALSE];
        [voltageLabel setHidden:FALSE];
        if(percent<0.1)
            [battery setImage:[UIImage imageNamed:@"0.png"]];
        else if(percent<40)
            [battery setImage:[UIImage imageNamed:@"25.png"]];
        else if(percent<60)
            [battery setImage:[UIImage imageNamed:@"50.png"]];
        else if(percent<80)
            [battery setImage:[UIImage imageNamed:@"75.png"]];
        else
            [battery setImage:[UIImage imageNamed:@"100.png"]];
    }else
    {
        [battery setHidden:TRUE];
        [voltageLabel setHidden:TRUE];
    }
}

-(void) pickShipment
{
    //Z - remove for distribution
//    barcode = shipmentDetail.LocationName;
    if(shipmentDetail.IsSerialized
       || [shipmentDetail.LocationName isEqualToString:storagelocation]){
        if(shipment.isContainer)
            [self pickContainer];
        else
            if(shipmentDetail.IsSerialized)
                [self pickSerializedPart];
            else
                [self pickPart];
    }
    else{
        [rootController displayAlert:@"Invalid location" withTitle:@"Pick Shipment"];
    }
}

-(void) pickContainer
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHPickContainerRequest *request = [[EWHPickContainerRequest alloc] initWithCallbacks:self callback:@selector(pickShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request pickContainer:shipmentDetail warehouse:warehouse.Id location:location  user:user];
    }
}

-(void) pickPart
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHPickItemRequest *request = [[EWHPickItemRequest alloc] initWithCallbacks:self callback:@selector(pickShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request pickItem:shipmentDetail warehouse:warehouse.Id location:location quantity:quantity user:user];
    }
}

-(void) pickSerializedPart
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHPickSerializedItemRequest *request = [[EWHPickSerializedItemRequest alloc] initWithCallbacks:self callback:@selector(pickShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request pickItem:shipmentDetail warehouse:warehouse.Id location:location locationName:storagelocation serialNumbers:serialNumbers user:user];
    }
}

-(void) pickShipmentCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    [rootController displayAlert:result.Message withTitle:@"Pick Shipment"];
    if(result.Processed){
        [self getShipmentDetails:shipmentDetail.ShipmentId];
    }
}

-(void) getShipmentDetails: (NSInteger)shipmentId
{
    [rootController showLoading];
    EWHGetLocationsforPickingRequestNEW *request = [[EWHGetLocationsforPickingRequestNEW alloc] initWithCallbacks:self callback:@selector(getShipmentDetailsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
    [request getLocationsForPickingRequestNEW:shipmentId withAuthHash:rootController.user.AuthHash];
}

-(void) getShipmentDetailsCallback: (NSMutableArray *) items
{
    [rootController hideLoading];
    if(items.count > 0)
        [rootController popToViewController:rootController.shipmentLocationsView animated:YES];
    else
        [rootController popToViewController:rootController.selectShipmentView animated:YES];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Pick Shipment"];
}

-(void) errorGetShipmentDetailsCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController popToViewController:rootController.selectShipmentView animated:YES];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}
- (IBAction)pickPressed:(id)sender {
    [self pickShipment];
}

@end
