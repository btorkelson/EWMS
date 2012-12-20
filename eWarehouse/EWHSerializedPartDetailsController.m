//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSerializedPartDetailsController.h"

@implementation EWHSerializedPartDetailsController
{

}

@synthesize receipt;
@synthesize receiptDetails;
@synthesize warehouse;

EWHRootViewController *rootController;
Linea *linea;
bool isScannerConnected;
NSMutableArray *numbers;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    numbers = [[NSMutableArray alloc] init];
    
    isScannerConnected = NO;
    
    [btnScanSerialNumber setTitle:@"Not Connected" forState:UIControlStateDisabled];
    if (numbers.count == receiptDetails.Quantity) {
        [btnScanSerialNumber setHidden:true];
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    linea=[Linea sharedDevice];
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
    if([numbers count] > 0)
        return 2;
    else
        return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Receipt Info", @"Receipt Info");
            break;
        case 1:
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
                    cellTitle = @"Receipt#";
                    cellText = receipt.ReceiptNumber;
                    break;
                case 1:
                    cellTitle = @"Part#";
                    cellText = receiptDetails.PartNumber;
                    break;
                case 2:
                    cellTitle = @"Quantity";
                    cellText = [NSString stringWithFormat:@"%d", receiptDetails.Quantity];
                    break;
//                case 3:
//                    cellTitle = @"Location";
//                    cellText = receiptDetails.LocationName;
//                    break;
                default:
                    break;
            }
            break;
        case 1:
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
    return indexPath.section == 1;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [numbers removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    if(isScannerConnected){
        linea=[Linea sharedDevice];
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
            if(numbers.count < receiptDetails.Quantity){
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
    //Z - remove in production
//    serialNumber = @"123456";
    if(![numbers containsObject:serialNumber]){
        [numbers addObject:serialNumber];
        [self.tableView reloadData];
        if (numbers.count == receiptDetails.Quantity) {
            [linea removeDelegate:self];
            [linea disconnect];
            linea = nil;
            [btnScanSerialNumber setHidden:true];
        }
        int offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if(offset > 0)
            [self.tableView setContentOffset:CGPointMake(0, offset) animated:TRUE];
        //        [self.tableView convertRect:btnScanSerialNumber.bounds fromView:self.tableView];
        //        [self.tableView scrollRectToVisible:btnScanSerialNumber.bounds animated:YES];
        //        [self.tableView scrollRectToVisible:CGRectMake(0, self.tableView.contentSize.height + 120, 320, 44) animated:TRUE];
        //        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:([numbers count] -1) inSection:2] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        //        [self.view setNeedsDisplay];
    }
    else
        [rootController displayAlert:@"Duplicate serial number" withTitle:@"Error"];
}

-(IBAction) nextPressed: (id) sender
{
    if([numbers count] > 0)
        [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
    else
        [rootController displayAlert:@"Please, scan at least one serial number" withTitle:@"Error"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.receipt = receipt;
        scanLocationController.receiptDetails = receiptDetails;
        scanLocationController.serialNumbers = numbers;
        scanLocationController.warehouse = warehouse;
    }
    
}
@end
