//
//  EWHGetVendorsByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHRequestAF.h"
#import "EWHVendor.h"

@interface EWHGetVendorsByProgram : EWHRequestAF


- (void)getGetVendorsByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
