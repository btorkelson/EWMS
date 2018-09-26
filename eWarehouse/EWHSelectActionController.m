//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSelectActionController.h"

@implementation EWHSelectActionController
{

}

@synthesize warehouse;

EWHRootViewController *rootController;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.selectActionView = self;
    [rootController navigationItem].hidesBackButton = NO;
}

- (void)viewWillAppear:(BOOL)animated
{
    [(UIScrollView *)self.view setContentSize: CGSizeMake(self.view.frame.size.width, CONTENT_HEIGHT)];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

//- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
//{
//
//}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [(UIScrollView *)self.view setContentSize: CGSizeMake(self.view.frame.size.width, CONTENT_HEIGHT)];
//    [self.view setNeedsDisplay];
}

-(IBAction) putAwayPressed: (id) sender 
{
    [self performSegueWithIdentifier:@"ShowReceipts" sender:nil];
//    [rootController showLoading];
//    EWHUser *user = rootController.user;
//    if(user != nil){
//        EWHGetWarehouseReceiptListRequest *request = [[EWHGetWarehouseReceiptListRequest alloc] initWithCallbacks:self callback:@selector(getReceiptListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
//        [request getWarehouseReceiptListRequest:warehouse.Id withAuthHash:user.AuthHash];
//    }
}

//-(void) getReceiptListCallback: (NSMutableArray*) receipts
//{
//    [rootController hideLoading];
//    [self performSegueWithIdentifier:@"ShowReceipts" sender:receipts];
//}
//
//-(void) errorCallback: (NSError*) error
//{
//    [rootController hideLoading];
//    [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
//}
//
//-(void) accessDeniedCallback
//{
//    [rootController hideLoading];
//    [rootController displayAlert:@"Session has timed out. Please sign in." withTitle:@"Session"];
//    [rootController signOut];
//}

- (IBAction)signOut:(id)sender
{
    [rootController signOut];
}

-(IBAction) pickShipmentPressed: (id) sender 
{
    [self performSegueWithIdentifier:@"ShowShipments" sender:nil];
}

-(IBAction) loadShipmentPressed: (id) sender
{
    [self performSegueWithIdentifier:@"ShowLoadShipments" sender:nil];
}

-(IBAction) cycleCountPressed: (id) sender
{
    [self performSegueWithIdentifier:@"CycleCount" sender:nil];
}


-(IBAction) lookupItemPressed: (id) sender
{
    [self performSegueWithIdentifier:@"lookup item" sender:nil];
}

-(IBAction) newReceiptPressed: (id) sender
{
    [self performSegueWithIdentifier:@"NewReceipt" sender:nil];
}
- (IBAction)transferPressed:(id)sender {
     [self performSegueWithIdentifier:@"Transfer" sender:nil];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"ShowReceipts"]) {
        EWHSelectReceiptController *selectReceiptController = [segue destinationViewController];
        selectReceiptController.warehouse = warehouse;
    }
    else if ([[segue identifier] isEqualToString:@"ShowShipments"]) {
        EWHSelectShipmentController *selectShipmentController = [segue destinationViewController];
        selectShipmentController.warehouse = warehouse;
    }
    else if ([[segue identifier] isEqualToString:@"ShowLoadShipments"]) {
        EWHLoadShipmentSelectShipmentController *selectShipmentController = [segue destinationViewController];
        selectShipmentController.warehouse = warehouse;
    }
    
    else if ([[segue identifier] isEqualToString:@"NewReceipt"]) {
        EWHSelectProgramforReceiptController *selectProgramController = [segue destinationViewController];
        selectProgramController.warehouse = warehouse;
    }
    else if ([[segue identifier] isEqualToString:@"Transfer"]) {
        EWHTransferSelectProgram *selectTransferController = [segue destinationViewController];
        selectTransferController.warehouse = warehouse;
    }
    else if ([[segue identifier] isEqualToString:@"CycleCount"]) {
        EWHSelectCylceCountJobController *selectCycleCountController = [segue destinationViewController];
        selectCycleCountController.warehouse = warehouse;
    }
}

@end
