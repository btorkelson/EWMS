//
//  EWHGetProgramsforReceipt.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/30/14.
//
//

#import "EWHRequestAF.h"
#import "EWHProgram.h"

@interface EWHGetProgramsforReceipt : EWHRequestAF
{
    
    
}

- (void)getGetProgramsforReceiptRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
