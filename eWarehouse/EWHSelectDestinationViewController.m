//
//  EWHSelectDestinationViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHSelectDestinationViewController.h"

@interface EWHSelectDestinationViewController ()

@end

@implementation EWHSelectDestinationViewController

EWHRootViewController *rootController;
@synthesize destinations;
@synthesize searchResults;
@synthesize lastdestination;
@synthesize cellSections;
@synthesize location;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
	EWHNewReceiptDataObject* theDataObject;
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
    rootController = (EWHRootViewController *)self.navigationController;
    
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    lastdestination = theDataObject.lastDestination;
//    rootController.selectItemforReceiptView = self;


    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self loadDestinationList];
    
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
    
    EWHDestinationsByType *destinationType = [cellSections objectAtIndex:section];
    return destinationType.DestinationType;
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
    EWHDestinationsByType *destinationType = [cellSections objectAtIndex:section];
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return destinationType.Destinations.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Configure the cell...
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
//    EWHLocation * location = [locationByType.Locations objectAtIndex:indexPath.row];
//    cell.textLabel.text = location.Name;
    
    
    EWHDestination *destination = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        destination = [searchResults objectAtIndex:indexPath.row];
        [cell setAccessoryType:UITableViewCellAccessoryDetailDisclosureButton];
    } else {
        EWHDestinationsByType *destinationType = [cellSections objectAtIndex:indexPath.section];
        destination = [destinationType.Destinations objectAtIndex:indexPath.row];
    }
    cell.textLabel.text = destination.Name;
    
//    if ((indexPath.row==0)) {
//     
//    if (lastdestination.DestinationId > 0) {
////        NSIndexPath *scrollIndexPath = [NSIndexPath indexPathForRow:(indexPath.row) inSection:0];
////        
////        [tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];
////        [tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
//        UIView *bgColorView = [[UIView alloc] init];
//        bgColorView.backgroundColor = [UIColor colorWithRed:(76.0/255.0) green:(161.0/255.0) blue:(255.0/255.0) alpha:1.0]; // perfect color suggested by @mohamadHafez
//        bgColorView.layer.masksToBounds = YES;
//        cell.selectedBackgroundView = bgColorView;
//    
//    }
//    }

    
    return cell;
}



-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
//    EWHLocation *location = [locationByType.Locations objectAtIndex:indexPath.row];
    
    
    EWHDestination *destination = nil;
    if (self.searchDisplayController.active) {
        destination = [searchResults objectAtIndex:indexPath.row];
    } else {
        EWHDestinationsByType *desinationType = [cellSections objectAtIndex:indexPath.section];
    destination = [desinationType.Destinations objectAtIndex:indexPath.row];
    }
    
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    theDataObject.lastDestination = destination;
    
    
//    [self  receiveItem:destination.DestinationId];
    [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:destination];
}

-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath {
    
    //    EWHLocation *location = [locationByType.Locations objectAtIndex:indexPath.row];
    EWHDestination *destination = nil;
    if (tableView == self.searchDisplayController.searchResultsTableView) {
    
        destination =[searchResults objectAtIndex:indexPath.row];
    
    } else {
        EWHDestinationsByType *desinationType = [cellSections objectAtIndex:indexPath.section];
        destination = [desinationType.Destinations objectAtIndex:indexPath.row];
    }

    [self performSegueWithIdentifier:@"ViewDestination" sender:destination];

}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Name beginswith[c] %@", searchText];
    searchResults = [destinations filteredArrayUsingPredicate:resultPredicate];
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}

-(void) loadDestinationList
{
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
	EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHGetDestinationsByProgramWarehouse
        *request = [[EWHGetDestinationsByProgramWarehouse alloc] initWithCallbacks:self callback:@selector(getDestinationsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getDestinationsByProgramWarehouse:theDataObject.program.ProgramId warehouseId:theDataObject.warehouse.Id locationId:location.Id withAuthHash:user.AuthHash];
    }
}


-(void) getDestinationsRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    destinations = [[NSMutableArray alloc] init];
    cellSections = [[NSMutableArray alloc] init];
    if (lastdestination.DestinationId>0)
    {
        [destinations addObject:lastdestination];
        EWHDestinationsByType *destinationtype = [EWHDestinationsByType alloc];
        destinationtype.DestinationType = @"Last Used";
        destinationtype.Destinations = destinations;
        [cellSections addObject:destinationtype];
        
    }
    destinations = results;
    EWHDestinationsByType *destinationtype = [EWHDestinationsByType alloc];
    destinationtype.DestinationType = @"Destinations";
    destinationtype.Destinations = destinations;
    [cellSections addObject:destinationtype];
    
    //    destinations = results;
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




- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"SelectDestination"]) {
        EWHCreateReceiptController *createReceiptController = [segue destinationViewController];
        //        createReceiptController.program = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    } else  if ([[segue identifier] isEqualToString:@"ViewDestination"]) {
        EWHViewDestinationViewController *viewDestController = [segue destinationViewController];
        viewDestController.destination=sender;
        viewDestController.location = location;
        viewDestController.catalog = _catalog;
    } else  if ([[segue identifier] isEqualToString:@"ReceiptItemConfirm"]) {
        EWHReceiptItemConfirmationViewController *viewConfirmController = [segue destinationViewController];
        viewConfirmController.destination=sender;
        viewConfirmController.location=location;
        viewConfirmController.catalog=_catalog;
    }
}

@end
