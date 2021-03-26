//
//  EWHGetSerializedPartDetailsController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHGetSerializedPartDetailsController.h"

@implementation EWHGetSerializedPartDetailsController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;
@synthesize storagelocation;
@synthesize txtSerialNumber;

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
            title = NSLocalizedString(@"Pick Shipment Data", @"Pick Shipment Data");
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
-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height);
    
    NSLog(@"contentOffset is: %@", NSStringFromCGPoint(contentOffset));
    [self.tableView setContentOffset:contentOffset animated:YES];
    return YES;
}
-(BOOL) textFieldShouldReturn: (UITextField *) textField {
    [textField resignFirstResponder];
    if ([textField.superview.superview isKindOfClass:[UITableViewCell class]])
    {
        CGPoint buttonPosition = [textField convertPoint:CGPointZero
                                                  toView: self.tableView];
        NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:buttonPosition];
        
        [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:TRUE];
    }
    
    return YES;
}

- (IBAction)addPressed:(id)sender {
    [self addSerialNumber:txtSerialNumber.text];
    txtSerialNumber.text=@"";
}

-(IBAction) nextPressed: (id) sender
{
    if (shipment.isValidateLotNumber) {
        [self performSegueWithIdentifier:@"ScanLotNumber" sender:nil];
    } else {
        [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.shipment = shipment;
        scanLocationController.shipmentDetail = shipmentDetail;
        scanLocationController.warehouse = warehouse;
        scanLocationController.location = location;
        scanLocationController.storagelocation = storagelocation;
        scanLocationController.serialNumbers =[[numbers valueForKey:@"description"] componentsJoinedByString:@","];
    }    else if([[segue identifier] isEqualToString:@"ScanLotNumber"]) {
        EWHScanLotNumberController *scanLotNumber = [segue destinationViewController];
        scanLotNumber.shipmentDetail = shipmentDetail;
        scanLotNumber.shipment = shipment;
        scanLotNumber.warehouse = warehouse;
        scanLotNumber.location = location;
        scanLotNumber.storagelocation = storagelocation;
        scanLotNumber.serialNumbers =[[numbers valueForKey:@"description"] componentsJoinedByString:@","];
    }
}

@end
