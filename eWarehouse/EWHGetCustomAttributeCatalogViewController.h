//
//  EWHGetCustomAttributeCatalogViewController.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/14/14.
//
//

#import <UIKit/UIKit.h>
#import "EWHRootViewController.h"
#import "EWHCustomAttributeCatalog.h"

@interface EWHGetCustomAttributeCatalogViewController : UIViewController

@property (strong, nonatomic) IBOutlet UILabel *lblCustomAttributeName;
@property (strong, nonatomic) IBOutlet UITextField *txtCustomAttributeValue;
@property (nonatomic, strong) EWHCatalog *catalog;
@property (nonatomic, strong) EWHCustomAttributeCatalog *customAttribute;
@property (assign, nonatomic) NSInteger CAindex;
@end
