//
//  EWHGetCatalogByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 3/1/15.
//
//

#import "EWHRequest.h"
#import "EWHCatalog.h"

@interface EWHGetCatalogByProgram : EWHRequest


- (void)getCatalogByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
