//
//  EWHShipMethod.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHShipMethod : NSObject {
    NSInteger ShipMethodId;
    NSString *Name;
}
@property (assign, nonatomic) NSInteger ShipMethodId;
@property (nonatomic, retain) NSString *Name;

- (EWHShipMethod *)initWithDictionary:(NSDictionary *)dictionary;



@end
