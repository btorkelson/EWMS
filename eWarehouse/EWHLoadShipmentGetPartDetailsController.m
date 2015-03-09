//
//  EWHLoadShipmentGetPartDetailsController.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoadShipmentGetPartDetailsController.h"

@implementation EWHLoadShipmentGetPartDetailsController
{

}

@synthesize shipment;
@synthesize shipmentDetail;
@synthesize warehouse;
@synthesize location;

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

-(IBAction) loadPressed: (id) sender
{
    int quantity = [txtQuantity.text intValue];
    if(shipmentDetail.Quantity == quantity)
        [self loadPart:quantity];
    else
        [rootController displayAlert:@"You must load the entire quantity for this item" withTitle:@"Error"];
}

-(void) loadPart:(int)quantity
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHLoadItemRequest *request = [[EWHLoadItemRequest alloc] initWithCallbacks:self callback:@selector(loadShipmentCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request loadItem:shipmentDetail warehouse:warehouse.Id location:location quantity:quantity user:user];
    }
}


-(void) loadShipmentCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    [rootController displayAlert:result.Message withTitle:@"Load Shipment"];
    if(result.Processed){
        [self getShipmentDetails:shipmentDetail.ShipmentId];
    }
    else {
        [self.navigationItem.rightBarButtonItem setEnabled:true];
    }
}

-(void) getShipmentDetails: (NSInteger)shipmentId
{
    [rootController showLoading];
    EWHGetShipmentDetailsForLoadingRequest *request = [[EWHGetShipmentDetailsForLoadingRequest alloc] initWithCallbacks:self callback:@selector(getShipmentDetailsCallback:) errorCallback:@selector(errorGetShipmentDetailsCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
    [request getShipmentDetailsForLoadingRequest:shipmentId withAuthHash:rootController.user.AuthHash];
}

-(void) getShipmentDetailsCallback: (NSMutableArray *) items
{
    [rootController hideLoading];
    if(items.count > 0)
        [rootController popToViewController:rootController.shipmentDetailsView animated:YES];
    else
        [rootController popToViewController:rootController.selectShipmentView animated:YES];
}

-(void) errorCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController displayAlert:error.localizedDescription withTitle:@"Load Shipment"];
}

-(void) errorGetShipmentDetailsCallback: (NSError*) error
{
    [rootController hideLoading];
    [rootController popToViewController:rootController.selectShipmentView animated:YES];
}

-(void) accessDeniedCallback
{
    [rootController hideLoading];
    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
    [rootController signOut];
}

@end
