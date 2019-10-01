//
//  EWHSortScanPartsController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 8/29/19.
//

#import "EWHSortScanPartsController.h"

@interface EWHSortScanPartsController ()

@end

@implementation EWHSortScanPartsController

@synthesize partNumbers;
@synthesize warehouse;
@synthesize sortJob;
@synthesize txtPartNumber;

EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    partNumbers = [[NSMutableArray alloc] init];
    rootController = (EWHRootViewController *)self.navigationController;
    
    isScannerConnected = NO;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableReceiptView {
    if([partNumbers count] > 0)
        return 1;
    else
        return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [partNumbers count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Set the text in the cell for the section/row.
    
    NSString *cellTitle = nil;
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0: {
            cellText = [partNumbers objectAtIndex:indexPath.row];
            
        }
        default:
            break;
    }
    
    cell.textLabel.text = cellText;
    
    return cell;
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 0;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [partNumbers removeObjectAtIndex:indexPath.row];
    
    [self.tableView reloadData];
    if(isScannerConnected){
        linea=[DTDevices sharedDevice];
        [linea connect];
        [linea addDelegate:self];
        //        [btnScanSerialNumber setHidden:false];
    }
}

-(IBAction)scanItemDown:(id)sender;
{
    //    NSError *error = nil;
    //    if(isScannerConnected) {
    //        [linea startScan:&error];
    //        if(error != nil)
    //        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
    //
    //    } else {
    
    //    }
    
}

-(IBAction)scanItemUp:(id)sender;
{
    //    if(isScannerConnected) {
    //        [self stopScan];
    //    }
    
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
            //            [btnScanSerialNumber setHidden:true];
            //            [scannerMsg setHidden:false];
            isScannerConnected = NO;
            break;
        case CONN_CONNECTED:
            //            if(numbers.count < receiptDetails.Quantity){
            //                [btnScanSerialNumber setHidden:false];
            //            }
            //            [scannerMsg setHidden:true];
            isScannerConnected = YES;
            //Z - remove in production
            //            [linea setScanBeep:false volume:1 beepData:nil length:1];
            break;
    }
}


-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self addPartNumber:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        
        [self addPartNumber:barcode];
        
    }
}


-(void) addPartNumber: (NSString *) serialNumber
{
    
        [partNumbers addObject:serialNumber];
        
        
        
        [self.tableView reloadData];
        int offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if(offset > 0)
            [self.tableView setContentOffset:CGPointMake(0, offset) animated:TRUE];
    
    
}

- (IBAction)submitPressed:(id)sender {
    
    [self addPartNumber:txtPartNumber.text];
}
- (IBAction)finishPressed:(id)sender {
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    if ([partNumbers count]>0) {
    if(user != nil){
        EWHAddSortJobDetails
        *request = [[EWHAddSortJobDetails alloc] initWithCallbacks:self callback:@selector(getSortJobDetailsCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        [request addSortJobDetails:sortJob.SortJobId partNumbers:partNumbers user:user];
        
        
        //        [request ad:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:_location.Id catalogId:_catalog.CatalogId quantity:1 IsBulk:_catalog.IsBulk itemScan:nil destinationId:destination shipMethodId:theDataObject.shipmethod.ShipMethodId user:user];
    }
    } else {
        [rootController hideLoading];
        [rootController displayAlert:@"No part number were scanned" withTitle:@"Error"];
    }
}


-(void) getSortJobDetailsCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    if (results.Processed == 1) {
        [rootController displayAlert:results.Message withTitle:@"Finished"];
       [rootController popToViewController:rootController.selectActionView animated:YES];
    } else {
        [rootController displayAlert:results.Message withTitle:@"Error"];
    }
    //    destinations = results;
    //    [rootController displayAlert:results.Message withTitle:@"Result"];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)nextPressed:(id)sender {
    
            [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:nil];
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ReceiptItemConfirm"]) {
//        EWHReceiptItemConfirmationViewController *createReceiptController = [segue destinationViewController];
//        createReceiptController.catalog = catalog;
//        createReceiptController.location = location;
//        createReceiptController.SerialNumbers = SerialNumbers;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}



@end
