//
//  EWHDestination.h
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHDestination : NSObject {
    NSInteger DestinationId;
    NSString *Name;
    NSString *Address1;
    NSString *Address2;
    NSString *City;
    NSString *State;
    NSString *Zip;
    NSString *Country;
}
@property (assign, nonatomic) NSInteger DestinationId;
@property (nonatomic, retain) NSString *Name;
@property (nonatomic, retain) NSString *Address1;
@property (nonatomic, retain) NSString *Address2;
@property (nonatomic, retain) NSString *City;
@property (nonatomic, retain) NSString *State;
@property (nonatomic, retain) NSString *Zip;
@property (nonatomic, retain) NSString *Country;

- (EWHDestination *)initWithDictionary:(NSDictionary *)dictionary;



@end
