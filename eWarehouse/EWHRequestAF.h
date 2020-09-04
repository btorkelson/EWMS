//
//  EWHRequestAF.h
//  eWarehouse
//
//  Created by Brian Torkelson on 9/4/20.
//

#import <Foundation/Foundation.h>
#import "EWHUser.h"
#import "SBJson.h"
#import "AFNetworking.h"

NS_ASSUME_NONNULL_BEGIN

@interface EWHRequestAF : NSObject
{
    NSString *baseURL;
    NSError *error;
    id caller;
    SEL callback;
    SEL errorCallback;
}
@property (nonatomic,retain) NSString *baseURL;
@property (nonatomic,retain) NSString *urlPILOT;
@property (nonatomic,retain) NSString *urlTEST;
@property (nonatomic,retain) NSString *urlCTL;
@property (nonatomic,retain) NSString *urlEWMS;
@property (nonatomic,retain) NSString *defaultURL;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) id caller;
@property (nonatomic) SEL callback;
@property (nonatomic) SEL errorCallback;
@property (nonatomic) SEL accessDeniedCallback;

@property (nonatomic,retain) EWHUser *user;

- (EWHRequestAF *)initWithCallbacks:(id)sender callback:(SEL)cb errorCallback:(SEL)ecb accessDeniedCallback: (SEL)adcb;
@end

NS_ASSUME_NONNULL_END
