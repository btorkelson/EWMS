//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSelectShipmentController.h"

@implementation EWHSelectShipmentController
{

}

@synthesize warehouse;
@synthesize shipments;

EWHRootViewController *rootController;
DTDevices *linea;

#pragma mark -
#pragma mark Table view data source

- (void) viewDidLoad{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.selectShipmentView = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    linea = [DTDevices sharedDevice];
	[linea connect];
    [linea addDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    rootController.locations = nil;
    [self loadShipments];
}

-(void)viewWillDisappear:(BOOL)animated
{
	[linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) loadShipments
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetShipmentsForPickingRequest *request = [[EWHGetShipmentsForPickingRequest alloc] initWithCallbacks:self callback:@selector(getShipmentListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getShipmentsForPickingRequest:warehouse.Id withAuthHash:user.AuthHash];
    }
}

-(void) getShipmentListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    shipments = results;
    [self.tableView reloadData];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
    return [shipments count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ShipmentCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHShipment *shipment = [shipments objectAtIndex:indexPath.row];
    
    cell.textLabel.text = shipment.ShipmentNumber;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate], shipment.ProgramName];
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@", [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate]];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHShipment *shipment = [shipments objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowLocations" sender:shipment];    
}

-(IBAction) refreshPressed: (id) sender
{
    [self loadShipments];
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
        [self validateScan:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove in production
    //barcode = @"176761";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ShipmentNumber == %@", barcode];
    NSArray *matches = [shipments filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHShipment *shipment = [matches objectAtIndex:0];
        [self performSegueWithIdentifier:@"ShowLocations" sender:shipment];
    }
    else {
        [rootController displayAlert:@"Incorrect shipment" withTitle:@"Shipment"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ShowLocations"]) {
        EWHSelectLocationControllerNEW *selectLocationController = [segue destinationViewController];
        selectLocationController.shipment = sender;
        selectLocationController.warehouse = warehouse;
    }
}

@end
