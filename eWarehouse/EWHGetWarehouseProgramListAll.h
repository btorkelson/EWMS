//
//  EWHGetWarehouseProgramListAll.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import "EWHRequest.h"
#import "EWHProgram.h"

@interface EWHGetWarehouseProgramListAll : EWHRequest

- (void)getWarehouseProgramList:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
