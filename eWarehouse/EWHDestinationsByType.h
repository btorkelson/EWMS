//
//  EWHDestinationsByType.h
//  eWarehouse
//
//  Created by Brian Torkelson on 5/7/14.
//
//

#import <Foundation/Foundation.h>

@interface EWHDestinationsByType : NSObject {
    NSString *DestinatinType;
    NSMutableArray *Destinations;
}


@property (nonatomic, retain) NSString *DestinationType;
@property (nonatomic, retain) NSMutableArray *Destinations;


@end
