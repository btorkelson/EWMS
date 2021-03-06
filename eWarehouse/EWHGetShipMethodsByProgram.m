//
//  EWHGetShipMethodsByProgram.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHGetShipMethodsByProgram.h"

@implementation EWHGetShipMethodsByProgram

- (void)getShipMethodsByProgram:(NSInteger)programId withAuthHash:(NSString *)authHash {
    
//    int code = 200;
//    
//    NSMutableArray* carriersArray = [NSMutableArray arrayWithObjects:@"Ground",@"Next Day",@"Overnight",@"Right Now",@"Yesterday",@"Next Week",@"Never",@"Pick up",@"Will Call", nil];
//    
//    NSMutableArray* carriers = [[NSMutableArray alloc] init];
//    
//    for (id myArrayElement in carriersArray) {
//        EWHShipMethod* shipmethod = [EWHShipMethod alloc];
//        shipmethod.ShipMethodId=1;
//        shipmethod.Name=myArrayElement;
//        [carriers addObject:shipmethod];
//        
//    }
//    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetProgramShipMethods"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"programId\":\"%ld\"}", (long)programId];
    NSData *data = [postData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:authHash forHTTPHeaderField:@"authHash"];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    manager.securityPolicy = securityPolicy;
    [manager POST:url parameters:params headers:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    NSError *e = nil;
        
        NSDictionary* dictionary = (NSDictionary*) responseObject;
        
         NSMutableArray* shipmethods = [[NSMutableArray alloc] init];
               for (NSDictionary* element in [dictionary objectForKey:@"GetProgramShipMethodsListResult"]) {
                   EWHShipMethod* shipmethod = [[EWHShipMethod alloc] initWithDictionary:element];
                   [shipmethods addObject:shipmethod];
               }
               if(self.caller && self.callback){
                   if([self.caller respondsToSelector:self.callback]){
                       [self.caller performSelector:self.callback withObject:shipmethods];
                   }
               }
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            self.error = error;
            if(self.caller && self.errorCallback){
                if([self.caller respondsToSelector:self.errorCallback]){
                    [self.caller performSelector:self.errorCallback withObject:self.error];
                }
            }
        }];
    
//    [request setRequestMethod:@"POST"];
//    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setContentLength:[postData length]];
//    [request addRequestHeader:@"authHash" value:authHash];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
//
//    [request setValidatesSecureCertificate:false];
//
//    [request setDelegate:self];
//    [request setCompletionBlock:^{
//        int code = [sender.request responseStatusCode];
//        NSString* responseString = [sender.request responseString];
//        EWHLog(@"%@", responseString);
//
//    if(code == 200){
//        SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//        NSError *e = nil;
//        NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//        NSMutableArray* shipmethods = [[NSMutableArray alloc] init];
//        for (NSDictionary* element in [dictionary objectForKey:@"GetProgramShipMethodsListResult"]) {
//            EWHShipMethod* shipmethod = [[EWHShipMethod alloc] initWithDictionary:element];
//            [shipmethods addObject:shipmethod];
//        }
//        if(self.caller && self.callback){
//            if([self.caller respondsToSelector:self.callback]){
//                [self.caller performSelector:self.callback withObject:shipmethods];
//            }
//        }
//    }
//    else if(code == 400 || code == 401){
//        if(self.caller && self.accessDeniedCallback){
//            if([self.caller respondsToSelector:self.accessDeniedCallback]){
//                [self.caller performSelector:self.accessDeniedCallback];
//            }
//        }
//    }
//    else {
//        if(self.caller && self.errorCallback){
//            if([self.caller respondsToSelector:self.errorCallback]){
//                NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                //                [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
//                self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
//                [self.caller performSelector:self.errorCallback withObject:self.error];
//            }
//        }
//    }
//    }];
//
//    [request startAsynchronous];
    
}

@end
