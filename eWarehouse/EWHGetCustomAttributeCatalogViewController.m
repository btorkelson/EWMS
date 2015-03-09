//
//  EWHGetCustomAttributeCatalogViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/14/14.
//
//

#import "EWHGetCustomAttributeCatalogViewController.h"

@interface EWHGetCustomAttributeCatalogViewController ()

@end

@implementation EWHGetCustomAttributeCatalogViewController

@synthesize lblCustomAttributeName;
@synthesize txtCustomAttributeValue;
@synthesize catalog;
@synthesize customAttribute;
@synthesize CAindex;


EWHRootViewController *rootController;
DTDevices *linea;
bool isScannerConnected;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rootController = (EWHRootViewController *)self.navigationController;
    
    isScannerConnected = NO;

}

- (void)viewWillAppear:(BOOL)animated
{
    linea=[DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
    
    if (CAindex ==0 || CAindex==1) {
        customAttribute = [[EWHCustomAttributeCatalog alloc] initWithDictionary:[catalog.CustomAttributeCatalogs objectAtIndex:CAindex]];

        lblCustomAttributeName.text = customAttribute.Name;
        txtCustomAttributeValue.text = customAttribute.Value;
    } else {
        [rootController displayAlert:@"Unknown Error" withTitle:@"Error"];
    }
    
}

-(void)viewWillDisappear:(BOOL)animated
{
    [linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
        txtCustomAttributeValue.text = barcode;
//        [self donePressed:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        txtCustomAttributeValue.text = barcode;
        [self nextPressed:nil];
    }
}

- (IBAction)nextPressed:(id)sender {
    
    NSInteger whatever = 0;
    if ((customAttribute.Required) && (txtCustomAttributeValue.text.length==0)) {
        [rootController displayAlert:customAttribute.ErrorMessage withTitle:@"Error"];
        whatever=1;
    } else {
        customAttribute.Value = txtCustomAttributeValue.text;
//        [catalog.CustomAttributeCatalogs
//        [catalog.CustomAttributeCatalogs replaceObjectAtIndex:CAindex withObject:customAttribute];
        [[catalog.CustomAttributeCatalogs objectAtIndex:CAindex] setValue:txtCustomAttributeValue.text forKey:@"Value"];
        
        if ([catalog.CustomAttributeCatalogs count]>CAindex+1) {
        
            UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"MainStoryboard" bundle: nil];
            EWHGetCustomAttributeCatalogViewController *dest = [storyboard instantiateViewControllerWithIdentifier:@"GETCAC"];
            dest.catalog = catalog;
            dest.CAindex = CAindex+1;
            [self.navigationController pushViewController:dest animated:YES];

            whatever=2;
        } else {
            [self performSegueWithIdentifier:@"SelectLocation" sender:nil];
            whatever=3;
        }
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"GetCustomAttributeCatalog"]) {
        EWHGetCustomAttributeCatalogViewController *getCustomAttribute = [segue destinationViewController];
        getCustomAttribute.catalog=catalog;
        getCustomAttribute.CAindex=CAindex+1;
    } else if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
            EWHSelectStorageLocationViewController *selectLocationController = [segue destinationViewController];
            selectLocationController.catalog = catalog;
            //Z - remove in production
            //        [self getDetails:scanItemController.receipt.ReceiptId];
        }
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
