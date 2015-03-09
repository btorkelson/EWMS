//
//  EWHGetShipMethodsByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHRequest.h"
#import "EWHShipMethod.h"

@interface EWHGetShipMethodsByProgram : EWHRequest

- (void)getShipMethodsByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
