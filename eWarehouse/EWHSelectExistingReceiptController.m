//
//  EWHSelectExistingReceiptController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import "EWHSelectExistingReceiptController.h"

@interface EWHSelectExistingReceiptController ()

@end

@implementation EWHSelectExistingReceiptController

EWHRootViewController *rootController;
@synthesize warehouse;
@synthesize receipts;

EWHNewReceiptDataObject* theDataObject;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void) viewDidAppear:(BOOL)animated
{
    [self loadReceiptList];
    
}
#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return [receipts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHReceipt *receipt = [receipts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = receipt.ReceiptNumber;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [EWHUtils.dateFormatter stringFromDate:receipt.ReceivedDate], receipt.ProjectNumber];
    
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHReceipt *receipt = [receipts objectAtIndex:indexPath.row];
//    EWHNewReceiptDataObject* theDataObject2 = [self theAppDataObject];
    
    theDataObject.ReceiptNumber=receipt.ReceiptNumber;
    theDataObject.ProjectName=receipt.ProjectNumber;
//    theDataObject2.program.ProgramId=receipt.ProgramId;
//    theDataObject.warehouse.Id=receipt.WarehouseId;
    theDataObject.ReceiptId=receipt.ReceiptId;
    
    [self performSegueWithIdentifier:@"AddItem" sender:nil];
//    [self getProgramSavedReceipt:program];
    
}




-(void) loadReceiptList
{
    
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetRecentReceipts
        *request = [[EWHGetRecentReceipts alloc] initWithCallbacks:self callback:@selector(getReceiptsRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request getRecentReceipts:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId withAuthHash:user.AuthHash];
    }
}


-(void) getReceiptsRequestCallBack: (NSMutableArray*) results
{
    [rootController hideLoading];
    receipts = results;
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
    if ([[segue identifier] isEqualToString:@"AddItem"]) {
        EWHCreateReceiptController *createReceiptController = [segue destinationViewController];
//        createReceiptController.program = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    }
}


@end
