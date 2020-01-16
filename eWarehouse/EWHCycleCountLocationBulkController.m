//
//  EWHCycleCountLocationBulkController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/13/20.
//

#import "EWHCycleCountLocationBulkController.h"

@interface EWHCycleCountLocationBulkController ()

@end

@implementation EWHCycleCountLocationBulkController

@synthesize txtQuantity;
@synthesize lblBulkSerial;
@synthesize lblPartNumber;
@synthesize lblDescription;
@synthesize stepper;
@synthesize catalog;
@synthesize location;

- (void)viewDidLoad {
    [super viewDidLoad];
    [stepper setEnabled:YES];
    [self updateInterface];
    
    UITapGestureRecognizer *viewBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    viewBackgroundTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewBackgroundTap];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)backgroundTap:(id)sender
{
    [txtQuantity resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 2;
}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}



- (void)updateInterface
{
    lblPartNumber.text = catalog.ItemNumber;
    lblDescription.text = catalog.ProgramName;
    lblBulkSerial.text = @"Bulk";
    
//    lblTotalQty.text = [NSString stringWithFormat:@"of %d", catalog.Qty];
    
    [stepper setEnabled:YES];
    txtQuantity.text = [NSString stringWithFormat:@"%d", (int)catalog.QuantityScanned];
    stepper.value = [txtQuantity.text integerValue];
    [stepper setMinimumValue:0];
    [stepper setMaximumValue:1000];
}

- (IBAction)stepperValueChanged:(UIStepper *)sender
{
    txtQuantity.text = [NSString stringWithFormat:@"%d", (int)sender.value];
}

- (IBAction)quantityChanged:(UITextField *) sender
{
    stepper.value = [sender.text integerValue];
}

- (IBAction)quantityEditingDidBegin:(UITextField *) sender
{
    [stepper setEnabled:NO];
}

- (IBAction)quantityEditingDidEnd:(UITextField *) sender
{
    int qty = [sender.text integerValue];
    if(qty < 1){
        qty = 0;
        sender.text = [NSString stringWithFormat:@"%d", qty];
    }
    
//    if(qty > catalog.Qty) {
//        qty = catalog.Qty;
//        sender.text = [NSString stringWithFormat:@"%d", qty];
//    }
    
    
    stepper.value = qty;
    [stepper setEnabled:YES];
}
- (IBAction)nextPressed:(id)sender {
//    int qty = [txtQuantity.text integerValue];
//    if(qty > catalog.Qty) {
//        qty = catalog.Qty;
//        txtQuantity.text = [NSString stringWithFormat:@"%d", qty];
//    }
//    txtQuantity.text = [NSString stringWithFormat:@"%d", (int)stepper.value];
    
    
//    stepper.value = qty;
//    [self performSegueWithIdentifier:@"TransferNewLocation" sender:nil];
    
    
    catalog.QuantityScanned=[txtQuantity.text integerValue];
    
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TransferNewLocation"]) {
//        EWHTransferScanNewLocation *selectReceiptController = [segue destinationViewController];
//        selectReceiptController.warehouse = warehouse;
//        selectReceiptController.location= location;
//        selectReceiptController.catalog=catalog;
//        selectReceiptController.quantity=[txtQuantity.text integerValue];
    }
}

@end
