//
//  EWHTransferScanPart.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import "EWHTransferScanPart.h"

@interface EWHTransferScanPart ()

@end

@implementation EWHTransferScanPart

@synthesize warehouse;
@synthesize location;
@synthesize txtPartNumber;
@synthesize program;

EWHRootViewController *rootController;
DTDevices *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.transferScanPartView = self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    linea=[DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
//    txtPartNumber.text = @"";
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


-(void)connectionState:(int)state {
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            //[btnScanUserName setHidden:true];
            //[scannerMsg setHidden:false];
            //[voltageLabel setHidden:true];
            //[battery setHidden:true];
            break;
        case CONN_CONNECTED:
            //[btnScanUserName setHidden:false];
            //[scannerMsg setHidden:true];
            //[self updateBattery];
            ////Z - remove in production
            ////            [linea setScanBeep:false volume:0 beepData:nil length:0];
            break;
    }
}


-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
        [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}


-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        txtPartNumber.text = barcode;
        [self nextPressed:nil];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        txtPartNumber.text = barcode;
        [self nextPressed:nil];

    }
}


- (IBAction)nextPressed:(id)sender {
    [self validateCatalog:txtPartNumber.text];
}

-(void) validateCatalog: (NSString *) partNumber
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    //	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        
        EWHGetCatalogByItemNumberandLocationforMoving *request = [[EWHGetCatalogByItemNumberandLocationforMoving alloc] initWithCallbacks:self callback:@selector(validateCatalogCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        
//        [request getCatalogByItemNumber:program.ProgramId itemNumber:partNumber withAuthHash:user.AuthHash];
        [request getCatalogByItemNumberandLocationforMoving:program.ProgramId warehouseId:warehouse.Id itemNumber:partNumber location:location withAuthHash:user.AuthHash];
    }
}

-(void) validateCatalogCallback: (NSMutableArray*) catalogs
{
    [rootController hideLoading];
    if ([catalogs count]>0) {
        EWHCatalog *catalog = [catalogs objectAtIndex:0];
    
                if (catalog.IsBulk ==1 ) {
                    [self performSegueWithIdentifier:@"TransferViewCatalogs" sender:catalogs];
                } else {
                    [self performSegueWithIdentifier:@"TransferSerials" sender:catalog];
                }

    } else {
            [rootController displayAlert:@"Part Number not found" withTitle:@"Error"];
        }
    
    
//    [self performSegueWithIdentifier:@"TransferViewCatalogs" sender:catalogs];
    
//    if (catalog.CatalogId != -1) {
        
    
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TransferQtySerials"]) {
        EWHTransferQuantitySerials *selectReceiptController = [segue destinationViewController];
        selectReceiptController.warehouse = warehouse;
        selectReceiptController.location= location;
        selectReceiptController.catalog=sender;
    } else if ([[segue identifier] isEqualToString:@"TransferSerials"]) {
        EWHTransferSerials *selectReceiptController = [segue destinationViewController];
        selectReceiptController.warehouse = warehouse;
        selectReceiptController.location= location;
        selectReceiptController.catalog=sender;
        
    } else if ([[segue identifier] isEqualToString:@"TransferViewCatalogs"]) {
    EWHTransferViewCatalogs *selectReceiptController = [segue destinationViewController];
    selectReceiptController.warehouse = warehouse;
    selectReceiptController.location= location;
    selectReceiptController.catalogs=sender;
    
}
}



@end
