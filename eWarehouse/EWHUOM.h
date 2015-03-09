//
//  EWHUOM.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/31/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHUOM : NSObject {
    NSInteger UnitOfMeasureId;
    NSString *UnitOfMeasureName;
    NSInteger ProgramId;
    NSDecimalNumber *Value;
    NSInteger SizeType;
    NSInteger UnitOfMeasureType;
}

@property (assign, nonatomic) NSInteger UnitofMeasureId;
@property (nonatomic, retain) NSString *UnitOfMeasureName;
@property (assign, nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSDecimalNumber *Value;
@property (assign, nonatomic) NSInteger SizeType;
@property (assign, nonatomic) NSInteger UnitOfMeasureType;

- (EWHUOM *)initWithDictionary:(NSDictionary *)dictionary;



@end
