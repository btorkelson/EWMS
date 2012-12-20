//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHScanItemController.h"

@implementation EWHScanItemController
{

}

@synthesize receipt;
@synthesize warehouse;

EWHRootViewController *rootController;
Linea *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.scanItemView = self;

    if(receipt.isContainer){
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
    linea = [Linea sharedDevice];
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
    return 1;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Receipt Info", @"Receipt Info");
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
                    cellText = receipt.ProgramName;
                    break;
                case 1:
                    cellTitle = @"Receipt";
                    cellText = receipt.ReceiptNumber;
                    break;
                case 2:
                    cellTitle = @"Received";
                    cellText = [EWHUtils.dateFormatter stringFromDate:receipt.ReceivedDate];
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

//- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
//    return 16;
//}

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
        [self getReceiptDetail:receipt.ReceiptId partNumber:barcode];
    }
    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self getReceiptDetail:receipt.ReceiptId partNumber:barcode];
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

-(void) getReceiptDetail: (NSInteger) receiptId partNumber: (NSString *) partNumber
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        //Z - remove for distribution
        //            partNumber = @"14091";
//        switch (receiptId) {
//            case 1071097:
//                partNumber = @"14090";
//                break;
//            case 1071098:
//                partNumber = @"14091";
//                break;
//            case 1071099:
//                partNumber = @"Part";
//                break;
//            case 1071100:
//                partNumber = @"Notepad bulk";
//                break;
//            case 1071101:
//                partNumber = @"Stapler";
//                break;
//            case 1071103:
//                partNumber = @"14093";
//                break;
//            case 1071104:
//                partNumber = @"14094";
//                break;
//            case 1071105:
//                partNumber = @"Scanner";
//                break;
//            case 1071106:
//                partNumber = @"Scanner";
//                break;
//            case 57243:
//                partNumber = @"46-264368G3";
//                break;
//            case 57669:
//                partNumber = @"1006";
//                break;
//            case 57670:
//                partNumber = @"1008";
//                break;
//            case 57667:
//                partNumber = @"2367470-5";
//                break;
//            case 57666:
//                partNumber = @"2367470-5";
//                break;
//            case 57662:
//                //partNumber = @"46-328206P115";
//                partNumber = @"5196402";
//                break;
//            default:
//                partNumber = @"14090";
//                break;
//        }
        if(receipt.isContainer){
            EWHGetReceiptDetailByContainerScanRequest *request = [[EWHGetReceiptDetailByContainerScanRequest alloc] initWithCallbacks:self callback:@selector(getReceiptDetailCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];

            [request getReceiptDetailByContainerScan:partNumber receiptId:receiptId withAuthHash:user.AuthHash];
        }
        else {
            EWHGetReceiptDetailByPartNumberRequest *request = [[EWHGetReceiptDetailByPartNumberRequest alloc] initWithCallbacks:self callback:@selector(getReceiptDetailCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getReceiptDetailByPartNumber:partNumber receiptId:receiptId withAuthHash:user.AuthHash];
        }
    }
}

-(void) getReceiptDetailCallback: (EWHReceiptDetail*) receiptDetail
{
    [rootController hideLoading];
    if(receiptDetail.ReceiptId == receipt.ReceiptId){
        if(receipt.isContainer)
            [self performSegueWithIdentifier:@"ScanLocation" sender:receiptDetail];
        else if(receiptDetail.IsSerialized)
            [self performSegueWithIdentifier:@"ShowSerializedPartDetails" sender:receiptDetail];
        else
            [self performSegueWithIdentifier:@"ShowPartDetails" sender:receiptDetail];
    }
    else {
        if(receipt.isContainer)
            [rootController displayAlert:@"Incorect container number" withTitle:@"Error"];
        else
            [rootController displayAlert:@"Incorect part number" withTitle:@"Error"];
    }
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:[NSString stringWithFormat:@"%d", error.code] withTitle:@"Scan Item"];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.receipt = receipt;
        scanLocationController.receiptDetails = sender;
        scanLocationController.warehouse = warehouse;
    }
    else if([[segue identifier] isEqualToString:@"ShowPartDetails"]){
        EWHPartDetailsController *itemDetailController = [segue destinationViewController];
        itemDetailController.receipt = receipt;
        itemDetailController.receiptDetails = sender;
        itemDetailController.warehouse = warehouse;
    }
    else if([[segue identifier] isEqualToString:@"ShowSerializedPartDetails"]){
        EWHSerializedPartDetailsController *itemDetailController = [segue destinationViewController];
        itemDetailController.receipt = receipt;
        itemDetailController.receiptDetails = sender;
        itemDetailController.warehouse = warehouse;
    }
}

@end
