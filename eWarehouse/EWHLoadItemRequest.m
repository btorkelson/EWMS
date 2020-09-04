//
//  EWHLoadItemRequest.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoadItemRequest.h"

@implementation EWHLoadItemRequest

-(void)loadItem:(EWHShipmentDetail *)shipmentDetail warehouse:(NSInteger)warehouseId location:(EWHLocation *)location quantity:(NSInteger)quantity user:(EWHUser *)user
{
//    __weak EWHRequest *sender = self;
//    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/LoadItem"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"item\":{\"WarehouseId\":%ld,\"ShipmentId\":%ld,\"LocationName\":\"%@\",\"LocationId\":%ld,\"Number\":\"%@\",\"PartNumber\":\"%@\",\"Quantity\":\"%ld\"},\"userId\":\"%ld\"}", (long)warehouseId, (long)shipmentDetail.ShipmentId, shipmentDetail.LocationName, (long)location.Id, shipmentDetail.Number, shipmentDetail.PartNumber, (long)quantity, (long)user.UserId];
    
    NSLog(@"postData: %@",postData);

    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/LoadItem"];

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
    NSError *e = nil;
        
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
