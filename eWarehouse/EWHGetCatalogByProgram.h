//
//  EWHGetCatalogByProgram.h
//  eWarehouse
//
//  Created by Brian Torkelson on 3/1/15.
//
//

#import "EWHRequestAF.h"
#import "EWHCatalog.h"

@interface EWHGetCatalogByProgram : EWHRequestAF


- (void)getCatalogByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash;

@end
