//
//  EWHScanSerialNumbersViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/18/15.
//
//

#import "EWHScanSerialNumbersViewController.h"

@interface EWHScanSerialNumbersViewController ()

@end

@implementation EWHScanSerialNumbersViewController

@synthesize SerialNumbers;
@synthesize catalog;
@synthesize location;
@synthesize txtSerial;


EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rootController = (EWHRootViewController *)self.navigationController;
    
    isScannerConnected = NO;
    SerialNumbers = [[NSMutableArray alloc] init];
    
    //    [backButton release];
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableReceiptView {
    if([SerialNumbers count] > 0)
        return 1;
    else
        return 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    switch (section) {
        case 0:
            return [SerialNumbers count];
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
        case 0: {
            cellText = [SerialNumbers objectAtIndex:indexPath.row];
            
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
    [SerialNumbers removeObjectAtIndex:indexPath.row];
    
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
    //	NSError *error = nil;
    //    if(isScannerConnected) {
    //        [linea startScan:&error];
    //        if(error != nil)
    //        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
    //
    //    } else {
    [self addSerial:txtSerial.text];

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
                [self addSerial:barcode];        
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        
                [self addSerial:barcode];
        
    }
}


-(void) addSerial: (NSString *) serialNumber
{
    if (catalog.IsSerial) {
        if (serialNumber.length>0) {
            [SerialNumbers addObject:serialNumber];
            
            
            
            [self.tableView reloadData];
            int offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
            if(offset > 0)
                [self.tableView setContentOffset:CGPointMake(0, offset) animated:TRUE];
        } else {
            [rootController displayAlert:@"Serial Number cannot be blank" withTitle:@"Error"];
        }
    } else {
        [SerialNumbers addObject:serialNumber];
        
        
        
        [self.tableView reloadData];
        int offset = self.tableView.contentSize.height - self.tableView.bounds.size.height;
        if(offset > 0)
            [self.tableView setContentOffset:CGPointMake(0, offset) animated:TRUE];
    }
    
}

- (IBAction)nextPressed:(id)sender {
    if (catalog.IsSerial) {
        if (SerialNumbers.count > 0) {
            [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:nil];
        } else {
            [rootController displayAlert:@"Serial Number is required for serialized part" withTitle:@"Error"];
        }
    } else {
        [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:nil];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
    if ([[segue identifier] isEqualToString:@"ReceiptItemConfirm"]) {
        EWHReceiptItemConfirmationViewController *createReceiptController = [segue destinationViewController];
        createReceiptController.catalog = catalog;
        createReceiptController.location = location;
        createReceiptController.SerialNumbers = SerialNumbers;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
    
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}


@end
