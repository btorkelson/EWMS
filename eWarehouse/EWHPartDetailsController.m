//
//  EWHPartDetailsController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHPartDetailsController.h"

@implementation EWHPartDetailsController
{

}

@synthesize receipt;
@synthesize receiptDetails;
@synthesize warehouse;

EWHRootViewController *rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    
    [self updateInterface];
    
    UITapGestureRecognizer *viewBackgroundTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(backgroundTap:)];
    viewBackgroundTap.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:viewBackgroundTap];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(IBAction)backgroundTap:(id)sender
{
    [txtQuantity resignFirstResponder];
}

- (void)updateInterface
{
    lblReceiptNumber.text = receipt.ReceiptNumber;
    lblPartNumber.text = receiptDetails.PartNumber;
    lblQuantity.text = [NSString stringWithFormat:@"of %d", receiptDetails.Quantity];
    [stepper setMinimumValue:1];
    [stepper setMaximumValue:receiptDetails.Quantity];
    if(receiptDetails.Quantity == 1)
        [txtQuantity setEnabled:NO];
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
    if(qty > receiptDetails.Quantity) {
        qty = receiptDetails.Quantity;
        sender.text = [NSString stringWithFormat:@"%d", qty];
    }
    
    stepper.value = qty;
    [stepper setEnabled:YES];
}

-(IBAction) nextPressed: (id) sender
{
    [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.receipt = receipt;
        scanLocationController.receiptDetails = receiptDetails;
        scanLocationController.quantity = [txtQuantity.text integerValue];
        scanLocationController.warehouse = warehouse;
    }
    
}

@end
