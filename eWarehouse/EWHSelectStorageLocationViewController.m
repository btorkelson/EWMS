//
//  EWHSelectStorageLocationViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHSelectStorageLocationViewController.h"

@interface EWHSelectStorageLocationViewController ()

@end

@implementation EWHSelectStorageLocationViewController

EWHRootViewController *rootController;
@synthesize locations;
@synthesize uniqueLocationTypes;
@synthesize sortedLocationTypes;
@synthesize sourceLocations;
@synthesize cellSections;
@synthesize catalog;

	EWHNewReceiptDataObject* theDataObject;
- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
//
}

-(void) viewDidAppear:(BOOL)animated
{
    [self loadLocationList];
    
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
    return [cellSections count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    
    EWHLocationsByType *locationByType = [cellSections objectAtIndex:section];
    return locationByType.LocationType;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
//    return [locations count];
//    NSString *x =[self.sortedLocationTypes objectAtIndex:section];
//    
//    NSInteger i =[[self.sourceLocations objectForKey:x] count];
//    
//    return i;
    EWHLocationsByType *locationByType = [cellSections objectAtIndex:section];
    return locationByType.Locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
//    EWHLocation *location = [locations objectAtIndex:indexPath.row];
    
//    NSString * LocationType = [self.sortedLocationTypes objectAtIndex:indexPath.section];
//    NSArray * objectsForType = [self.sourceLocations objectForKey:LocationType];
//    EWHLocation * location = [objectsForType objectAtIndex:indexPath.row];
    
    EWHLocationsByType *locationByType = [cellSections objectAtIndex:indexPath.section];
    EWHLocation * location = [locationByType.Locations objectAtIndex:indexPath.row];
    cell.textLabel.text = location.Name;
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *x =[self.sortedLocationTypes objectAtIndex:indexPath.section];
    EWHLocationsByType *locationByType = [cellSections objectAtIndex:indexPath.section];
    EWHLocation *location = [locationByType.Locations objectAtIndex:indexPath.row];
    
    if (theDataObject.program.IsReceiptToOrder) {
        [self performSegueWithIdentifier:@"SelectDestination" sender:location];
    } else {
        
        [self receiveItem:location.Id];
        
    }
    
    
}


-(void) loadLocationList
{
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if (theDataObject.warehouse.binLocations.count > 0) {
        
        [rootController hideLoading];
        cellSections = [NSMutableArray array];
        cellSections = theDataObject.warehouse.binLocations;
        
        [self.tableView reloadData];
    } else {
        if(user != nil){
        EWHGetWarehouseStorageLocations
        *request = [[EWHGetWarehouseStorageLocations alloc] initWithCallbacks:self callback:@selector(getLocationsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getWarehouseStorageLocations:theDataObject.warehouse.Id withAuthHash:user.AuthHash];
        }
    }
    
}


-(void) getLocationsRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    locations = results;
    
    NSMutableDictionary * theDictionary = [NSMutableDictionary dictionary];
    //    sections = [NSMutableDictionary dictionary];
    for ( EWHLocation * object in locations ) {
        NSMutableArray * theMutableArray = [theDictionary objectForKey:object.LocationTypeName];
        if ( theMutableArray == nil ) {
            theMutableArray = [NSMutableArray array];
            [theDictionary setObject:theMutableArray forKey:object.LocationTypeName];
        }
        
        [theMutableArray addObject:object];
    }
    self.sortedLocationTypes = [[theDictionary allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
    self.sourceLocations = theDictionary;
    cellSections = [NSMutableArray array];
    for (NSUInteger i = 0; i < [sortedLocationTypes count]; i++) {
        NSString *x = sortedLocationTypes[i];
        NSString *y =[self.sortedLocationTypes objectAtIndex:i];
        NSMutableArray *newlocations =[self.sourceLocations objectForKey:y] ;
        EWHLocationsByType *locationbytype = [EWHLocationsByType alloc];
        locationbytype.LocationType = x;
        locationbytype.Locations = newlocations;
        [cellSections addObject:locationbytype];
    }
    
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    theDataObject.warehouse.binLocations = cellSections;
    
//    for (id x in sortedLocationTypes ){
//        EWHLocationsByType *locationbytype = [NSMutableArray alloc];
//        locationbytype.LocationType = x;
//        NSString *y =[self.sortedLocationTypes objectAtIndex:x];
//        
//        NSInteger i =[[self.sourceLocations objectForKey:x] count];
//    }
//
//    uniqueLocationTypes = [NSSet setWithArray:[locations valueForKey:@"LocationTypeName"]];
    [self.tableView reloadData];
}



-(void) receiveItem:(NSInteger)location {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptItem
        *request = [[EWHAddReceiptItem alloc] initWithCallbacks:self callback:@selector(getReceiveItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        [request addReceiptItem:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location catalogId:catalog.CatalogId quantity:1 IsBulk:catalog.IsBulk IsSerialized:catalog.IsSerial itemScan:nil user:user inventoryTypeId:catalog.InventoryTypeId customAttributes:catalog.CustomAttributeCatalogs UOMs:catalog.UOMs];
        
        
//        [request ad:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:_location.Id catalogId:_catalog.CatalogId quantity:1 IsBulk:_catalog.IsBulk itemScan:nil destinationId:destination shipMethodId:theDataObject.shipmethod.ShipMethodId user:user];
    }
}


-(void) getReceiveItemRequestCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    //    destinations = results;
//    [rootController displayAlert:results.Message withTitle:@"Result"];
    [rootController popToViewController:rootController.selectItemforReceiptView animated:YES];
    //    [self.navigationController popViewControllerAnimated:YES];
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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectDestination"]) {
        EWHSelectDestinationViewController *createReceiptController = [segue destinationViewController];
                createReceiptController.catalog = catalog;
        createReceiptController.location = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
}


@end
