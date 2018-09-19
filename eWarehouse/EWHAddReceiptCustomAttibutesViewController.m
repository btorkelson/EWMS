//
//  EWHAddReceiptCustomAttibutesViewController.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/13/18.
//
//

#import "EWHAddReceiptCustomAttibutesViewController.h"

@interface EWHAddReceiptCustomAttibutesViewController ()



@end



@implementation EWHAddReceiptCustomAttibutesViewController

EWHRootViewController *rootController;
DTDevices *linea;

@synthesize visibleCustomAttributes;
@synthesize options;

EWHNewReceiptDataObject* theDataObject;
- (EWHNewReceiptDataObject*) theAppDataObject;
{
    id<AppDelegateProtocol> theDelegate =(id<AppDelegateProtocol>) [UIApplication sharedApplication].delegate;
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
//    [self.tableView reloadData];
    
    
//    [self.tableView reloadRowsAtIndexPaths:@[3] withRowAnimation:UITableViewRowAnimationNone];
//    int a = 1;
//    for (EWHInboundCustomAttribute *ca in visibleCustomAttributes) {
//
//    if (ca.CustomControlType == 4) {
//        NSIndexPath* rowToReload = [NSIndexPath indexPathForRow:a-1 inSection:0];
//        NSArray* rowsToReload = [NSArray arrayWithObjects:rowToReload, nil];
//        [self.tableView reloadRowsAtIndexPaths:rowsToReload withRowAnimation:UITableViewRowAnimationNone];
//    }
//    a++;
//
//    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Incomplete implementation, return the number of sections
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete implementation, return the number of rows
    
    return [visibleCustomAttributes count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
//    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:@"Cell"];
//    EWHWarehouse* warehouse = [[EWHWarehouse alloc] initWithDictionary:elem÷ent];
    
    
    EWHInboundCustomAttribute *ca = [visibleCustomAttributes objectAtIndex:indexPath.row];
    
        static NSString *CellIdentifier = @"Cell";
  
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell" forIndexPath:indexPath];
    
//    if ([cell.contentView viewWithTag:1]) {
//        UITextView *t = (UITextView *)[cell.contentView viewWithTag:1];
        //This version will take an existing textview and just resize it
        
//    } else {
  
//        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell.tag=indexPath.row;
    
    
        if (ca.CustomControlType == 1) {
            cell.detailTextLabel.hidden=true;
            cell.textLabel.hidden=true;
            UITextField *caTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
//            if ([self.tableView viewWithTag:indexPath.row]) {
//
//                caTextField.text=ca.Value;
//            } else {
            
                caTextField.adjustsFontSizeToFitWidth = YES;
                caTextField.textColor = [UIColor blackColor];
                
                caTextField.placeholder = ca.LabelCaption;
                if (ca.ReadOnly) {
                    [caTextField setEnabled: NO];
                } else {
                    [caTextField setEnabled: YES];
                }
                caTextField.text=nil;
                caTextField.text=ca.Value;
                caTextField.tag=indexPath.row;
                
                caTextField.delegate=self;
                [cell.contentView addSubview:caTextField];
//            }
            
        } else if (ca.CustomControlType == 4) {
            if ([ca.Value length]>0) {
                cell.detailTextLabel.text=ca.Value;
            } else {
                //            cell.detailTextLabel.text=@"";
            }
            cell.detailTextLabel.text=ca.Value;
            cell.textLabel.text=ca.LabelCaption;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            
            
        } else {
            
            cell.detailTextLabel.hidden=true;
            cell.textLabel.hidden=true;
            UITextField *caTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
            caTextField.adjustsFontSizeToFitWidth = YES;
            caTextField.textColor = [UIColor blackColor];
            
            caTextField.placeholder = ca.LabelCaption;
            [caTextField setEnabled: NO];
            caTextField.text = ca.Value;
            
            caTextField.tag=indexPath.row;
            caTextField.delegate=self;
            [cell.contentView addSubview:caTextField];
        }
//    }
    
    
    return cell;
    
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    EWHInboundCustomAttribute *ca = [visibleCustomAttributes objectAtIndex:textField.tag];
    ca.Value=textField.text;
    
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    EWHInboundCustomAttribute *ca = [visibleCustomAttributes objectAtIndex:indexPath.row];
    
    
    if (ca.CustomControlType == 4) {
        NSArray *items = [ca.OptionListString componentsSeparatedByString:@","];
        options = items;
        [self performSegueWithIdentifier:@"SelectOptions" sender:ca];
    }
    
    
}

- (IBAction)doneButtonPressed:(id)sender {
    
//    [self.tableView reloadData];
    
    [rootController showLoading];
    [self.view endEditing:YES];

    int error =0;
    int a =1;
    for (EWHInboundCustomAttribute *ca in visibleCustomAttributes) {

        if (ca.Required && ca.Value.length==0) {
            [rootController hideLoading];
            [rootController displayAlert:ca.ErrorMessage withTitle:@"Error"];
            error=1;
            break;
        }
    }


        EWHUser *user = rootController.user;

    if (error==0) {

        if(user != nil){


                EWHAddReceiptHeader
                *request = [[EWHAddReceiptHeader alloc] initWithCallbacks:self callback:@selector(addReceiptCallback:) errorCallback:@selector(errorCallback:) accessDeniedCallback:@selector(accessDeniedCallback)];
                //NSLog(hub);

                [request addReceiptHeader:theDataObject user:user];

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


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"SelectOptions"]) {
        
        EWHReceiptOptionsViewController *selectOptionsController = [segue destinationViewController];
        selectOptionsController.entity = @"Value";
        selectOptionsController.inboundCustomAttribute=sender;
        selectOptionsController.options= options;
    } else if ([[segue identifier] isEqualToString:@"ScanPart"]) {
        EWHScanPartController *selectOptionsController = [segue destinationViewController];
        //        selectOptionsController.entity = sender;
    } else if ([[segue identifier] isEqualToString:@"EnterCustomAttrs"]) {
        
        EWHAddReceiptCustomAttibutesViewController *selectOptionsController = [segue destinationViewController];
        selectOptionsController.visibleCustomAttributes = visibleCustomAttributes;
        //        selectOptionsController.entity = sender;
    }
}


@end
