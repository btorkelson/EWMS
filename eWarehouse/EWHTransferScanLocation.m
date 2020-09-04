//
//  UIViewController+EWHTransferScanLocation.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import "EWHTransferScanLocation.h"

@implementation EWHTransferScanLocation

@synthesize warehouse;
@synthesize txtScanLocation;
@synthesize program;

EWHRootViewController *rootController;
DTDevices *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
        
        txtScanLocation.text = barcode;
        [self performSegueWithIdentifier:@"TransferScanPart" sender:nil];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        txtScanLocation.text = barcode;
        [self performSegueWithIdentifier:@"TransferScanPart" sender:nil];
    }
}


- (IBAction)nextPressed:(id)sender {
    [self performSegueWithIdentifier:@"TransferScanPart" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TransferScanPart"]) {
        EWHTransferScanPart *selectReceiptController = [segue destinationViewController];
        selectReceiptController.warehouse = warehouse;
        selectReceiptController.location= txtScanLocation.text;
        selectReceiptController.program=program;
    }
}

@end
