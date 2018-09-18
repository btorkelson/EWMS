//
//  EWHCreateReceiptControllerViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/31/14.
//
//

#import <Foundation/Foundation.h>
#import "EWHRootViewController.h"
#import "EWHProgram.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHAppDelegateProtocal.h"
#import "EWHReceiptOptionsViewController.h"
#import "EWHAddReceiptHeader.h"
#import "EWHScanPartController.h"
#import "DTDevices.h"
#import "EWHAddReceiptCustomAttibutesViewController.h"


@interface EWHCreateReceiptController : UITableViewController
{
    IBOutlet UITextField *txtProjectNumber;
    IBOutlet UITextField *txtProjectSequence;
    IBOutlet UITextField *txtCarrierTracking;
    IBOutlet UILabel *lblVendor;
    IBOutlet UILabel *lblCarrier;
    IBOutlet UILabel *lblOrigin;
    IBOutlet UILabel *lblShipMethod;
    IBOutlet UITextView *txtComments;
    IBOutlet UIButton *btnScan;
    IBOutlet UITextField *txtVendorInvoiceNumber;
    IBOutlet UIDatePicker *dtReceiptDate;
    IBOutlet UILabel *lblReceiptDate;
    IBOutlet UIButton *btnScanPJ;
    IBOutlet UIDatePicker *dtDeliveryDate;
    IBOutlet UILabel *lblDeliveryDate;
    IBOutlet UITableViewCell *clReceiptDate;
    IBOutlet UITableViewCell *clDeliveryDate;
    IBOutlet UILabel *lblVendorName;
    IBOutlet UILabel *lblCarrierName;
    IBOutlet UILabel *lblShipMethodName;
    IBOutlet UILabel *lblOriginName;
}

@property (weak, nonatomic) IBOutlet UITableViewCell *dateTitleCell;
@property (weak, nonatomic) UITextField *currentTextField;
@property (nonatomic, assign, getter = isDateOpen) BOOL editingStartTime;
@property (nonatomic, assign, getter = isDateOpen) BOOL editingStartTimeDelivery;
@property (nonatomic, strong) NSArray *visibleCustomAttributes;

@end
