//
//  EWHCycleCountJob.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/21/18.
//
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"

@interface EWHCycleCountJob : NSObject {
    NSInteger CycleCountJobId;
    NSString *CycleCountJobNumber;
    NSDate *DueDate;
    NSInteger CycleCountJobTypeId;
}

@property (assign, nonatomic) NSInteger CycleCountJobId;
@property (nonatomic, retain) NSString *CycleCountJobNumber;
@property (nonatomic, retain) NSDate *DueDate;
@property (assign, nonatomic) NSInteger CycleCountJobTypeId;

- (EWHCycleCountJob *)initWithDictionary:(NSDictionary *)dictionary;

@end
