//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHContainerDetailsController.h"

@implementation EWHContainerDetailsController
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
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)updateInterface
{
    lblReceiptNumber.text = receipt.ReceiptNumber;
    lblContainerNumber.text = receiptDetails.Number;
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
        scanLocationController.warehouse = warehouse;
    }
    
}
@end
