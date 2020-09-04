//
//  EWHLoginNetworkProvider.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHGetUserWarehouseListRequest.h"

@implementation EWHGetUserWarehouseListRequest

-(void)getUserWarehouseListRequest:(NSInteger)userId withAuthHash:(NSString *)authHash
{
    
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetUserWarehouseList"];

    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    @(userId), @"userId",
    nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:authHash forHTTPHeaderField:@"authHash"];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    manager.securityPolicy = securityPolicy;
    [manager POST:url parameters:params progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//                    SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
        NSError *e = nil;
        
        NSDictionary* dictionary = (NSDictionary*) responseObject;
        
        NSMutableArray* warehouses = [[NSMutableArray alloc] init];
        for (NSDictionary* element in [dictionary objectForKey:@"GetUserWarehouseListResult"]) {
            
            EWHWarehouse* warehouse = [[EWHWarehouse alloc] initWithDictionary:element];
            [warehouses addObject:warehouse];
        }
        if(self.caller && self.callback){
            if([self.caller respondsToSelector:self.callback]){
                [self.caller performSelector:self.callback withObject:warehouses];
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
////        EWHLog(@"%@", responseString);
//        if(code == 200){
//            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//            NSError *e = nil;
//            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
////            NSMutableArray* warehouses = [[NSMutableArray alloc] init];
////            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Warehouse list" message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////            [av show];
////            EWHLog([dictionary objectForKey:@"GetUserWarehouseListResult"]);
////            id test = [dictionary objectForKey:@"GetUserWarehouseListResult"];
//            NSMutableArray* warehouses = [[NSMutableArray alloc] init];
//            for (NSDictionary* element in [dictionary objectForKey:@"GetUserWarehouseListResult"]) {
////                EWHLog(element);
////                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Warehouse item" message:element delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                [av show];
////                NSDictionary* item = [jsonParser objectWithString:element error:&e];
//                EWHWarehouse* warehouse = [[EWHWarehouse alloc] initWithDictionary:element];
//                [warehouses addObject:warehouse];
//            }
////            NSMutableArray* warehouses = [jsonParser objectWithString:[dictionary objectForKey:@"GetUserWarehouseListResult"]];
////                            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Warehouse item" message:test delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                            [av show];
////            for (NSString* element in dictionary) {
////                EWHLog(element);
////                UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Warehouse item" message:element delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////                [av show];
////                NSDictionary* item = [jsonParser objectWithString:element error:&e];
////                EWHWarehouse* warehouse = [[EWHWarehouse alloc] initWithDictionary:item];
////                [warehouses addObject:warehouse];
////            }
////            UIAlertView* av = [[UIAlertView alloc] initWithTitle:@"Warehouse list" message:responseString delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
////            [av show];
////            NSDictionary* usr = [dictionary objectForKey:@"AuthorizeResult"];
//
//            if(self.caller && self.callback){
//                if([self.caller respondsToSelector:self.callback]){
//                    [self.caller performSelector:self.callback withObject:warehouses];
//                }
//            }
//        }
//        else if(code == 400 || code == 401){
//            if(self.caller && self.accessDeniedCallback){
//                if([self.caller respondsToSelector:self.accessDeniedCallback]){
//                    [self.caller performSelector:self.accessDeniedCallback];
//                }
//            }
//        }
//        else {
//            if(self.caller && self.errorCallback){
//                if([self.caller respondsToSelector:self.errorCallback]){
//                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
//                    [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
//                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
//                    [self.caller performSelector:self.errorCallback withObject:self.error];
//                }
//            }
//        }
//    }];
//
//    [request setFailedBlock:^{
//        self.error = [sender.request error];
//        if(self.caller && self.errorCallback){
//            if([self.caller respondsToSelector:self.errorCallback]){
//                [self.caller performSelector:self.errorCallback withObject:self.error];
//            }
//        }
//    }];
//
//    [request startAsynchronous];
}
                                                                                                                                                                                                                            
@end

