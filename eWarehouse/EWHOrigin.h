//
//  EWHOrigin.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHOrigin : NSObject {
    NSInteger OriginId;
    NSString *Name;
}
@property (assign, nonatomic) NSInteger OriginId;
@property (nonatomic, retain) NSString *Name;

- (EWHOrigin *)initWithDictionary:(NSDictionary *)dictionary;



@end
