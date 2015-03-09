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
    [self receiveItem:sender];
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
            return 2;
    }
}

-(void) receiveItem:(id)sender {
    [rootController showLoading];
    EWHUser *user = rootController.user;
    
    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
    if(user != nil){
        EWHAddReceiptXDockItem
        *request = [[EWHAddReceiptXDockItem alloc] initWithCallbacks:self callback:@selector(getReceiveItemRequestCallBack:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        //NSLog(hub);
        
        
        [request addReceiptItemforXDock:theDataObject.warehouse.Id programId:theDataObject.program.ProgramId receiptId:theDataObject.ReceiptId locationId:location.Id catalogId:catalog.CatalogId quantity:[txtQuantity.text integerValue] IsBulk:catalog.IsBulk customAttributes:catalog.CustomAttributeCatalogs itemScan:nil destinationId:destination.DestinationId inventoryTypeId:catalog.InventoryTypeId shipMethodId:theDataObject.shipmethod.ShipMethodId UOMs:catalog.UOMs deliveryDate:theDataObject.DeliveryDateTime user:user];
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

@end
