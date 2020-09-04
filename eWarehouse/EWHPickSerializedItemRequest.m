
//
//  EWHPickSerializedItemRequest.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHPickSerializedItemRequest.h"

@implementation EWHPickSerializedItemRequest

-(void)pickItem:(EWHShipmentDetail *)shipmentDetail warehouse:(NSInteger)warehouseId location:(EWHLocation *)location locationName:(NSString *)locationName serialNumbers:(NSString *)serialNumbers user:(EWHUser *)user
{
//    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/PickItem"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"item\":{\"WarehouseId\":%ld,\"ShipmentId\":%ld,\"LocationName\":\"%@\",\"LocationId\":%ld,\"PartNumber\":\"%@\",\"Quantity\":\"1\",\"Number\":\"%@\",\"IsSerialized\":true},\"userId\":\"%ld\"}", (long)warehouseId, (long)shipmentDetail.ShipmentId, locationName, (long)location.Id, shipmentDetail.PartNumber, serialNumbers, (long)user.UserId];
    
    EWHLog(@"PickItem: %@", postData);
    NSData *data = [postData dataUsingEncoding:NSUTF8StringEncoding];
    NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:user.AuthHash forHTTPHeaderField:@"authHash"];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    manager.securityPolicy = securityPolicy;
    [manager POST:url parameters:params progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
//    NSError *e = nil;
        
        NSDictionary* dictionary = (NSDictionary*) responseObject;
        
        EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
        if(self.caller && self.callback){
            if([self.caller respondsToSelector:self.callback]){
                [self.caller performSelector:self.callback withObject:response];
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
//    [request addRequestHeader:@"authHash" value:user.AuthHash];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
//    [request setTimeOutSeconds:60];
//
//    [request setValidatesSecureCertificate:false];
//
//    [request setDelegate:self];
//    [request setCompletionBlock:^{
//        int code = [sender.request responseStatusCode];
//        NSString* responseString = [sender.request responseString];
//        EWHLog(@"%@", responseString);
//        if(code == 200){
//            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//            NSError *e = nil;
//            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
//            if(self.caller && self.callback){
//                if([self.caller respondsToSelector:self.callback]){
//                    [self.caller performSelector:self.callback withObject:response];
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
