//
//  EWHAddCatalogCustomAttributesViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 12/9/20.
//

#import "EWHAddCatalogCustomAttributesViewController.h"



@implementation EWHAddCatalogCustomAttributesViewController

EWHRootViewController *rootController;
DTDevices *linea;

@synthesize visibleCustomAttributes;
@synthesize options;
@synthesize dropdownIndexPath;
@synthesize CATableView;
@synthesize catalog;
@synthesize currentTextField;

EWHNewReceiptDataObject* theDataObject;
- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
    theDataObject = (EWHNewReceiptDataObject*) theDelegate.theAppDataObject;
    return theDataObject;
    
}
- (void)viewDidLoad {
    [super viewDidLoad];
    visibleCustomAttributes=catalog.CustomAttributeCatalogs;
    
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    return [visibleCustomAttributes count];
}



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
    linea = [DTDevices sharedDevice];
    [linea connect];
    [linea addDelegate:self];
    //update display according to current linea state
    [self connectionState:linea.connstate];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EWHCustomAttributeCatalog *ca = [visibleCustomAttributes objectAtIndex:indexPath.row];
    
    UITableViewCell *cell;
    if (ca.CustomControlType == 1 || ca.CustomControlType ==2 || ca.CustomControlType == 3) {
        EWHCellforTextLabelTableViewCell *textcell = (EWHCellforTextLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellforTextLabel"];

        if (!textcell) {
            [tableView registerNib:[UINib nibWithNibName:@"EWHCellforTextLabelTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellforTextLabel"];
            textcell = [tableView dequeueReusableCellWithIdentifier:@"CellforTextLabel"];

        }

//            textcell.detailTextLabel.hidden=true;
//            textcell.textLabel.hidden=true;
//        textcell.detailTextLabel.text=ca.Value;
//        textcell.textLabel.text=ca.Name;
        textcell.lblTextLabel.text=ca.Name;


            UITextField *caTextField = (UITextField *)[textcell tfCustomAttributeText];
            caTextField.adjustsFontSizeToFitWidth = YES;
            caTextField.textColor = [UIColor blackColor];

            //caTextField.placeholder = ca.Name;
            if (ca.Editable) {
                [caTextField setEnabled: YES];
            } else {
                [caTextField setEnabled: NO];
            }
        //[caTextField setHidden:YES];
            caTextField.text=nil;
            caTextField.text=ca.Value;
            caTextField.tag=indexPath.row;

            caTextField.delegate=self;
            textcell.tfCustomAttributeText=caTextField;

            cell = textcell;
        
//        cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
//        cell.tag=indexPath.row;
//
//            cell.detailTextLabel.text=ca.Value;
//            cell.textLabel.text=ca.Name;
            
    } else if (ca.CustomControlType == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.tag=indexPath.row;

            cell.detailTextLabel.text=ca.Value;
            cell.textLabel.text=ca.Name;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
        
    } else if (ca.CustomControlType == 6) {

            EWHCellforCheckboxTableViewCell *checkboxcell = (EWHCellforCheckboxTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellforCheckbox"];

            if (!checkboxcell) {
                [tableView registerNib:[UINib nibWithNibName:@"EWHCellforCheckboxTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellforCheckbox"];
                checkboxcell = [tableView dequeueReusableCellWithIdentifier:@"CellforCheckbox"];

            }

            checkboxcell.detailTextLabel.hidden=true;
            checkboxcell.textLabel.hidden=true;


            UISwitch *caSwitch = (UISwitch *)[checkboxcell swCustomAttributeSwitch];

        if ([ca.Value isEqual:@"1"]) {
            caSwitch.on=true;
        }

            checkboxcell.txtCellLabel.text = ca.Name;
            if (ca.Editable) {
                [caSwitch setEnabled: YES];
            } else {
                [caSwitch setEnabled: NO];
            }
        caSwitch.tag = indexPath.row;
        [caSwitch addTarget:self action:@selector(updateSwitchAtIndexPath:) forControlEvents:UIControlEventTouchUpInside];

            checkboxcell.tag=indexPath.row;


            cell = checkboxcell;


    } else {
        EWHCellforTextLabelTableViewCell *textlabelcell = (EWHCellforTextLabelTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"CellforTextLabel"];

        if (!textlabelcell) {
            [tableView registerNib:[UINib nibWithNibName:@"EWHCellforTextLabelTableViewCell" bundle:nil] forCellReuseIdentifier:@"CellforTextLabel"];
            textlabelcell = [tableView dequeueReusableCellWithIdentifier:@"CellforTextLabel"];

        }

        textlabelcell.detailTextLabel.hidden=true;
        textlabelcell.textLabel.hidden=true;
        textlabelcell.lblTextLabel.text=ca.Name;


        UITextField *caTextField = (UITextField *)[textlabelcell tfCustomAttributeText];
        caTextField.adjustsFontSizeToFitWidth = YES;
        caTextField.textColor = [UIColor blackColor];

        //caTextField.placeholder = ca.Name;
    
        if (ca.Editable) {
            [caTextField setEnabled: YES];
        } else {
            [caTextField setEnabled: NO];
        }
        caTextField.text=nil;
        caTextField.text=ca.Value;
        caTextField.tag=indexPath.row;
        

        caTextField.delegate=self;
        textlabelcell.tfCustomAttributeText=caTextField;
    
        cell = textlabelcell;
        }
    
    
    
    
    return cell;
    
}


- (void)updateSwitchAtIndexPath:(UISwitch *)aswitch{
    
    EWHInboundCustomAttribute *ca = [visibleCustomAttributes objectAtIndex:aswitch.tag];
        if ([aswitch isOn]) {
            ca.Value=@"1";
        } else {
//            [aswitch setOn:YES animated:YES];
            ca.Value=@"0";
        }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    currentTextField=textField;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    EWHCustomAttributeCatalog *ca = [visibleCustomAttributes objectAtIndex:textField.tag];
    ca.Value=textField.text;
    [textField resignFirstResponder];
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return TRUE;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    EWHCustomAttributeCatalog *ca = [visibleCustomAttributes objectAtIndex:indexPath.row];
    
     if (ca.CustomControlType == 4) {
        NSArray *items = [ca.OptionListString componentsSeparatedByString:@","];
        options = items;
        dropdownIndexPath = indexPath;
        [self performSegueWithIdentifier:@"SelectOptions" sender:ca];
    }
}

- (void)switchChanged:(id)sender {
    UISwitch *switchControl = sender;
//    CGPoint switchPositionPoint = [sender convertPoint:CGPointZero toView:[self]];
//    NSIndexPath *indexPath = [[self tableName] indexPathForRowAtPoint:switchPositionPoint];

}


-(void) updateDropDown:(NSIndexPath *)indexPath {
    
    
//    NSArray* rowsToReload = [NSArray arrayWithObjects:indexPath, nil];
//    [CATableView beginUpdates];
//    [CATableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationFade];
//    [CATableView endUpdates];
    
    
//    NSIndexPath *indexPath2 = [NSIndexPath indexPathForRow:2 inSection:0];
//    NSArray *indexPaths = [[NSArray alloc] initWithObjects:indexPath2, nil];
//    [CATableView reloadRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationTop];
//    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
//    cell.detailTextLabel.text= @"test";
}

- (IBAction)doneButtonPressed:(id)sender {
    
//    [self.tableView reloadData];
    
    [rootController showLoading];
    [self.view endEditing:YES];

    int error =0;
    int a =1;
    for (EWHCustomAttributeCatalog *ca in visibleCustomAttributes) {
        
        if (ca.CustomControlType == 1 ) {
        
            if (ca.Required && ca.Value.length==0) {
                [rootController hideLoading];
                [rootController displayAlert:ca.ErrorMessage withTitle:@"Error"];
                error=1;
                break;
            }
        } else if (ca.CustomControlType == 2) {
            
                NSCharacterSet* notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789"] invertedSet];
                if ([ca.Value rangeOfCharacterFromSet:notDigits].location != NSNotFound)
                {
                    [rootController hideLoading];
                    NSString *msg = [NSString stringWithFormat:@"%@ %@", ca.Name, @"must be a number/decimal"];
                    [rootController displayAlert:msg  withTitle:@"Error"];
                    error=1;
                    break;
                }
                if (ca.Required && ca.Value.length==0) {
                    [rootController hideLoading];
                    [rootController displayAlert:ca.ErrorMessage withTitle:@"Error"];
                    error=1;
                    break;
                }
        } else if (ca.CustomControlType == 3) {
            
                NSCharacterSet* notDigits = [[NSCharacterSet characterSetWithCharactersInString:@"0123456789."] invertedSet];
                if ([ca.Value rangeOfCharacterFromSet:notDigits].location != NSNotFound)
                {
                    [rootController hideLoading];
                    NSString *msg = [NSString stringWithFormat:@"%@ %@", ca.Name, @"must be a number/decimal"];
                    [rootController displayAlert:msg  withTitle:@"Error"];
                    error=1;
                    break;
                }
                if (ca.Required && ca.Value.length==0) {
                    [rootController hideLoading];
                    [rootController displayAlert:ca.ErrorMessage withTitle:@"Error"];
                    error=1;
                    break;
                }
        } else  {
            if (ca.Required && ca.Value.length==0) {
                [rootController hideLoading];
                [rootController displayAlert:ca.ErrorMessage withTitle:@"Error"];
                error=1;
                break;
            }
        }
        
    }


        EWHUser *user = rootController.user;

    if (error==0) {

        if(user != nil){

            
                [self performSegueWithIdentifier:@"SelectLocation" sender:nil];

        }
    }
    
}



-(void) addReceiptCallback: (EWHResponse *) result
{
    [rootController hideLoading];
    //    [rootController displayAlert:result.Message withTitle:@"Result"];
    if (result.Id != -1) {
        EWHNewReceiptDataObject* theDataObject = [self theAppDataObject];
        theDataObject.ReceiptId = result.Id;
        theDataObject.ReceiptNumber = result.Number;
        
        [self performSegueWithIdentifier:@"ScanPart" sender:nil];
        
        
    } else {
        [rootController displayAlert:result.Message withTitle:@"Error"];
    }
    
    
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



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SelectOptions"]) {
        
        EWHReceiptOptionsViewController *selectOptionsController = [segue destinationViewController];
        selectOptionsController.entity = @"Value";
        selectOptionsController.inboundCustomAttribute=sender;
        selectOptionsController.options= options;
        selectOptionsController.dropdownIndexPath=dropdownIndexPath;
    } else if ([[segue identifier] isEqualToString:@"SelectLocation"]) {
        EWHSelectStorageLocationViewController *selectLocationController = [segue destinationViewController];
        selectLocationController.catalog = catalog;
        
    }
}
@end
