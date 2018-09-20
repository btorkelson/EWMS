//
//  EWHTextCell.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/19/18.
//

#import "EWHTextCell.h"

@implementation EWHTextCell
@synthesize tfCustomAttributeText;
@synthesize placeHolder;

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    tfCustomAttributeText.placeholder=placeHolder;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
