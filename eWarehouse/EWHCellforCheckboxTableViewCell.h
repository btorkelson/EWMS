//
//  EWHCellforCheckboxTableViewCell.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/20/18.
//
//

#import <UIKit/UIKit.h>

@interface EWHCellforCheckboxTableViewCell : UITableViewCell


@property (weak, nonatomic) IBOutlet UILabel *txtCellLabel;
@property (strong, nonatomic) IBOutlet UISwitch *swCustomAttributeSwitch;
@end
