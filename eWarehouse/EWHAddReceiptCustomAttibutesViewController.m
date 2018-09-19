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
@synthesize dropdownIndexPath;
@synthesize CATableView;


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



- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    [self.tableView reloadData];
    
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    EWHInboundCustomAttribute *ca = [visibleCustomAttributes objectAtIndex:indexPath.row];
    
    
    if (ca.CustomControlType == 1) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"TextCell"];
        cell.tag=indexPath.row;
        
            cell.detailTextLabel.hidden=true;
            cell.textLabel.hidden=true;
            
            UITextField *caTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
            
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
            
//                [cell.contentView addSubview:caTextField];
        
        return cell;
            
            
    } else if (ca.CustomControlType == 4) {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"DropDownCell"];
        cell.tag=indexPath.row;
        
            cell.detailTextLabel.text=ca.Value;
            cell.textLabel.text=ca.LabelCaption;
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        return cell;
            
    } else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
        cell.tag=indexPath.row;
        
//                cell.detailTextLabel.hidden=true;
//                cell.textLabel.hidden=true;
//                UITextField *caTextField = [[UITextField alloc] initWithFrame:CGRectMake(10, 10, 185, 30)];
//                caTextField.adjustsFontSizeToFitWidth = YES;
//                caTextField.textColor = [UIColor grayColor];
//                
//                caTextField.placeholder = ca.LabelCaption;
//                [caTextField setEnabled: NO];
//                caTextField.text = ca.Value;
//                
//                caTextField.tag=indexPath.row;
//                caTextField.delegate=self;
        //                [cell.contentView addSubview:caTextField];
        return cell;
        }
    
    
    
    
    
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
        dropdownIndexPath = indexPath;
        [self performSegueWithIdentifier:@"SelectOptions" sender:ca];
    } else if (ca.CustomControlType == 6) {
        ca.Value=@"true";
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
        selectOptionsController.dropdownIndexPath=dropdownIndexPath;
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
