//
//  EWHMoveInventory.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import "EWHRequest.h"
#import "EWHWarehouse.h"
#import "EWHCatalog.h"
#import "EWHResponse.h"

@interface EWHMoveInventory : EWHRequest
{
}

- (void)moveInventory:(EWHWarehouse *)warehouse location:(NSString *)location catalog:(EWHCatalog *)catalog quantity:(NSInteger)quantity newlocation:(NSString *)newlocation serials:(NSMutableArray *)serials user:(EWHUser *)user;

@end