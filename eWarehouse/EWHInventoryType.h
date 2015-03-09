//
//  EWHInventoryType.h
//  eWarehouse
//
//  Created by Brian Torkelson on 10/16/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHInventoryType : NSObject {
    NSInteger InventoryTypeId;
    NSString *Name;
}
@property (assign, nonatomic) NSInteger InventoryTypeId;
@property (nonatomic, retain) NSString *Name;

- (EWHInventoryType *)initWithDictionary:(NSDictionary *)dictionary;



@end
