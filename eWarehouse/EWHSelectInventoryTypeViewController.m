//
//  EWHSelectInventoryTypeViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import "EWHSelectInventoryTypeViewController.h"

@interface EWHSelectInventoryTypeViewController ()

@end

@implementation EWHSelectInventoryTypeViewController

EWHRootViewController *rootController;
@synthesize inventoryTypes;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    EWHNewReceiptDataObject* theDataObject;
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    //    rootController.selectItemforReceiptView = self;
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self loadInventoryTypeList];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [inventoryTypes count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"InventoryTypeCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHInventoryType *inventoryType = [inventoryTypes objectAtIndex:indexPath.row];
    
    cell.textLabel.text = inventoryType.Name;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHInventoryType *inventoryType = [inventoryTypes objectAtIndex:indexPath.row];
    
    _catalog.InventoryTypeId = inventoryType.InventoryTypeId;
//    if ([_catalog.CustomAttributeCatalogs count]>0) {
    
    if (_catalog.CustomAttributeCatalogs !=NULL) {
        NSInteger asdf = 2;
        asdf=3;
    }
    
        if (_catalog.CustomAttributeCatalogs.count>0) {
            [self performSegueWithIdentifier:@"GetCustomAttributeCatalog" sender:_catalog];
        } else {
        [self performSegueWithIdentifier:@"SelectLocation" sender:_catalog];
        }
//    [self getProgramSavedReceipt:program];
    
}


-(void) loadInventoryTypeList
{
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHGetInventoryTypesforProgram
        *request = [[EWHGetInventoryTypesforProgram alloc] initWithCallbacks:self callback:@selector(getInventoryTypesRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getInventoryTypesforProgram:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
    }
}


-(void) getInventoryTypesRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    
    inventoryTypes = results;
    
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
    if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
        EWHSelectStorageLocationViewController *createReceiptController = [segue destinationViewController];
        createReceiptController.catalog = sender;
        //        createReceiptController.program = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    } else if ([[segue identifier] isEqualToString:@"GetCustomAttributeCatalog"]) {
    
    EWHAddCatalogCustomAttributesViewController *getCACscontroller = [segue destinationViewController];
    getCACscontroller.catalog = sender;
    //getCACscontroller.CAindex = 0;
    }
}


@end
