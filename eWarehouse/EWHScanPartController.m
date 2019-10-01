//
//  EWHScanPartController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHScanPartController.h"

@interface EWHScanPartController ()

@end

@implementation EWHScanPartController

@synthesize catalogs;


EWHRootViewController *rootController;
DTDevices *linea;
EWHNewReceiptDataObject* theDataObject;



- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
//
	theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
	return theDataObject;
    
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.selectItemforReceiptView = self;
    self.navigationItem.hidesBackButton = YES;
//    rootController.scan = self;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    txtPartNumber.text = @"";
    linea = [DTDevices sharedDevice];
	[linea connect];
	[linea addDelegate:self];
	//update display according to current linea state
	[self connectionState:linea.connstate];
    
    
    //catalogs = [NSArray arrayWithObjects:@"Batteries",@"Bay",@"Coil",@"Crate",@"Gaylord",@"Other (unit)",@"Oversized-cwt (extra eqpt)",@"Oversized-cwt (extra labor)",@"Pallet",@"Piece",@"Pole (cwt)",@"Reel-Large",@"Reel-Small/Pallet",@"Scrap Gaylord/Pallet",@"Spool", nil];
    if (theDataObject.ScanPartNumber==0) {
        [self getCatalog:nil];
        txtPartNumber.hidden=true;
    }else {
            
        pvPicker.hidden=true;
    }
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
            [btnScanPart setHidden:false];
            //Z - remove in production
            //            [linea setScanBeep:false volume:0 beepData:nil length:0];
			break;
	}
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[textField resignFirstResponder];
	return TRUE;
}


- (void)textFieldDidEndEditing:(UITextField *)textField
{
//	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
//	theDataObject.ProjectName = txtProjectNumber.text;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"TableCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    NSString *cellTitle = nil;
    NSString *cellText = nil;
    
    switch (indexPath.section) {
        case 0:
            switch (indexPath.row) {
                case 0:
                    cellTitle = @"Program";
                    cellText = theDataObject.program.Name;
                    break;
                case 1:
                    cellTitle = @"Receipt";
                    cellText = theDataObject.ReceiptNumber;
                    break;
                case 2:
                    cellTitle = @"Project";
                    cellText = theDataObject.ProjectName;
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


-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [catalogs count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    EWHCatalog *catalog = [catalogs objectAtIndex:row];
    //    destination = [destinationType.Destinations objectAtIndex:indexPath.row];
    return catalog.ItemNumber;
}




-(IBAction)scanPartPressed:(id)sender;
{
    
        if (theDataObject.ScanPartNumber == 0) {
            NSInteger row = [pvPicker selectedRowInComponent:0];
            EWHCatalog *catalog = [catalogs objectAtIndex:(NSUInteger)row];
            [self validateCatalog:catalog.ItemNumber];
        } else {
            if (txtPartNumber.text) {
                [self validateCatalog:txtPartNumber.text];
            }
        
    }
    
//	NSError *error = nil;
//    [self validateCatalog:@"2D12AAA"];
//	[linea startScan:&error];
//    if(error != nil)
//        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
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
        txtPartNumber.text = barcode;
        [self validateCatalog:barcode];
    }
//    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtPartNumber.text = barcode;
        [self validateCatalog:barcode];
    }
//    [self updateBattery];
}

-(void) validateCatalog: (NSString *) partNumber
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    //	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        
        EWHGetCatalogByItemNumber *request = [[EWHGetCatalogByItemNumber alloc] initWithCallbacks:self callback:@selector(validateCatalogCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        
        [request getCatalogByItemNumber:theDataObject.program.ProgramId itemNumber:partNumber withAuthHash:user.AuthHash];
    }
}

-(void) validateCatalogCallback: (EWHCatalog*) catalog
{
    [rootController hideLoading];
    if (catalog.CatalogId != -1) {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"UnitOfMeasureType == 2"];
        NSArray *matches = [catalog.UOMs filteredArrayUsingPredicate:resultPredicate];
        //        [catalog.UOMs setkind:]
        if ([matches count]>0) {
            [self performSegueWithIdentifier:@"GetUOMWeight" sender:catalog];
        } else {
            
            if (theDataObject.PromptInventoryType) {
                [self performSegueWithIdentifier:@"SelectInventoryType" sender:catalog];
            } else {
                catalog.InventoryTypeId = theDataObject.inventorytypeId;
                if ([catalog.CustomAttributeCatalogs count]>0) {
                    [self performSegueWithIdentifier:@"GetCustomAttributeCatalog" sender:catalog];
                } else {
                    
                    [self performSegueWithIdentifier:@"SelectLocation" sender:catalog];
                }
            }
        }
    } else {
        [rootController displayAlert:@"Part Number not found" withTitle:@"Error"];
    }
    
}

-(void) getCatalog:(id)sender
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    //	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        
        EWHGetCatalogByProgram *request = [[EWHGetCatalogByProgram alloc] initWithCallbacks:self callback:@selector(getCatalogCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        
        //[request getCatalogByItemNumber:theDataObject.program.ProgramId itemNumber:partNumber withAuthHash:user.AuthHash];
        [request getCatalogByProgram:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
    }
}

-(void) getCatalogCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    catalogs = results;
    //[self.p reloadData];
    [pvPicker reloadAllComponents];
    
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

- (IBAction)finishedPressed:(id)sender {
    
//    UIAlertView *alert = [[UIAlertView alloc]initWithTitle: @"Print Labels?"
//                                                   message: @"Would you like to add labels for this receipt to the print queue?"
//                                                  delegate: self
//                                         cancelButtonTitle:@"Yes"
//                                         otherButtonTitles:@"No",nil];
//
//
//    [alert show];
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    
    
    
    [rootController popToViewController:rootController.selectActionView animated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
        EWHSelectStorageLocationViewController *selectLocationController = [segue destinationViewController];
                selectLocationController.catalog = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    } else if ([[segue identifier] isEqualToString:@"GetCustomAttributeCatalog"]) {
        
        EWHGetCustomAttributeCatalogViewController *getCACscontroller = [segue destinationViewController];
        getCACscontroller.catalog = sender;
        getCACscontroller.CAindex = 0;
    }else if ([[segue identifier] isEqualToString:@"SelectInventoryType"]) {
        
        EWHSelectInventoryTypeViewController *getITscontroller = [segue destinationViewController];
        getITscontroller.catalog = sender;
    }else if ([[segue identifier] isEqualToString:@"GetUOMWeight"]) {
        
        EWHGetUOMWeightViewController *getUOMcontroller = [segue destinationViewController];
        getUOMcontroller.catalog = sender;
    }

}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    
    
//    if (theDataObject.warehouse.binLocations.count > 0) {
    
    if (buttonIndex == 0)
    {
        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
        [self addLabelstoQueue:theDataObject.ReceiptId ];
    }
    else
    {
        
    }
    //    NSMutableArray* initChecklist;
}

-(void) addLabelstoQueue: (NSInteger) receiptId
{
    
    EWHUser *user = rootController.user;
    
    //	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        
        EWHAddLabelstoPrintQueue *request = [[EWHAddLabelstoPrintQueue alloc] initWithCallbacks:self callback:@selector(endLabels:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        
        [request AddLabelPrintQueue:receiptId itemId:nil user:user];
    }
}

-(void) endLabels: (NSInteger) receiptId
{
}
@end
