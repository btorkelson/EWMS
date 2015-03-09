//
//  EWHGetUOMWeightViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/31/14.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"

@interface EWHGetUOMWeightViewController : UIViewController <UIPickerViewDelegate> {
    
    IBOutlet UILabel *lblLabel;
    IBOutlet UITextField *txtUOMWeight;
    IBOutlet UIPickerView *pkUOMOption;
}


@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic, strong) NSArray *UOMWeights;
@property (nonatomic, strong) NSMutableArray *UOMWeightsFinal;

@end
