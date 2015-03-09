//
//  EWHViewDestinationViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/27/14.
//
//

#import "EWHViewDestinationViewController.h"

@interface EWHViewDestinationViewController ()

@end

@implementation EWHViewDestinationViewController

@synthesize destination;
@synthesize location;
@synthesize catalog;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    EWHNewReceiptDataObject* theDataObject;
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    lblDestination.text=destination.Name;
    lblAddress1.text=destination.Address1;
    lblAddress2.text=destination.Address2;
    
    lblCityState.text=[NSString stringWithFormat:@"%@, %@ %@", destination.City, destination.State, destination.Zip];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //    EWHLocation *location = [locationByType.Locations objectAtIndex:indexPath.row];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
        theDataObject.lastDestination = destination;
        [self performSegueWithIdentifier:@"ReceiptItemConfirm" sender:destination];
    }
    
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([[segue identifier] isEqualToString:@"ReceiptItemConfirm"]) {
        EWHReceiptItemConfirmationViewController *viewConfirmController = [segue destinationViewController];
        viewConfirmController.destination=destination;
        viewConfirmController.location=location;
        viewConfirmController.catalog=catalog;
    }
}

#pragma mark - Table view data source



@end
