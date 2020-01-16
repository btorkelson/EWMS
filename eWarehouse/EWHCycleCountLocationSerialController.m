//
//  EWHCycleCountLocationSerialController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHCycleCountLocationSerialController.h"

@interface EWHCycleCountLocationSerialController ()

@end

@implementation EWHCycleCountLocationSerialController

EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;
NSMutableArray *serials;
@synthesize location;
@synthesize catalog;
@synthesize txtInputSerial;

- (void)viewDidLoad {
    [super viewDidLoad];
    serials = [[NSMutableArray alloc] init];
    [self loadSerials];
    //    [self updateInterface];
    
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
    
    EWHUser *user = rootController.user;
    if (user.EWAdmin) {
    } else {
//        [viewSerialTextbox setHidden:YES];
    }
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title;
    switch (section) {
        case 0:
            title = NSLocalizedString(@"PART INFO", @"PART INFO");
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
            return [serials count];
            break;
        default:
            return 0;
            break;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = nil;
    
    
    // Get the object to display and set the value in the cell.
    
    
    
    NSString* serial = nil;
    NSString *cellText = nil;
    NSString *cellTitle = nil;
    
    switch (indexPath.section) {
        case 0:
            CellIdentifier = @"InfoCell";
            switch (indexPath.row) {
                case 0:
                    cellTitle=@"Part Number";
                    cellText=catalog.ItemNumber;
                    break;
                case 1:
                    cellTitle=@"Description";
//                    cellText=catalog.Description;
                    break;
                case 2:
                    cellTitle=@"Bulk/Serial";
                    cellText=@"Serial";
                    break;
                default:
                    break;
            }
            break;
        case 1:
            CellIdentifier = @"SerialCell";
            serial = [serials objectAtIndex:indexPath.row];
            cellText = serial;
            cellTitle = serial;
            break;
        default:
            break;
    }
    
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.text=cellTitle;
    cell.detailTextLabel.text=cellText;
    return cell;
}

- (void)loadSerials
{
    //    lblPartNumber.text = catalog.ItemNumber;
    //    lblDescription.text = catalog.Description;
    //    lblBulk.text = @"Serial";
    if (catalog.ScannedSerials) {
        if ([catalog.ScannedSerials count]>0) {
            serials = catalog.ScannedSerials;
            [self.tableView reloadData];
        }
    }
    
}

- (void)addSerial:(NSString *)serial
{
    [serials addObject:serial];
    [self.tableView reloadData];
}

-(void)connectionState:(int)state {
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            isScannerConnected = NO;
            break;
        case CONN_CONNECTED:
            isScannerConnected = YES;
            //Z - remove in production
            //            [linea setScanBeep:false volume:0 beepData:nil length:0];
            break;
    }
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        //        [self stopScan];
        [self addSerial:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        //        [self stopScan];
        [self addSerial:barcode];
    }
}

- (BOOL) tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    return indexPath.section == 1;
}

- (void) tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    [serials removeObjectAtIndex:indexPath.row];
    [self.tableView reloadData];
    if(isScannerConnected){
        linea=[DTDevices sharedDevice];
        [linea connect];
        [linea addDelegate:self];
    }
}

- (IBAction)nextPressed:(id)sender {
    //    [self addSerial:@"abcd"];
    if ([serials count]==0) {
        [rootController displayAlert:@"No serial numbers were scanned" withTitle:@"Error"];
    } else {
//        [self performSegueWithIdentifier:@"TransferNewLocation" sender:nil];
        
        catalog.QuantityScanned=[serials count];
        catalog.ScannedSerials=serials;
        
        [self.navigationController popViewControllerAnimated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TransferNewLocation"]) {
//        EWHTransferScanNewLocation *selectReceiptController = [segue destinationViewController];
//        selectReceiptController.warehouse = warehouse;
//        selectReceiptController.location= location;
//        selectReceiptController.catalog=catalog;
//        selectReceiptController.quantity=1;
//        selectReceiptController.serials=serials;
    }
}

- (IBAction)buttonAddClicked:(id)sender {
    [self addSerial:txtInputSerial.text];
    txtInputSerial.text=@"";
    [self textFieldShouldBeginEditing:txtInputSerial];
}

-(BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    CGPoint pointInTable = [textField.superview convertPoint:textField.frame.origin toView:self.tableView];
    CGPoint contentOffset = self.tableView.contentOffset;
    
    //    contentOffset.y = (textField.inputAccessoryView.frame.size.height - 100);
    int w = textField.inputAccessoryView.frame.size.height;
    contentOffset.y = (pointInTable.y - textField.inputAccessoryView.frame.size.height -250);
    
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

@end
