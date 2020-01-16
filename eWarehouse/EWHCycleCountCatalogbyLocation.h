//
//  EWHCycleCountCatalogbyLocation.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface EWHCycleCountCatalogbyLocation : NSObject {
    NSInteger CatalogId;
}


@property (assign, nonatomic) NSInteger CatalogId;
@property (nonatomic, retain) NSString *ItemNumber;
@property (assign, nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSString *ProgramName;
@property (assign, nonatomic) NSInteger QuantityScanned;
@property (assign, nonatomic) NSInteger QuantityOnHand;
@property (nonatomic, retain) NSMutableArray *ScannedSerials;
@property (assign, nonatomic) NSInteger LocationId;
@property (assign, nonatomic) NSInteger CycleCountJobId;
@property (assign, nonatomic) NSInteger CycleCountJobDetailId;
@property (nonatomic) BOOL IsBulk;
@property (nonatomic) BOOL IsSerial;


- (EWHCycleCountCatalogbyLocation *)initWithDictionary:(NSDictionary *)dictionary;

-(NSDictionary*) toJSON;
@end

NS_ASSUME_NONNULL_END
