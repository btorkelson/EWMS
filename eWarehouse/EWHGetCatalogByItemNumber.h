//
//  EWHGetCatalogByItemNumber.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequestAF.h"
#import "EWHCatalog.h"

@interface EWHGetCatalogByItemNumber : EWHRequestAF
{
}

- (void)getCatalogByItemNumber:(NSInteger)programId itemNumber:(NSString *)itemnumber withAuthHash:(NSString *)authHash;


@end
