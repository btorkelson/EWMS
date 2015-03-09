//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHScanLocationController.h"

@implementation EWHScanLocationController
{

}

@synthesize receipt;
@synthesize receiptDetails;
@synthesize serialNumbers;
@synthesize quantity;
@synthesize warehouse;







EWHRootViewController *rootController;
DTDevices *linea;
NSString *location;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    
//    if(receipt != nil){
//        receiptInfo.text = [[NSString alloc] initWithFormat:@"%@\n%@", receipt.ReceiptNumber, receipt.ReceivedDate];
//    }
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
    if(receipt.isContainer)
        return 1;
    else
        return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"Receipt Info", @"Receipt Info");
            break;
        case 1:
            title = NSLocalizedString(@"Put Away Data", @"Put Away Data");
            break;
        default:
            break;
    }
    return title;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            if([receiptDetails.SuggestedLocations length] > 0)            
                return 3;
            else
                return 2;
            break;
        case 1:
            if(receiptDetails.IsSerialized)
                return [serialNumbers count];
            else
                return 1;
            break;
        default:
            return 0;
            break;
    }
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
                    cellTitle = @"Receipt#";
                    cellText = receipt.ReceiptNumber;
                    break;
                case 1:
                    if(receipt.isContainer){
                        cellTitle = @"Container#";
                        cellText = receiptDetails.Number;
                    }
                    else{
                        cellTitle = @"Part#";
                        cellText = receiptDetails.PartNumber;
                    }
                    break;
                case 2:
                    cellTitle = @"Locations";
                    cellText = receiptDetails.SuggestedLocations;
                    break;
                default:
                    break;
            }
            break;
        case 1:
            if(receiptDetails.IsSerialized){
                cellTitle = @"Serial#";
                cellText = [serialNumbers objectAtIndex:indexPath.row];
            }
            else {
                switch (indexPath.row) {
                    case 0:
                        cellTitle = @"Quantity";
                        cellText = [NSString stringWithFormat:@"%d", quantity];
                        break;
                    default:
                        break;
                }
            }
        default:
            break;
    }
    
//    CGRect frame = cell.textLabel.frame;
//    frame.size.width += 100;
//    cell.textLabel.frame = frame;
    
    cell.textLabel.text = cellTitle;
    cell.detailTextLabel.text = cellText;
//    UITableViewCell *title = (UITableViewCell *)[cell.contentView viewWithTag:0];
//    title.textLabel.text = cellTitle;
//
//    UITableViewCell *text = (UITableViewCell *)[cell.contentView viewWithTag:1];
//    text.textLabel.text = cellText;
    
//    cell.textLabel.text = cellText;

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
//    [locationInfo setText:[NSString stringWithFormat:@"Location: %@", barcode]];
//    [self.view setNeedsDisplay];
//    [self performSegueWithIdentifier:@"ScanItems" sender:barcode];
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateLocation:barcode];
    }
    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
//    [locationInfo setText:[NSString stringWithFormat:@"Location: %@", barcode]];
//    [self.view setNeedsDisplay];
//    [self performSegueWithIdentifier:@"ScanItems" sender:barcode];
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateLocation:barcode];
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

-(void) validateLocation: (NSString *) barcode
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHIsWarehouseLocationValidRequest *request = [[EWHIsWarehouseLocationValidRequest alloc] initWithCallbacks:self callback:@selector(isWarehouseLocationValidCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //Z - remove for distribution
//        barcode = @"Storage";
//        barcode = @"D82";
//        barcode = @"B81";
        location = barcode;
        [request isWarehouseLocationValid:warehouse.Id locationName:barcode withAuthHash:user.AuthHash];
    }
}

-(void) isWarehouseLocationValidCallback: (NSNumber*) isValid
{
    [rootController hideLoading];
    BOOL valid = [isValid boolValue];
    if(valid){
        if(receipt.isContainer)
            [self putAwayContainerItem];
        else if(receiptDetails.IsSerialized)
            [self putAwaySerializedItem];
        else
            [self putAwayItem];
    }
    else {
        [rootController displayAlert:@"Invalid location" withTitle:@"Location"];
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

-(void) putAwayContainerItem
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHPutAwayContainerRequest *request = [[EWHPutAwayContainerRequest alloc] initWithCallbacks:self callback:@selector(putAwayCallback:) errorCallback:@selector(putAwayErrorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request putAwayContainer:receiptDetails location:location user:user];
    }
}

-(void) putAwayItem
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHPutAwayPartRequest *request = [[EWHPutAwayPartRequest alloc] initWithCallbacks:self callback:@selector(putAwayCallback:) errorCallback:@selector(putAwayErrorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request putAwayPart:receiptDetails location:location quantity:quantity user:user];
    }
}

-(void) putAwaySerializedItem
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        NSString *numbers = [[serialNumbers valueForKey:@"description"] componentsJoinedByString:@","];
        //Z - remove in production
        //        switch (receiptId) {
        //            case 1071101:
        //                serialNumbers = @"aaa,bbb,ccc,ddd";
        //                break;
        //            case 1071105:
        //                serialNumbers = @"qqq,www,eee,rrr";
        //                break;
        //            case 1071106:
        //                serialNumbers = @"pppp,oooo,iiii,uuuu";
        //                break;
        //            default:
        //                break;
        //        }
        EWHPutAwaySerializedPartRequest *request = [[EWHPutAwaySerializedPartRequest alloc] initWithCallbacks:self callback:@selector(putAwayCallback:) errorCallback:@selector(putAwayErrorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request putAwayPart:receiptDetails location:location serialNumbers:numbers user:user];
    }
}

-(void) putAwayCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    [rootController displayAlert:result.Message withTitle:@"Result"];
    if(result.Processed){
        [self getReceiptDetails:receipt.ReceiptId];
    }
}

-(void) getReceiptDetails: (NSInteger)receiptId
{
    [rootController showLoading];
    EWHGetReceiptDetailsRequest *request = [[EWHGetReceiptDetailsRequest alloc] initWithCallbacks:self callback:@selector(getReceiptDetailsCallback:) errorCallback:@selector(errorGetReceiptDetailsCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
    [request getReceiptDetails:receiptId withAuthHash:rootController.user.AuthHash];
}

-(void) getReceiptDetailsCallback: (NSMutableArray *) items
{
    [rootController hideLoading];
    if(items.count > 0)
        [rootController popToViewController:rootController.scanItemView animated:YES];
    else
        [rootController popToViewController:rootController.selectReceiptView animated:YES];
}

-(void) putAwayErrorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Put away"];
    [self.navigationItem.rightBarButtonItem setEnabled:true];
}

-(void) errorGetReceiptDetailsCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController popToViewController:rootController.selectReceiptView animated:YES];
}

@end
