//
//  EWHLocationsByType.h
//  eWarehouse
//
//  Created by Brian Torkelson on 3/4/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHLocationsByType : NSObject {
    NSString *LocationType;
    NSMutableArray *Locations;
}

@property (nonatomic, retain) NSString *LocationType;
@property (nonatomic, retain) NSMutableArray *Locations;

@end
