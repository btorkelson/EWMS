//
//  EWHCreateReceiptControllerViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/31/14.
//
//

#import "EWHCreateReceiptController.h"



@implementation EWHCreateReceiptController

//@synthesize program;

EWHRootViewController *rootController;
DTDevices *linea;
@synthesize editingStartTime;
@synthesize editingStartTimeDelivery;

	EWHNewReceiptDataObject* theDataObject;
- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
	return theDataObject;

}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
//    txtComments.delegate = self;
	// Do any additional setup after loading the view.
    clReceiptDate.clipsToBounds = YES;
    clDeliveryDate.clipsToBounds = YES;
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
//	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    dtDeliveryDate.clipsToBounds = true;
    dtReceiptDate.clipsToBounds = true;
    
    if (theDataObject.ProjectName == nil || [theDataObject.ProjectName isEqual:@""]) {
    } else {
        txtProjectNumber.text = theDataObject.ProjectName;
    }
    if (theDataObject.vendor.Name == nil || [theDataObject.vendor.Name isEqual:@""]){
        lblVendor.text = @"None";
    } else {
        lblVendor.text = theDataObject.vendor.Name;
    }
    
    if (theDataObject.carrier.Name == nil || [theDataObject.carrier.Name  isEqual: @""]){
        lblCarrier.text = @"None";
    } else {
        lblCarrier.text = theDataObject.carrier.Name;
    }
    
    if (theDataObject.origin.Name == nil || [theDataObject.origin.Name isEqual:@""]){
        lblOrigin.text = @"None";
    } else {
        lblOrigin.text = theDataObject.origin.Name;
    }
    
    if (theDataObject.shipmethod.Name == nil || [theDataObject.shipmethod.Name isEqual:@""]){
        lblShipMethod.text = @"None";
    } else {
        lblShipMethod.text = theDataObject.shipmethod.Name;
    }
    
    txtComments.text = @"Comments";
    txtComments.textColor = [UIColor lightGrayColor];
    
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yyyy h:mm a"];
    lblReceiptDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dtReceiptDate.date]];
    lblDeliveryDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dtDeliveryDate.date]];
    
    linea = [DTDevices sharedDevice];
	[linea connect];
	[linea addDelegate:self];
	//update display according to current linea state
	[self connectionState:linea.connstate];
//    program = theDataObject.program;
//	theSlider.value = theDataObject.float1;
}

-(void)viewWillDisappear:(BOOL)animated
{
	[linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

-(void)connectionState:(int)state {
	switch (state) {
		case CONN_DISCONNECTED:
		case CONN_CONNECTING:
            //            [btnScanPart setHidden:true];
            break;
		case CONN_CONNECTED:
            [btnScan setHidden:false];
            //Z - remove in production
            //            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [txtCarrierTracking resignFirstResponder];
    [txtProjectNumber resignFirstResponder];
    [txtProjectSequence resignFirstResponder];
    [txtComments resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
	theDataObject.ProjectName = txtProjectNumber.text;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    if ([txtComments.text isEqualToString:@"Comments"]) {
        textView.text = @"";
        textView.textColor = [UIColor blackColor]; //optional
    }
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Comments";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

- (void)DateChange:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yyyy h:mm a"];
    lblReceiptDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dtReceiptDate.date]];
}


- (void)dateChangeDelivery:(id)sender {
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"M/d/yyyy h:mm a"];
    lblDeliveryDate.text = [NSString stringWithFormat:@"%@",[df stringFromDate:dtDeliveryDate.date]];
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0 && indexPath.row == 3) { // this is my picker cell
        
        
        if (editingStartTime) {
            return 162;
        } else {
            return 0;
        }
        
    } else if (indexPath.section == 5 && indexPath.row == 1) { // this is my picker cell
        
        
        if (editingStartTimeDelivery) {
            return 162;
        } else {
            return 0;
        }
        
    } else {
        return self.tableView.rowHeight;
    }
}

