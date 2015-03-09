//
//  EWHNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ASIHTTPRequest.h"
#import "SBJson.h"
#import "EWHUser.h"

@interface EWHRequest : NSObject 
{
    NSString *baseURL;
    ASIHTTPRequest *request;
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
@property (nonatomic,retain) ASIHTTPRequest *request;
@property (nonatomic, retain) NSError *error;
@property (nonatomic, retain) id caller;
@property (nonatomic) SEL callback;
@property (nonatomic) SEL errorCallback;
@property (nonatomic) SEL accessDeniedCallback;

@property (nonatomic,retain) EWHUser *user;

- (EWHRequest *)initWithCallbacks:(id)sender callback:(SEL)cb errorCallback:(SEL)ecb accessDeniedCallback: (SEL)adcb;
@end