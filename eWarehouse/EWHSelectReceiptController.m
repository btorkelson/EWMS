//
//  EWHLoginClass.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/18/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHSelectReceiptController.h"
#import "EWHGetReceiptDetailsRequest.h"

@implementation EWHSelectReceiptController
{

}

@synthesize warehouse;
@synthesize receipts;

EWHRootViewController *rootController;
Linea *linea;

#pragma mark -
#pragma mark Table view data source

- (void) viewDidLoad{
    [super viewDidLoad];
    rootController = (EWHRootViewController *)self.navigationController;
    rootController.selectReceiptView = self;
}

-(void)viewWillAppear:(BOOL)animated
{
    linea = [Linea sharedDevice];
	[linea connect];
    [linea addDelegate:self];
}

- (void)viewDidAppear:(BOOL)animated{
    [self loadReceipts];
}


-(void)viewWillDisappear:(BOOL)animated
{
	[linea removeDelegate:self];
    [linea disconnect];
    linea = nil;
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft ||
            toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

-(void) loadReceipts
{
    [rootController showLoading];
    EWHUser *user = rootController.user;
    if(user != nil){
        EWHGetWarehouseReceiptListRequest *request = [[EWHGetWarehouseReceiptListRequest alloc] initWithCallbacks:self callback:@selector(getReceiptListCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
        [request getWarehouseReceiptListRequest:warehouse.Id withAuthHash:user.AuthHash];
    }
}

-(void) getReceiptListCallback: (NSMutableArray*) results
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Only one section.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    // Only one section, so return the number of items in the list.
    return [receipts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
	static NSString *CellIdentifier = @"ReceiptCell";
	
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    // Get the object to display and set the value in the cell.
    EWHReceipt *receipt = [receipts objectAtIndex:indexPath.row];
    
    cell.textLabel.text = receipt.ReceiptNumber;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", [EWHUtils.dateFormatter stringFromDate:receipt.ReceivedDate], receipt.ProgramName];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHReceipt *receipt = [receipts objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ScanItem" sender:receipt];
}

-(IBAction) refreshPressed: (id) sender
{
    [self loadReceipts];
}

-(void) stopScan{
    NSError *error = nil;
    int scanMode;
    
    if([linea getScanMode:&scanMode error:&error] && scanMode!=MODE_MOTION_DETECT)
        [linea stopScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(void)barcodeData:(NSString *)barcode isotype:(NSString *)isotype {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        [self validateScan:barcode];
    }
}

-(void) validateScan: (NSString *)barcode{
    //Z - remove in production
//    barcode = @"58668";
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"ReceiptNumber == %@", barcode];
    NSArray *matches = [receipts filteredArrayUsingPredicate:predicate];
    EWHLog(@"Matches count:%d", [matches count]);
    if([matches count] > 0){
        EWHReceipt *receipt = [matches objectAtIndex:0];
        [self performSegueWithIdentifier:@"ScanItem" sender:receipt];
    }
    else {
        [rootController displayAlert:@"Incorrect receipt" withTitle:@"Receipt"];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ScanItem"]) {
        EWHScanItemController *scanItemController = [segue destinationViewController];
        scanItemController.receipt = sender;
        scanItemController.warehouse = warehouse;
        //Z - remove in production
//        [self getDetails:scanItemController.receipt.ReceiptId];
    }
}

//Z - remove in production
//-(void) getDetails: (NSInteger)receiptId
//{
//    EWHGetReceiptDetailsRequest *request = [[EWHGetReceiptDetailsRequest alloc] initWithCallbacks:self callback:nil errorCallback:nil accessDeniedCallback:nil];
//    [request getReceiptDetails:receiptId withAuthHash:rootController.user.AuthHash];
//}

@end
