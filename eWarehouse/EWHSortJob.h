//
//  EWHSortJob.h
//  eWarehouse
//
//  Created by Brian Torkelson on 8/28/19.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHSortJob : NSObject {
    NSDate *JobDate;
    NSString *JobName;
    NSInteger ProgramId;
    NSString *ProgramName;
    NSInteger WarehouseId;
    NSString *WarehouseName;
    NSInteger SortJobId;
}

@property (nonatomic, retain) NSDate *JobDate;
@property (nonatomic, retain) NSString *JobName;
@property (assign, nonatomic) NSInteger ProgramId;
@property (nonatomic, retain) NSString *ProgramName;
@property (assign, nonatomic) NSInteger WarehouseId;
@property (nonatomic, retain) NSString *WarehouseName;
@property (assign, nonatomic) NSInteger SortJobId;

- (EWHSortJob *)initWithDictionary:(NSDictionary *)dictionary;

@end

NS_ASSUME_NONNULL_END

/*
 
 
"JobDate":"\/Date(1566878400000-0400)\/","JobName":"matt sort #2","ProgramId":174,"ProgramName":"Akamai ","SortJobId":2,"WarehouseId":110,"WarehouseName":"LG06 - ORD"
 
 */