//-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    UITableViewCell* cell = [tableView cellForRowAtIndexPath:indexPath];
//    [tableView beginUpdates];
//    if (cell == self.dateTitleCell){
//        self.dateOpen = !self.isDateOpen;
//    }
//    [tableView reloadData];
//    [self.tableView endUpdates];
//}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    
    if ([text isEqualToString:@"\n"]) {
        
        [textView resignFirstResponder];
        // Return FALSE so that the final '\n' character doesn't get added
        return NO;
    }
    // For any other character return TRUE so that the text gets added to the view
    return YES;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            if (theDataObject.program.IsLateReceipt == NO) {
                return 2;
            } else {
                return 4;
            }
        case 1:
            return 2;
        case 2:
            return 2;
        case 3:
            if (theDataObject.program.IsCaptureOrigin == NO) {
                return 0;
            } else {
                return 1;
            }
        case 4:
            if (theDataObject.program.IsReceiptToOrder == NO) {
                return 0;
            } else {
                return 1;
            }
        case 5:
            if (theDataObject.program.IsReceiptToOrder == NO) {
                return 0;
            } else {
                return 2;
            }
        case 6:
            return 1;
        default:
            
            return 0;
    }
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NSLog([NSString stringWithFormat:@"{\"section\":%d,\"row\":%d}", indexPath.section, indexPath.row]);
    if (indexPath.section == 0 && indexPath.row == 2) { // this is my date cell above the picker cell
        
        editingStartTime = !editingStartTime;
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    } else if (indexPath.section == 5 && indexPath.row == 0) { // this is my date cell above the picker cell
        
        editingStartTimeDelivery = !editingStartTimeDelivery;
        [UIView animateWithDuration:.4 animations:^{
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:5]] withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView reloadData];
        }];
    }
    switch (indexPath.section) {
        case 1:
            [self performSegueWithIdentifier:@"SelectOptions" sender:@"Vendor"];
            break;
        case 2:
            [self performSegueWithIdentifier:@"SelectOptions" sender:@"Carrier"];
            break;
        case 3:
            [self performSegueWithIdentifier:@"SelectOptions" sender:@"Origin"];
            break;
        case 4:
            [self performSegueWithIdentifier:@"SelectOptions" sender:@"Ship Method"];
            break;
        default:
            
            break;
    }
    
}

- (IBAction)doneButtonPressed:(id)sender {
    [rootController showLoading];
    
    if (theDataObject.program.IsReceiptToOrder == YES && !(theDataObject.shipmethod.ShipMethodId)) {
    
        [rootController hideLoading];
        [rootController displayAlert:@"Ship Method is required" withTitle:@"Error"];
    } else {
        
        EWHUser *user = rootController.user;
        
        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
        theDataObject.lastDestination = nil;
        theDataObject.DeliveryDateTime = dtDeliveryDate.date;
        
        EWHReceipt* receipt = [EWHReceipt alloc];
        if (theDataObject.program.IsLateReceipt) {
            receipt.ReceivedDate = dtReceiptDate.date;
        } else {
            receipt.ReceivedDate = [NSDate date];
        }
        receipt.isContainer = false;
        receipt.WarehouseId = theDataObject.warehouse.Id;
        receipt.ProgramName = theDataObject.program.Name;
        receipt.ProgramId = theDataObject.program.ProgramId;
        receipt.ProjectNumber = txtProjectNumber.text;
        receipt.ProjectSequenceNumber = txtProjectSequence.text;
        receipt.CarrierId = theDataObject.carrier.CarrierId;
        receipt.CarrierTrackingNumber = txtCarrierTracking.text;
        receipt.VendorId = theDataObject.vendor.VendorId;
        receipt.OriginId = theDataObject.origin.OriginId;
        receipt.ShippingMethod = theDataObject.shipmethod.ShipMethodId;
//        receipt.DeliveryDateTime = [NSDate date];
        receipt.Comments = txtComments.text;
    

        if(user != nil){
            
                EWHAddReceiptHeader
                *request = [[EWHAddReceiptHeader alloc] initWithCallbacks:self callback:@selector(addReceiptCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
                //NSLog(hub);
            
                [request addReceiptHeader:receipt user:user];
        }
    
    }
}



-(void) addReceiptCallback: (EWHResponse *) result
{
    [rootController hideLoading];
//    [rootController displayAlert:result.Message withTitle:@"Result"];
    if (result.Id != -1) {
        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
        theDataObject.ReceiptId = result.Id;
        theDataObject.ReceiptNumber = result.Number;
        
        [self performSegueWithIdentifier:@"ScanPart" sender:nil];
    } else {
        [rootController displayAlert:result.Message withTitle:@"Error"];
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

-(IBAction)scanPressed:(id)sender;
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


-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtCarrierTracking.text= barcode;
    }
    //    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtCarrierTracking.text= barcode;
    }
    //    [self updateBattery];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SelectOptions"]) {

        EWHReceiptOptionsViewController *selectOptionsController = [segue destinationViewController];
        selectOptionsController.entity = sender;
    } else if ([[segue identifier] isEqualToString:@"ScanPart"]) {
        EWHScanPartController *selectOptionsController = [segue destinationViewController];
//        selectOptionsController.entity = sender;
    }
}




@end
