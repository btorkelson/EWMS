//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSelectLocationController.h"

@implementation EWHSelectLocationController
{

}

@synthesize warehouse;
@synthesize shipment;
@synthesize shipmentDetail;
@synthesize locations;
@synthesize storagelocation;

EWHRootViewController *rootController;

#pragma mark -
#pragma mark Table view data source

- (void) viewDidLoad{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadLocations];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) loadLocations
{
    [rootController showLoading];
    if(rootController.locations == nil && locations == nil){
        EWHUser *user = rootController.user;
        if(user != nil){
            EWHGetLocationsForPickingRequest *request = [[EWHGetLocationsForPickingRequest alloc] initWithCallbacks:self callback:@selector(getLocationsCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
            [request getLocationsForPickingRequest:warehouse.Id withAuthHash:user.AuthHash];
        }
    }
    else {
        if(locations == nil)
            locations = rootController.locations;
        [rootController hideLoading];
        [self.tableView reloadData];
    }
}

-(void) getLocationsCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    rootController.locations = results;
    locations = results;
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
    return [locations count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"LocationCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHLocation *location = [locations objectAtIndex:indexPath.row];
    
    cell.textLabel.text = location.Name;
    
    ((EWHShipmentDetailsController *)rootController.shipmentLocationsView).location = location;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHLocation *location = [locations objectAtIndex:indexPath.row];
    EWHUser *user = rootController.user;
    if(shipmentDetail.IsScanned || user.EWAdmin){
        if(shipment.isContainer)
            [self performSegueWithIdentifier:@"ScanLocation" sender:location];
        else
            if(shipmentDetail.IsSerialized)
                [self performSegueWithIdentifier:@"GetSerializedPartData" sender:location];
            else
                [self performSegueWithIdentifier:@"GetPartData" sender:location];
    }
    else
//        [self performSegueWithIdentifier:@"GetSerializedPartData" sender:location];
        [self performSegueWithIdentifier:@"ScanContainer" sender:location];
}

-(IBAction) refreshPressed: (id) sender
{
    rootController.locations = nil;
    locations = nil;
    [self loadLocations];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ScanContainer"]) {
        EWHScanContainerController *scanContainerController = [segue destinationViewController];
        scanContainerController.location = sender;
        scanContainerController.shipment = shipment;
        scanContainerController.warehouse = warehouse;
        scanContainerController.shipmentDetail = shipmentDetail;
        scanContainerController.storagelocation = storagelocation;
    }
    else if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.location = sender;
        scanLocationController.warehouse = warehouse;
        scanLocationController.shipment = shipment;
        scanLocationController.shipmentDetail = shipmentDetail;
        scanLocationController.storagelocation = storagelocation;
    }
    else if ([[segue identifier] isEqualToString:@"GetPartData"]) {
        EWHGetPartDetailsController *getPartDataController = [segue destinationViewController];
        getPartDataController.location = sender;
        getPartDataController.shipment = shipment;
        getPartDataController.warehouse = warehouse;
        getPartDataController.shipmentDetail = shipmentDetail;
        getPartDataController.storagelocation = storagelocation;
    }
    else if ([[segue identifier] isEqualToString:@"GetSerializedPartData"]) {
        EWHGetSerializedPartDetailsController *getSerializedPartDataController = [segue destinationViewController];
        getSerializedPartDataController.location = sender;
        getSerializedPartDataController.shipment = shipment;
        getSerializedPartDataController.warehouse = warehouse;
        getSerializedPartDataController.shipmentDetail = shipmentDetail;
        getSerializedPartDataController.storagelocation = storagelocation;
    }
}

@end
