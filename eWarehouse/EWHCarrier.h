//
//  EWHCarrier.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHCarrier : NSObject {
    NSInteger CarrierId;
    NSString *Name;
}
@property (assign, nonatomic) NSInteger CarrierId;
@property (nonatomic, retain) NSString *Name;

- (EWHCarrier *)initWithDictionary:(NSDictionary *)dictionary;

@end