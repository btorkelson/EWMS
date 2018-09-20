//
//  EWHTextCell.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/19/18.
//

#import <UIKit/UIKit.h>

@interface EWHTextCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UITextField *tfCustomAttributeText;
@property (weak, nonatomic) IBOutlet UILabel *txtLabel;
@property (nonatomic, retain) NSString *placeHolder;

@end
