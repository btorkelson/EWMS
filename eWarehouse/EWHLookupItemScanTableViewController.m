//
//  EWHLookupItemScanTableViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 12/17/20.
//

#import "EWHLookupItemScanTableViewController.h"

@interface EWHLookupItemScanTableViewController ()

@end

@implementation EWHLookupItemScanTableViewController

EWHRootViewController *rootController;
DTDevices *linea;
@synthesize warehouse;
@synthesize currentTextField;
@synthesize txtPartNumber;
@synthesize txtSerialNumber;

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
    
    linea = [DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    return 2;
}



- (IBAction)searchClicked:(id)sender {
    if (txtPartNumber.text.length==0 && txtSerialNumber.text.length==0) {
        [rootController displayAlert:@"Please enter Part Number and/or Serial" withTitle:@"Item Search"];
    } else {
        [self performSegueWithIdentifier:@"Show Items" sender:nil];
    }
    
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    [txtPartNumber resignFirstResponder];
    [txtSerialNumber resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    currentTextField=textField;
//    EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
//    theDataObject.ProjectName = txtProjectNumber.text;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
}

- (void)textViewDidBeginEditing:(UITextView *)textView
{
    
    [textView becomeFirstResponder];
}

- (void)textViewDidEndEditing:(UITextView *)textView
{
    if ([textView.text isEqualToString:@""]) {
        textView.text = @"Comment";
        textView.textColor = [UIColor lightGrayColor]; //optional
    }
    [textView resignFirstResponder];
}

-(IBAction)scanPressed:(id)sender;
{
    NSError *error = nil;
    
//    currentTextField.text = @"test";
//    [txtProjectNumber isfirstresponder]
    [linea startScan:&error];
    if(error != nil)
        [rootController displayAlert:error.localizedDescription withTitle:@"Error"];
}

-(IBAction)scanItemUp:(id)sender;
{
        [self stopScan];
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
        currentTextField.text= barcode;
    }
    //    [self updateBattery];
}

-(void)barcodeData:(NSString *)barcode type:(int)type {
    if(self.navigationController.visibleViewController == self){
        [self stopScan];
        currentTextField.text= barcode;
    }
    //    [self updateBattery];
}

-(void)connectionState:(int)state {
    switch (state) {
        case CONN_DISCONNECTED:
        case CONN_CONNECTING:
            //            [btnScanPart setHidden:true];
            break;
        case CONN_CONNECTED:
            //[btnScan setHidden:false];
            //Z - remove in production
            //            [linea setScanBeep:false volume:0 beepData:nil length:0];
            break;
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"Show Items"]) {
        EWHLookupItemTableViewController *selectController = [segue destinationViewController];
        selectController.warehouse=warehouse;
        selectController.PartNumber=txtPartNumber.text;
        selectController.SerialNumber=txtSerialNumber.text;
    }
}
@end
