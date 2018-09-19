//
//  EWHAddReceiptCustomAttibutesViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/13/18.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHProgram.h"
#import "EWHNewReceiptDataObject.h"
#import "EWHInboundCustomAttribute.h"
#import "EWHAppDelegateProtocal.h"

@interface EWHAddReceiptCustomAttibutesViewController : UITableViewController


@property (strong, nonatomic) IBOutlet UITableView *CATableView;
@property (nonatomic, strong) NSArray *visibleCustomAttributes;
@property (nonatomic, strong) NSIndexPath *dropdownIndexPath;
@property (nonatomic, strong) NSMutableArray *options;

-(void) updateDropDown:(NSIndexPath *)indexPath;
@end
