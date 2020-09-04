//
//  EWHTransferScanNewLocation.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import "EWHTransferScanNewLocation.h"

@interface EWHTransferScanNewLocation ()

@end

@implementation EWHTransferScanNewLocation

@synthesize warehouse;
@synthesize location;
@synthesize catalog;
@synthesize quantity;
@synthesize txtNewLocation;
@synthesize serials;
EWHRootViewController *rootController;
DTDevices *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
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

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)movePressed:(id)sender {
    [self moveInventory:txtNewLocation.text];
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
        
        txtNewLocation.text = barcode;
        [self moveInventory:txtNewLocation.text];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        
        txtNewLocation.text = barcode;
        [self moveInventory:txtNewLocation.text];
    }
}


-(void) moveInventory: (NSString *) newLocation
{
	
    
    EWHUser *user = rootController.user;
    EWHMoveInventory *request = [[EWHMoveInventory alloc] initWithCallbacks:self callback:@selector(moveInventoryCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
//NSLog(hub);

    [request moveInventory:warehouse location:location catalog:catalog quantity:quantity newlocation:newLocation serials:serials user:user];
}



-(void) moveInventoryCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    //    [rootController displayAlert:result.Message withTitle:@"Result"];
    if (result.Processed) {
    
        
        [rootController displayAlert:result.Message withTitle:@"Success"];
        __weak EWHTransferScanPart * weakSelf = rootController.transferScanPartView;
        weakSelf.txtPartNumber.text = @"";
        [rootController popToViewController:weakSelf animated:YES];
    } else {
        [rootController displayAlert:result.Message withTitle:@"Error"];
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
