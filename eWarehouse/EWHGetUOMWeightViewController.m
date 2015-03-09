//
//  EWHGetUOMWeightViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 10/31/14.
//
//

#import "EWHGetUOMWeightViewController.h"

@interface EWHGetUOMWeightViewController ()

@end

@implementation EWHGetUOMWeightViewController

@synthesize catalog;
@synthesize UOMWeights;
@synthesize UOMWeightsFinal;

EWHRootViewController *rootController;

EWHNewReceiptDataObject* theDataObject;

- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    //
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    rootController = (EWHRootViewController *)self.navigationController;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    NSPredicate *resultPredicate = [NSPredicate predicateWithFormat:@"UnitOfMeasureType == 2"];
    UOMWeights = [catalog.UOMs filteredArrayUsingPredicate:resultPredicate];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    //One column
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    //set number of rows
    return [UOMWeights count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    //set item per row
    EWHUOM *uom = [UOMWeights objectAtIndex:row];
//    destination = [destinationType.Destinations objectAtIndex:indexPath.row];
    return uom.UnitOfMeasureName;
}

- (IBAction)nextPressed:(id)sender {
    
//        customAttribute.Value = txtCustomAttributeValue.text;
//    
//        [[catalog.UOMs objectAtIndex:CAindex] setValue:txtCustomAttributeValue.text forKey:@"Value"];
//
    NSInteger row = [pkUOMOption selectedRowInComponent:0];
    EWHUOM *uom = [UOMWeights objectAtIndex:(NSUInteger)row];
//    double uomDecimal= [txtUOMWeight.text doubleValue];
    uom.Value = [NSDecimalNumber decimalNumberWithString:txtUOMWeight.text];
    NSMutableArray *items = [[NSMutableArray alloc] init];
    [items addObject:uom];
    catalog.UOMs = [items copy];
    
    if (theDataObject.PromptInventoryType) {
        [self performSegueWithIdentifier:@"SelectInventoryType" sender:catalog];
    } else {
        catalog.InventoryTypeId = theDataObject.inventorytypeId;
        if ([catalog.CustomAttributeCatalogs count]>0) {
            [self performSegueWithIdentifier:@"GetCustomAttributeCatalog" sender:catalog];
        } else {
            
            [self performSegueWithIdentifier:@"SelectLocation" sender:catalog];
        }
    }
    
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
        EWHSelectStorageLocationViewController *selectLocationController = [segue destinationViewController];
        selectLocationController.catalog = sender;
        //Z - remove in production
        //        [self getDetails:scanItemController.receipt.ReceiptId];
    } else if ([[segue identifier] isEqualToString:@"GetCustomAttributeCatalog"]) {
        
        EWHGetCustomAttributeCatalogViewController *getCACscontroller = [segue destinationViewController];
        getCACscontroller.catalog = sender;
        getCACscontroller.CAindex = 0;
    }else if ([[segue identifier] isEqualToString:@"SelectInventoryType"]) {
        
        EWHSelectInventoryTypeViewController *getITscontroller = [segue destinationViewController];
        getITscontroller.catalog = sender;
    }
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
