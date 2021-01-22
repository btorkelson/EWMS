//
//  EWHItemDetail.h
//  eWarehouse
//
//  Created by Brian Torkelson on 12/17/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWHItemDetail : NSObject


@property (nonatomic, retain) NSString *ItemNumber;
@property (nonatomic, retain) NSString *InventoryStatusName;
@property (nonatomic, retain) NSString *ProgramName;
@property (nonatomic, retain) NSString *LocationName;
@property (nonatomic, retain) NSString *ItemScan;
@property (assign, nonatomic) NSInteger Quantity;

- (EWHItemDetail *) initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END
