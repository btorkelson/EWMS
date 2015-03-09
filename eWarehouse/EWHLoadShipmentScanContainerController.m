//
//  EWHLoadShipmentScanContainerController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoadShipmentScanContainerController.h"

@implementation EWHLoadShipmentScanContainerController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;

EWHRootViewController *rootController;
DTDevices *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    
    if(shipment.isContainer){
        [btnScanItem setTitle:@"Scan container" forState:UIControlStateNormal];
        [[self navigationItem] setTitle:@"Scan Container"];
    }
    else{
        [btnScanItem setTitle:@"Scan part" forState:UIControlStateNormal];
        [[self navigationItem] setTitle:@"Scan Part"];
    }    
}

- (void)viewWillAppear:(BOOL)animated
{
    linea = [DTDevices sharedDevice];
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableReceiptView {
    // Only one section.
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Shipment Info", @"Shipment Info");
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
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"TableCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
//    cell.textLabel.font = [UIFont systemFontOfSize:12];
    
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
        default:
            break;
    }
    
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = cellText;

    return cell;
}


-(IBAction)scanItemDown:(id)sender;
{
	NSError *error = nil;
	[linea startScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(IBAction)scanItemUp:(id)sender;
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
            [btnScanItem setHidden:true];
            [scannerMsg setHidden:false];
            [voltageLabel setHidden:true];
            [battery setHidden:true];
			break;
		case CONN_CONNECTED:
            [btnScanItem setHidden:false];
            [scannerMsg setHidden:true];
            [self updateBattery];
            //Z - remove in production
//            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
    [self updateBattery];
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove for distribution
//    if(shipment.isContainer)
//        barcode = shipmentDetail.Number;
//    else
//        barcode = shipmentDetail.PartNumber;
    if((shipment.isContainer && [shipmentDetail.Number isEqualToString:barcode])
       || (!shipment.isContainer && [shipmentDetail.PartNumber isEqualToString:barcode])){
        if(shipment.isContainer)
            [self loadContainer];
        else
            if(shipmentDetail.IsSerialized)
                [self performSegueWithIdentifier:@"GetSerializedPartData" sender:shipmentDetail];
            else
                [self performSegueWithIdentifier:@"GetPartData" sender:shipmentDetail];
    }
    else {
        if(shipment.isContainer)
            [rootController displayAlert:@"Incorrect container" withTitle:@"Scan Container"];
        else
            [rootController displayAlert:@"Incorrect part" withTitle:@"Scan Part"];
    }
}

-(void) loadContainer
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHLoadContainerRequest *request = [[EWHLoadContainerRequest alloc] initWithCallbacks:self callback:@selector(loadShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request loadContainer:shipmentDetail warehouse:warehouse.Id location:location  user:user];
    }
}

-(void) loadShipmentCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    [rootController displayAlert:result.Message withTitle:@"Load Shipment"];
    if(result.Processed){
        [self getShipmentDetails:shipmentDetail.ShipmentId];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:true];
    }
}

-(void) getShipmentDetails: (NSInteger)shipmentId
{
    [rootController showLoading];
    EWHGetShipmentDetailsForLoadingRequest *request = [[EWHGetShipmentDetailsForLoadingRequest alloc] initWithCallbacks:self callback:@selector(getShipmentDetailsCallback:) errorCallback:@selector(errorGetShipmentDetailsCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
    [request getShipmentDetailsForLoadingRequest:shipmentId withAuthHash:rootController.user.AuthHash];
}

-(void) getShipmentDetailsCallback: (NSMutableArray *) items
{
    [rootController hideLoading];
    if(items.count > 0)
        [rootController popToViewController:rootController.shipmentDetailsView animated:YES];
    else
        [rootController popToViewController:rootController.selectShipmentView animated:YES];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Load Shipment"];
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {    
    if ([[segue identifier] isEqualToString:@"GetPartData"]) {
        EWHLoadShipmentGetPartDetailsController *getPartDataController = [segue destinationViewController];
        getPartDataController.shipmentDetail = sender;
        getPartDataController.shipment = shipment;
        getPartDataController.warehouse = warehouse;
        getPartDataController.location = location;
    }
    else if ([[segue identifier] isEqualToString:@"GetSerializedPartData"]) {
        EWHLoadShipmentGetSerializedPartDetailsController *getSerializedPartDataController = [segue destinationViewController];
        getSerializedPartDataController.shipmentDetail = sender;
        getSerializedPartDataController.shipment = shipment;
        getSerializedPartDataController.warehouse = warehouse;
        getSerializedPartDataController.location = location;
    }
}

@end
