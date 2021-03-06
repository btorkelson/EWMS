//
//  EWHTransferViewCatalogs.m
//  eWarehouse
//
//  Created by Brian Torkelson on 4/11/19.
//
//

#import "EWHTransferViewCatalogs.h"


@interface EWHTransferViewCatalogs ()

@end

@implementation EWHTransferViewCatalogs

EWHRootViewController *rootController;
@synthesize warehouse;
@synthesize catalogs;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
//    [self loadCatalogList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    NSString *title = NSLocalizedString(@"Inventory", @"Inventory");
    return title;
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
    return [catalogs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    EWHTableViewCellforTransfer *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHCatalog *catalog = [catalogs objectAtIndex:indexPath.row];
    
    cell.lblQty.text=[NSString stringWithFormat:@"%li",(long)catalog.Qty];
    cell.lblStatus.text=catalog.InventoryStatusName;
    cell.lblInventoryType.text=catalog.InventoryTypeName;
//    txtInventoryType = catalog.InventoryTypeName;
//    cell.detailTextLabel.text = catalog.InventoryStatusName;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHCatalog *catalog = [catalogs objectAtIndex:indexPath.row];
    
    
    
    [self performSegueWithIdentifier:@"TransferSelectQty" sender:catalog];
    
}


-(void) loadCatalogList
{
    
//    [rootController showLoading];
//    EWHUser *user = rootController.user;
//    if(user != nil){
//        EWHGetWarehouseProgramListAll
//        *request = [[EWHGetWarehouseProgramListAll alloc] initWithCallbacks:self callback:@selector(getProgramsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
//        //NSLog(hub);
//        
//        
//        [request getWarehouseProgramList:warehouse.Id withAuthHash:user.AuthHash];
//    }
}


-(void) getProgramsRequestCallBack: (NSMutableArray*) results
{
//    [rootController hideLoading];
//    programs = results;
//    [self.tableView reloadData];
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
    if ([[segue identifier] isEqualToString:@"TransferSelectQty"]) {
        EWHTransferQuantitySerials *transfer = [segue destinationViewController];
//        transfer.program = sender;
        transfer.warehouse=warehouse;
        transfer.catalog=sender;
    }
}


@end
