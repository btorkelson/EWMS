//
//  EWHReceiptItemConfirmationViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 11/5/14.
//
//

#import "EWHReceiptItemConfirmationViewController.h"

@interface EWHReceiptItemConfirmationViewController ()

@end

@implementation EWHReceiptItemConfirmationViewController

@synthesize catalog;
@synthesize location;
@synthesize destination;
@synthesize SerialNumbers;

EWHRootViewController *rootController;

EWHNewReceiptDataObject* theDataObject;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    //
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rootController = (EWHRootViewController *)self.navigationController;
    
    UITapGestureRecognizer *viewBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    viewBackgroundTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewBackgroundTap];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    
    lblReceiptNumber.text = theDataObject.ReceiptNumber;
    lblLocation.text = location.Name;
    lblDestination.text = destination.Name;
    lblPartNumber.text = catalog.ItemNumber;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}


- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    txtQuantity.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (IBAction)quantityChanged:(UITextField *) sender
{
    stQuantityStepper.value = [sender.text integerValue];
}

- (IBAction)quantityEditingDidBegin:(UITextField *) sender
{
    [stQuantityStepper setEnabled:NO];
}

- (IBAction)quantityEditingDidEnd:(UITextField *) sender
{

    
    stQuantityStepper.value = [sender.text integerValue];
    [stQuantityStepper setEnabled:YES];
}

- (IBAction)addItemPressed:(id)sender {
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if (theDataObject.program.IsReceiptToOrder) {
        [self receiveXDockItem:sender];
    } else {
        [self receiveItem:sender];
    }
    
}

-(IBAction)backgroundTap:(id)sender
{
    [txtQuantity resignFirstResponder];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    switch (section) {
        case 0:
            
            if (theDataObject.program.IsReceiptToOrder == NO) {
                return 2;
            } else {
                return 3;
            }
        case 1:
            return 4;
    }
}

-(void) receiveXDockItem:(id)sender {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptXDockItem
        *request = [[EWHAddReceiptXDockItem alloc] initWithCallbacks:self callback:@selector(getReceiveXDockItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request addReceiptItemforXDock:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location.Id catalogId:catalog.CatalogId quantity:[txtQuantity.text integerValue] IsBulk:catalog.IsBulk customAttributes:catalog.CustomAttributeCatalogs itemScan:nil destinationId:destination.DestinationId inventoryTypeId:catalog.InventoryTypeId shipMethodId:theDataObject.shipmethod.ShipMethodId UOMs:catalog.UOMs deliveryDate:theDataObject.DeliveryDateTime user:user lineNumber:txtLineNumber.text lotNumber:txtLotNumber.text];
    }
}


-(void) getReceiveXDockItemRequestCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    //    destinations = results;
    //    [rootController displayAlert:results.Message withTitle:@"Result"];
    
    if (results.Processed == 1) {
    [rootController popToViewController:rootController.selectItemforReceiptView animated:YES];
    } else {
        [rootController displayAlert:results.Message withTitle:@"Error"];
    }
    //    [self.navigationController popViewControllerAnimated:YES];
}



-(void) receiveItem:(id)sender {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptItem
        *request = [[EWHAddReceiptItem alloc] initWithCallbacks:self callback:@selector(getReceiveItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        [request addReceiptItem:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location.Id catalogId:catalog.CatalogId quantity:[txtQuantity.text integerValue] IsBulk:catalog.IsBulk IsSerialized:catalog.IsSerial itemScan:SerialNumbers user:user inventoryTypeId:catalog.InventoryTypeId customAttributes:catalog.CustomAttributeCatalogs UOMs:catalog.UOMs lineNumber:txtLineNumber.text lotNumber:txtLotNumber.text];
        
        
        //        [request ad:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:_location.Id catalogId:_catalog.CatalogId quantity:1 IsBulk:_catalog.IsBulk itemScan:nil destinationId:destination shipMethodId:theDataObject.shipmethod.ShipMethodId user:user];
    }
}


-(void) getReceiveItemRequestCallBack: (EWHResponse*) results
{
    [rootController hideLoading];
    if (results.Processed == 1) {
        [rootController popToViewController:rootController.selectItemforReceiptView animated:YES];
    } else {
        [rootController displayAlert:results.Message withTitle:@"Error"];
    }
    //    destinations = results;
    //    [rootController displayAlert:results.Message withTitle:@"Result"];
    
    //    [self.navigationController popViewControllerAnimated:YES];
}


-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

@end
