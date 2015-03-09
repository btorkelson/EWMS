//
//  EWHGetProgramsforReceipt.h
//  eWarehouse
//
//  Created by Brian Torkelson on 1/30/14.
//
//

#import "EWHRequest.h"
#import "EWHProgram.h"

@interface EWHGetProgramsforReceipt : EWHRequest
{
    
    
}

- (void)getGetProgramsforReceiptRequest:(NSInteger)warehouseId withAuthHash:(NSString *)authHash;

@end
