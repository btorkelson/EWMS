//
//  EWHSelectProgramforExistingReceiptController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import "EWHSelectProgramforExistingReceiptController.h"

@interface EWHSelectProgramforExistingReceiptController ()

@end

@implementation EWHSelectProgramforExistingReceiptController

EWHRootViewController *rootController;
@synthesize warehouse;
@synthesize programs;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self loadProgramList];
    
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
    return [programs count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"ProgramCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHProgram *program = [programs objectAtIndex:indexPath.row];
    
    cell.textLabel.text = program.Name;
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHProgram *program = [programs objectAtIndex:indexPath.row];
    EWHNewReceiptDataObject* theDataObject2 = [self theAppDataObject];
    
    theDataObject2.program = program;
    
//    [self performSegueWithIdentifier:@"CreateReceipt" sender:nil];
    [self getProgramSavedReceipt:program];
    
}

-(void) getProgramSavedReceipt:(EWHProgram *)program {
    
//    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetSavedReceipt
        *request = [[EWHGetSavedReceipt alloc] initWithCallbacks:self callback:@selector(getSavedReceiptRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getSavedReceipt:program.ProgramId warehouseId:warehouse.Id withAuthHash:user.AuthHash];
    }
    
    
}



-(void) getSavedReceiptRequestCallBack: (EWHReceipt*) results
{
    
//        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    
    theDataObject.warehouse = warehouse;
    theDataObject.CustomControlSettings=results.CustomControlSettings;
    theDataObject.InboundCustomAttributes=results.InboundCustomAttributes;
    if (results.ProgramId > 0) {
        
        EWHCarrier* carrier = [EWHCarrier alloc];
        carrier.CarrierId = results.CarrierId;
        carrier.Name = results.CarrierName;
        
        EWHVendor* vendor = [EWHVendor alloc];
        vendor.VendorId = results.VendorId;
        vendor.Name = results.VendorName;
        
        EWHOrigin* origin = [EWHOrigin alloc];
        origin.OriginId = results.OriginId;
        origin.Name = results.OriginName;
        
        EWHShipMethod* shipmethod = [EWHShipMethod alloc];
        shipmethod.ShipMethodId = results.ShippingMethod;
        shipmethod.Name = results.ShipMethodName;
        
        theDataObject.origin = origin;
        theDataObject.shipmethod = shipmethod;
        theDataObject.ProjectName = results.ProjectNumber;
        theDataObject.vendor = vendor;
        theDataObject.carrier = carrier;
        
        theDataObject.inventorytypeId = results.InventoryTypeId;
        theDataObject.PromptInventoryType = results.PromptInventoryType;
        theDataObject.ScanPartNumber = results.ScanPartNumber;
        theDataObject.ProjectSequenceNumber=results.ProjectSequenceNumber;
        theDataObject.ScanLocation = results.ScanLocation;
    } else {
        theDataObject.carrier = nil;
        theDataObject.vendor = nil;
        theDataObject.origin = nil;
        theDataObject.shipmethod = nil;
        theDataObject.ProjectName = nil;
    }
    
    [self performSegueWithIdentifier:@"AddItemtoReceipt" sender:nil];
}


-(void) loadProgramList
{
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetProgramsforReceipt
        *request = [[EWHGetProgramsforReceipt alloc] initWithCallbacks:self callback:@selector(getProgramsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getGetProgramsforReceiptRequest:warehouse.Id withAuthHash:user.AuthHash];
    }
}


-(void) getProgramsRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    programs = results;
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
    if ([[segue identifier] isEqualToString:@"AddItemtoReceipt"]) {
        EWHSelectExistingReceiptController *createReceiptController = [segue destinationViewController];
//        createReceiptController.program = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
}


@end
