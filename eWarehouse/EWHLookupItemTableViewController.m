//
//  EWHLookupItemTableViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/28/14.
//
//

#import "EWHLookupItemTableViewController.h"

@interface EWHLookupItemTableViewController ()

@end

EWHRootViewController *rootController;

@implementation EWHLookupItemTableViewController

@synthesize warehouse;
@synthesize PartNumber;
@synthesize SerialNumber;
@synthesize ItemArray;

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
    
    [self getItems];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    return [ItemArray count];
}

-(void) getItems
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetItemLocationSummarybyPart *request = [[EWHGetItemLocationSummarybyPart alloc] initWithCallbacks:self callback:@selector(getJobListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getItemLocationSummarybyPart:warehouse.Id partNumber:PartNumber serial:SerialNumber withAuthHash:user.AuthHash];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    
    EWHTableViewCellforTransfer *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHItemDetail *item = [ItemArray objectAtIndex:indexPath.row];
    
    cell.lblQty.text=[NSString stringWithFormat:@"%li",(long)item.Quantity];
    cell.lblStatus.text=[NSString stringWithFormat:@"%@ - %@", item.ItemNumber, item.ItemScan];
    cell.lblInventoryType.text=[NSString stringWithFormat:@"%@ - %@", item.LocationName, item.InventoryStatusName];
    //    txtInventoryType = catalog.InventoryTypeName;
    //    cell.detailTextLabel.text = catalog.InventoryStatusName;
    
    //totalQuantity = totalQuantity+(int)catalog.QuantityScanned;
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"INVENTORY", @"INVENTORY");
    return title;
}

-(void) getJobListCallback: (NSMutableArray*) results
{
    [rootController hideLoading];
    ItemArray = results;
    if ([ItemArray count]==0) {
        [rootController displayAlert:@"No inventory found" withTitle:@"Item Search"];
    }
    [self.tableView reloadData];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}
- (IBAction)donePressed:(id)sender {
    [rootController popToViewController:rootController.selectActionView animated:YES];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

@end
