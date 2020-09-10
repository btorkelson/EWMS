//
//  EWHNetworkProvider.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"

@implementation EWHRequest 

@synthesize baseURL;
@synthesize urlPILOT;
@synthesize urlTEST;
@synthesize urlCTL;
@synthesize urlEWMS;
@synthesize defaultURL;
//@synthesize request;
@synthesize error;
@synthesize caller;
@synthesize callback;
@synthesize errorCallback;
@synthesize accessDeniedCallback;

@synthesize user;


- (EWHRequest *)init {
    urlPILOT = @"https://66.29.195.53/BOLayer.svc"; //PROD
    urlTEST = @"https://66.29.195.99/BOLayer.svc";//TEST
    urlCTL = @"https://66.29.195.44/BOLayer.svc";//CenturyLink
    urlEWMS = @"https://66.29.195.40/BOLayer.svc";//EWMS
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    defaultURL = [defaults objectForKey:@"service"];
    
    
    NSString *stringObject = [defaults objectForKey:@"server"];
    baseURL = stringObject;
        
    return [super init];
}

- (EWHRequest *)initWithCallbacks:(id)sender callback:(SEL)cb errorCallback:(SEL)ecb accessDeniedCallback: (SEL)adcb {
    self = [self init];
    if(self){
        self.caller = sender;
        self.error = nil;
        self.callback = cb;
        self.errorCallback = ecb;
        self.accessDeniedCallback = adcb;
    }
    return self;
}

@end
