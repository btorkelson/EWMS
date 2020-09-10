//
//  EWHGetCarriersByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import "EWHRequestAF.h"
#import "EWHCarrier.h"

@interface EWHGetCarriersByProgram : EWHRequestAF

- (void)getCarriersByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
