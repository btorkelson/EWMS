//
//  EWHGetWarehouseProgramListAll.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import "EWHRequestAF.h"
#import "EWHProgram.h"

@interface EWHGetWarehouseProgramListAll : EWHRequestAF

- (void)getWarehouseProgramList:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
