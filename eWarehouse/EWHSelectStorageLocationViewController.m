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

DTDevices *linea;

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
    linea = [DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    
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
        if (catalog.IsSerial) {
            [self performSegueWithIdentifier:@"ScanSerialNumbers" sender:location];
        } else {
            [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:location];
        }
        
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
        [self validateScan:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
}
- (IBAction)scanPressed:(id)sender {
    [self validateScan:sender];
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove in production
    //    barcode = @"58668";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"Name == %@", barcode];
    NSArray *matches = [locations filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHLocation *location = [matches objectAtIndex:0];
        if (theDataObject.program.IsReceiptToOrder) {
            [self performSegueWithIdentifier:@"SelectDestination" sender:location];
        } else {
            if (catalog.IsSerial) {
                [self performSegueWithIdentifier:@"ScanSerialNumbers" sender:location];
            } else {
                [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:location];
            }
            
        }
    }
    else {
        [rootController displayAlert:@"Incorrect Location" withTitle:@"Error"];
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
    } else if ([[segue identifier] isEqualToString:@"ReceiptItemConfirm"]) {
        EWHSelectDestinationViewController *createReceiptController = [segue destinationViewController];
        createReceiptController.catalog = catalog;
        createReceiptController.location = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    } else if ([[segue identifier] isEqualToString:@"ScanSerialNumbers"]) {
        EWHSelectDestinationViewController *createReceiptController = [segue destinationViewController];
        createReceiptController.catalog = catalog;
        createReceiptController.location = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
}


@end
