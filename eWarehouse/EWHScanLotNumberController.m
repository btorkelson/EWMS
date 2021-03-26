//
//  EWHScanLotNumberController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 3/1/21.
//

#import "EWHScanLotNumberController.h"

@interface EWHScanLotNumberController ()

@end



@implementation EWHScanLotNumberController

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize storagelocation;
@synthesize warehouse;
@synthesize location;
@synthesize txtLotNumber;
@synthesize serialNumbers;
@synthesize quantity;

DTDevices *linea;

- (void)viewDidLoad {
    [super viewDidLoad];
    
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
}

-(void)viewWillDisappear:(BOOL)animated
{
    [linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 1;
}

- (IBAction)nextPressed:(id)sender {
    
    shipmentDetail.LotNumber = txtLotNumber.text;
    [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype
{
    txtLotNumber.text=barcode;
    shipmentDetail.LotNumber = txtLotNumber.text;
    [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    txtLotNumber.text=barcode;
    shipmentDetail.LotNumber = txtLotNumber.text;
        [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.shipment = shipment;
        scanLocationController.shipmentDetail = shipmentDetail;
        scanLocationController.warehouse = warehouse;
        scanLocationController.location = location;
        scanLocationController.storagelocation = storagelocation;
        scanLocationController.serialNumbers =serialNumbers;
        scanLocationController.quantity=quantity;
    }
}



@end
