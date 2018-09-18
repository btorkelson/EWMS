//
//  EWHTransferQuantitySerials.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/25/17.
//
//

#import "EWHTransferQuantitySerials.h"

@interface EWHTransferQuantitySerials ()

@end

@implementation EWHTransferQuantitySerials

@synthesize warehouse;
@synthesize location;
@synthesize catalog;
@synthesize lblPartNumber;
@synthesize lblDescription;
@synthesize lblBulk;
@synthesize txtQuantity;
@synthesize stepper;
EWHRootViewController *rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    lblDescription.text = catalog.Description;
    lblBulk.text = @"Bulk";
    
    [stepper setMinimumValue:1];
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
        qty = 1;
        sender.text = [NSString stringWithFormat:@"%d", qty];
    }
    
    
    stepper.value = qty;
    [stepper setEnabled:YES];
}
- (IBAction)nextPressed:(id)sender {
    [self performSegueWithIdentifier:@"TransferNewLocation" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"TransferNewLocation"]) {
        EWHTransferScanNewLocation *selectReceiptController = [segue destinationViewController];
        selectReceiptController.warehouse = warehouse;
        selectReceiptController.location= location;
        selectReceiptController.catalog=catalog;
        selectReceiptController.quantity=[txtQuantity.text integerValue];
    }
}


@end
