//
//  EWHGetVendorsByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHRequest.h"
#import "EWHVendor.h"

@interface EWHGetVendorsByProgram : EWHRequest


- (void)getGetVendorsByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
