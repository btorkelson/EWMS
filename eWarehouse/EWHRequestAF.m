//
//  EWHRequestAF.m
//  eWarehouse
//
//  Created by Brian Torkelson on 9/4/20.
//

#import "EWHRequestAF.h"

@implementation EWHRequestAF
@synthesize baseURL;
@synthesize urlPILOT;
@synthesize urlTEST;
@synthesize urlCTL;
@synthesize urlEWMS;
@synthesize defaultURL;
@synthesize error;
@synthesize caller;
@synthesize callback;
@synthesize errorCallback;
@synthesize accessDeniedCallback;

@synthesize user;


- (EWHRequestAF *)init {
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

- (EWHRequestAF *)initWithCallbacks:(id)sender callback:(SEL)cb errorCallback:(SEL)ecb accessDeniedCallback: (SEL)adcb {
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
