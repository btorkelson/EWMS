//
//  EWHReceiptVendorViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHReceiptOptionsViewController.h"



@implementation EWHReceiptOptionsViewController


EWHRootViewController *rootController;
@synthesize program;
@synthesize options;
@synthesize entity;
@synthesize searchResults;
@synthesize inboundCustomAttribute;

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
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.selectReceiptView = self;
    NSString * navTitle = [NSString stringWithFormat:@"Select %@",entity];
    self.navigationItem.title = navTitle;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    
//    navBarItself.topItem.title = entity;
    [self loadOptionList];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return [searchResults count];
        
    } else {
        return [options count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"VendorCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    // Configure the cell...
    if ( cell == nil ) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // Get the object to display and set the value in the cell.
        if ([entity  isEqual: @"Vendor"]) {
            EWHVendor *vendor = [searchResults objectAtIndex:indexPath.row];
            
            cell.textLabel.text = vendor.Name;
        } else if ([entity  isEqual: @"Carrier"]) {
            EWHCarrier *carrier = [searchResults objectAtIndex:indexPath.row];
            
            cell.textLabel.text = carrier.Name;
        } else if ([entity  isEqual: @"Origin"]) {
            EWHOrigin *origin = [searchResults objectAtIndex:indexPath.row];
            
            cell.textLabel.text = origin.Name;
        } else if ([entity  isEqual: @"Ship Method"]) {
            EWHShipMethod *shipmethod = [searchResults objectAtIndex:indexPath.row];
            
            cell.textLabel.text = shipmethod.Name;
        } else {
            cell.textLabel.text =[searchResults objectAtIndex:indexPath.row];
        }
    } else {
        // Get the object to display and set the value in the cell.
        if ([entity  isEqual: @"Vendor"]) {
            EWHVendor *vendor = [options objectAtIndex:indexPath.row];
            
            cell.textLabel.text = vendor.Name;
        } else if ([entity  isEqual: @"Carrier"]) {
            EWHCarrier *carrier = [options objectAtIndex:indexPath.row];
            
            cell.textLabel.text = carrier.Name;
        } else if ([entity  isEqual: @"Origin"]) {
            EWHOrigin *origin = [options objectAtIndex:indexPath.row];
            
            cell.textLabel.text = origin.Name;
        } else if ([entity  isEqual: @"Ship Method"]) {
            EWHShipMethod *shipmethod = [options objectAtIndex:indexPath.row];
            
            cell.textLabel.text = shipmethod.Name;
        } else {
            cell.textLabel.text =[options objectAtIndex:indexPath.row];
        }
    }
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        if ([entity  isEqual: @"Vendor"]) {
            EWHVendor *vendor = [searchResults objectAtIndex:indexPath.row];
            
            theDataObject.vendor = vendor;
        } else if ([entity  isEqual: @"Carrier"]) {
            EWHCarrier *carrier = [searchResults objectAtIndex:indexPath.row];
            
            theDataObject.carrier = carrier;
        } else if ([entity  isEqual: @"Origin"]) {
            EWHOrigin *origin = [searchResults objectAtIndex:indexPath.row];
            
            theDataObject.origin = origin;
        } else if ([entity  isEqual: @"Ship Method"]) {
            EWHShipMethod *shipmethod = [searchResults objectAtIndex:indexPath.row];
            
            theDataObject.shipmethod = shipmethod;
        } else {
            inboundCustomAttribute.Value=[searchResults objectAtIndex:indexPath.row];
        }
    }else{
        if ([entity  isEqual: @"Vendor"]) {
            EWHVendor *vendor = [options objectAtIndex:indexPath.row];
            
            theDataObject.vendor = vendor;
        } else if ([entity  isEqual: @"Carrier"]) {
            EWHCarrier *carrier = [options objectAtIndex:indexPath.row];
            
            theDataObject.carrier = carrier;
        } else if ([entity  isEqual: @"Origin"]) {
            EWHOrigin *origin = [options objectAtIndex:indexPath.row];
            
            theDataObject.origin = origin;
        } else if ([entity  isEqual: @"Ship Method"]) {
            EWHShipMethod *shipmethod = [options objectAtIndex:indexPath.row];
            
            theDataObject.shipmethod = shipmethod;
        } else {
            inboundCustomAttribute.Value=[options objectAtIndex:indexPath.row];
        }
    }
    
    
    
    [self.navigationController popViewControllerAnimated:YES];
}



-(void) loadOptionList
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
//    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];

    if(user != nil){
        
    if ([entity  isEqual: @"Vendor"]) {
        EWHGetVendorsByProgram
        *request = [[EWHGetVendorsByProgram alloc] initWithCallbacks:self callback:@selector(getOptionsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        [request getGetVendorsByProgram:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
        
    } else if ([entity  isEqual: @"Carrier"]) {
        EWHGetCarriersByProgram
        *request = [[EWHGetCarriersByProgram alloc] initWithCallbacks:self callback:@selector(getOptionsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        [request getCarriersByProgram:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
        
    } else if ([entity  isEqual: @"Origin"]) {
        EWHGetOriginsByProgramWarehouse
        *request = [[EWHGetOriginsByProgramWarehouse alloc] initWithCallbacks:self callback:@selector(getOptionsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        [request getOriginsByProgramWarehouse:theDataObject.program.ProgramId warehouseid:theDataObject.warehouse.Id withAuthHash:user.AuthHash];
        
    } else if ([entity  isEqual: @"Ship Method"]) {
        EWHGetShipMethodsByProgram
        *request = [[EWHGetShipMethodsByProgram alloc] initWithCallbacks:self callback:@selector(getOptionsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        [request getShipMethodsByProgram:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
        
    } else {
        
        [rootController hideLoading];
    }
    
        
        
        
    }
}

- (void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope
{
    if ([entity  isEqual: @"Value"]) {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"SELF beginswith[c] %@", searchText];
        searchResults = [options filteredArrayUsingPredicate:resultPredicate];
    } else {
        
        NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"Name beginswith[c] %@", searchText];
        searchResults = [options filteredArrayUsingPredicate:resultPredicate];
    }
    
}


-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar
                                                     selectedScopeButtonIndex]]];
    
    return YES;
}


-(void) getOptionsRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    options = results;
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



@end
