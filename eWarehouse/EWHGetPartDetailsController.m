//
//  EWHGetPartDetailsController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHGetPartDetailsController.h"

@implementation EWHGetPartDetailsController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;
@synthesize storagelocation;

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
    lblProgramName.text = shipment.ProgramName;
    lblShipmentNumber.text = shipment.ShipmentNumber;
    lblReceivedDate.text = [EWHUtils.dateFormatter stringFromDate:shipment.DeliveryDate];
    lblShipmentDetailNumber.text = shipmentDetail.Number;
    lblQuantity.text = [NSString stringWithFormat:@"of %d", shipmentDetail.Quantity];
    [stepper setMinimumValue:1];
    [stepper setMaximumValue:shipmentDetail.Quantity];
    if(shipmentDetail.Quantity == 1)
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
    if(qty > shipmentDetail.Quantity) {
        qty = shipmentDetail.Quantity;
        sender.text = [NSString stringWithFormat:@"%d", qty];
    }
    
    stepper.value = qty;
    [stepper setEnabled:YES];
}

-(IBAction) nextPressed: (id) sender
{
    if(shipmentDetail.Quantity == [txtQuantity.text intValue])
        [self performSegueWithIdentifier:@"ScanLocation" sender:nil];
    else
        [rootController displayAlert:@"You must pick the entire quantity for this item" withTitle:@"Error"];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([[segue identifier] isEqualToString:@"ScanLocation"]) {
        EWHPickShipmentScanLocationController *scanLocationController = [segue destinationViewController];
        scanLocationController.shipment = shipment;
        scanLocationController.shipmentDetail = shipmentDetail;
        scanLocationController.warehouse = warehouse;
        scanLocationController.location = location;
        scanLocationController.quantity = [txtQuantity.text integerValue];
        scanLocationController.storagelocation = storagelocation;
    }
}

@end
