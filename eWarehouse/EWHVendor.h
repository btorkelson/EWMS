//
//  EWHVendor.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/3/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHVendor : NSObject {
    NSInteger VendorId;
    NSString *Name;
}
@property (assign, nonatomic) NSInteger VendorId;
@property (nonatomic, retain) NSString *Name;

- (EWHVendor *)initWithDictionary:(NSDictionary *)dictionary;
@end
