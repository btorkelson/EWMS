//
//  EWHLoadShipmentGetSerializedPartDetailsController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoadShipmentGetSerializedPartDetailsController.h"

@implementation EWHLoadShipmentGetSerializedPartDetailsController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;
@synthesize btnLoad;

EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;
NSMutableArray *numbers;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    numbers = [[NSMutableArray alloc] init];
    
    [btnScanSerialNumber setTitle:@"Not Connected" forState:UIControlStateDisabled];
    if (numbers.count == shipmentDetail.Quantity) {
        [btnScanSerialNumber setHidden:true];
    }    
}

- (void)viewWillAppear:(BOOL)animated
{
    linea=[DTDevices sharedDevice];
	[linea connect];
	[linea addDelegate:self];
	//update display according to current linea state
	[self connectionState:linea.connstate];
    [self.tableView setEditing:YES];
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
    if([numbers count] > 0)
        return 3;
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Shipment Info", @"Shipment Info");
            break;
        case 1:
            title = NSLocalizedString(@"Load Shipment Data", @"Load Shipment Data");
        case 2:
            title = NSLocalizedString(@"Serial Numbers", @"Serial Numbers");
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
            return 2;
            break;
        case 2:
            return [numbers count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"TableCell";
	
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
                    cellTitle = @"Name";
                    cellText = shipmentDetail.PartNumber;
                    break;
                case 1:
                    cellTitle = @"Quantity";
                    cellText = [NSString stringWithFormat:@"%d", shipmentDetail.Quantity];
                    break;
               default:
                    break;
            }
            break;
        case 2:
            cellTitle = @"Serial#";
            cellText = [numbers objectAtIndex:indexPath.row];
        default:
            break;
    }
    
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = cellText;
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 2;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [numbers removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    if(isScannerConnected){
        linea=[DTDevices sharedDevice];
        [linea connect];
        [linea addDelegate:self];
        [btnScanSerialNumber setHidden:false];
    }
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
            [btnScanSerialNumber setHidden:true];
            [scannerMsg setHidden:false];
            isScannerConnected = NO;
			break;
		case CONN_CONNECTED:
            if(numbers.count < shipmentDetail.Quantity){
                [btnScanSerialNumber setHidden:false];
            }
            [scannerMsg setHidden:true];
            isScannerConnected = YES;
            //Z - remove in production
//            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self addSerialNumber:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self addSerialNumber:barcode];
    }
}

-(void) addSerialNumber:(NSString*) serialNumber {
    if(![numbers containsObject:serialNumber]){
        [numbers addObject:serialNumber];
        [self.tableView reloadData];
        if (numbers.count == shipmentDetail.Quantity) {
            [linea removeDelegate:self];
            [linea disconnect];
            linea = nil;
            [btnScanSerialNumber setHidden:true];
        }
        int offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if(offset > 0)
            [self.tableView setContentOffset:CGPointMake(0, offset) animated:TRUE];
    }
    else
        [rootController displayAlert:@"Duplicate serial number" withTitle:@"Error"];
}

-(IBAction) loadPressed: (id) sender
{
    btnLoad.enabled=false;
    NSString *serialNumbers = [[numbers valueForKey:@"description"] componentsJoinedByString:@","]; 
    //Z - remove for distribution
//    switch (shipment.ShipmentId) {
//        case 349930:
//            serialNumbers = @"sc1,sc2";
//            break;
//        default:
//            break;
//    }
    [self loadSerializedPart:serialNumbers];
}

-(void) loadSerializedPart:(NSString *)serialNumbers
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHLoadSerializedItemRequest *request = [[EWHLoadSerializedItemRequest alloc] initWithCallbacks:self callback:@selector(loadShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request loadItem:shipmentDetail warehouse:warehouse.Id location:location serialNumbers:serialNumbers user:user];
    }
}

-(void) loadShipmentCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    [rootController displayAlert:result.Message withTitle:@"Load Shipment"];
    if(result.Processed){
//        [self getShipmentDetails:shipmentDetail.ShipmentId];
        [rootController popToViewController:rootController.shipmentDetailsView animated:YES];
    }
    else {
        btnLoad.enabled=true;
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

@end
