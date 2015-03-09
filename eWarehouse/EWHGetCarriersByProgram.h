//
//  EWHGetCarriersByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHRequest.h"
#import "EWHCarrier.h"

@interface EWHGetCarriersByProgram : EWHRequest

- (void)getCarriersByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
