//
//  EWHGetCatalogByItemNumber.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHRequest.h"
#import "EWHCatalog.h"

@interface EWHGetCatalogByItemNumber : EWHRequest
{
}

- (void)getCatalogByItemNumber:(NSInteger)programId itemNumber:(NSString *)itemnumber withAuthHash:(NSString *)authHash;


@end
