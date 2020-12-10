//
//  EWHCellforTextLabelTableViewCell.h
//  eWarehouse
//
//  Created by Brian Torkelson on 12/10/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWHCellforTextLabelTableViewCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *lblTextLabel;
@property (strong, nonatomic) IBOutlet UITextField *tfCustomAttributeText;

@end

NS_ASSUME_NONNULL_END
