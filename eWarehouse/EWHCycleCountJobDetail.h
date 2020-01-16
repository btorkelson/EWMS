//
//  EWHCycleCountJobDetail.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import <Foundation/Foundation.h>
#import "EWHUtils.h"


@interface EWHCycleCountJobDetail : NSObject

@property (assign, nonatomic) NSInteger CycleCountJobDetailId;
@property (assign, nonatomic) NSInteger Id;
@property (nonatomic, retain) NSString *Value;

- (EWHCycleCountJobDetail *) initWithDictionary:(NSDictionary *)dictionary;


@end

