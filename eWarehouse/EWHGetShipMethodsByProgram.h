//
//  EWHGetShipMethodsByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHRequestAF.h"
#import "EWHShipMethod.h"

@interface EWHGetShipMethodsByProgram : EWHRequestAF

- (void)getShipMethodsByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
