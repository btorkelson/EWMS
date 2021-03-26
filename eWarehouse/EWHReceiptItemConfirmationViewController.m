//
//  EWHReceiptItemConfirmationViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 11/5/14.
//
//

#import "EWHReceiptItemConfirmationViewController.h"

@interface EWHReceiptItemConfirmationViewController ()

@end

@implementation EWHReceiptItemConfirmationViewController

@synthesize catalog;
@synthesize location;
@synthesize destination;
@synthesize SerialNumbers;
@synthesize btnAddItem;


EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;

EWHNewReceiptDataObject* theDataObject;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    //
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rootController = (EWHRootViewController *)self.navigationController;
    
    UITapGestureRecognizer *viewBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    viewBackgroundTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewBackgroundTap];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    lblReceiptNumber.text = theDataObject.ReceiptNumber;
    lblLocation.text = location.Name;
    lblDestination.text = destination.Name;
    lblPartNumber.text = catalog.ItemNumber;
    
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}


- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    txtQuantity.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (IBAction)quantityChanged:(UITextField *) sender
{
    stQuantityStepper.value = [sender.text integerValue];
}

- (IBAction)quantityEditingDidBegin:(UITextField *) sender
{
    [stQuantityStepper setEnabled:NO];
}

- (IBAction)quantityEditingDidEnd:(UITextField *) sender
{

    
    stQuantityStepper.value = [sender.text integerValue];
    [stQuantityStepper setEnabled:YES];
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtLotNumber.text=barcode;
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtLotNumber.text=barcode;
        
    }
}

- (IBAction)addItemPressed:(id)sender {
    btnAddItem.enabled = false;
    [rootController showLoading];
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if (theDataObject.program.IsReceiptToOrder) {
        [self receiveXDockItem:sender];
    } else {
        [self receiveItem:sender];
    }
    
}

-(IBAction)backgroundTap:(id)sender
{
    [txtQuantity resignFirstResponder];
    [txtLotNumber resignFirstResponder];
    [txtLineNumber resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            
            if (theDataObject.program.IsReceiptToOrder == NO) {
                return 2;
            } else {
                return 3;
            }
        case 1:
            return 4;
    }
}

-(void) receiveXDockItem:(id)sender {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptXDockItem
        *request = [[EWHAddReceiptXDockItem alloc] initWithCallbacks:self callback:@selector(getReceiveXDockItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request addReceiptItemforXDock:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location.Id catalogId:catalog.CatalogId quantity:[txtQuantity.text integerValue] IsBulk:catalog.IsBulk customAttributes:catalog.CustomAttributeCatalogs itemScan:nil destinationId:destination.DestinationId inventoryTypeId:catalog.InventoryTypeId shipMethodId:theDataObject.shipmethod.ShipMethodId UOMs:catalog.UOMs deliveryDate:theDataObject.DeliveryDateTime user:user lineNumber:txtLineNumber.text lotNumber:txtLotNumber.text];
    }
}


-(void) getReceiveXDockItemRequestCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    //    destinations = results;
    //    [rootController displayAlert:results.Message withTitle:@"Result"];
    
    if (results.Processed == 1) {
    [rootController popToViewController:rootController.selectItemforReceiptView animated:YES];
    } else {
        [rootController displayAlert:results.Message withTitle:@"Error"];
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}



-(void) receiveItem:(id)sender {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptItem
        *request = [[EWHAddReceiptItem alloc] initWithCallbacks:self callback:@selector(getReceiveItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        [request addReceiptItem:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location.Id catalogId:catalog.CatalogId quantity:[txtQuantity.text integerValue] IsBulk:catalog.IsBulk IsSerialized:catalog.IsSerial itemScan:SerialNumbers user:user inventoryTypeId:catalog.InventoryTypeId customAttributes:catalog.CustomAttributeCatalogs UOMs:catalog.UOMs lineNumber:txtLineNumber.text lotNumber:txtLotNumber.text];
        
        
        //        [request ad:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:_location.Id catalogId:_catalog.CatalogId quantity:1 IsBulk:_catalog.IsBulk itemScan:nil destinationId:destination shipMethodId:theDataObject.shipmethod.ShipMethodId user:user];
    }
}


-(void) getReceiveItemRequestCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    if (results.Processed == 1) {
        [rootController popToViewController:rootController.selectItemforReceiptView animated:YES];
    } else {
        [rootController displayAlert:results.Message withTitle:@"Error"];
    }
    //    destinations = results;
    //    [rootController displayAlert:results.Message withTitle:@"Result"];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}


-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    btnAddItem.enabled = true;
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

@end
