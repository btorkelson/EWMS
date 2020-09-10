//
//  EWHLoginNetworkProvider.m
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHLoginRequest.h"

@implementation EWHLoginRequest

-(void)loginUser:(NSString *)username withPassword:(NSString *)password
{
    __weak EWHRequestAF *sender = self;
    
    NSString *locBaseURL = super.baseURL;
//    NSString *locDefaultURL = super.defaultURL;
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];

    if (!locBaseURL) {
        if (super.defaultURL == super.urlPILOT){
            locBaseURL = super.urlCTL;
        } else {
            locBaseURL = super.urlPILOT;
        }
        NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:locBaseURL, @"service",                                 nil];
        [[NSUserDefaults standardUserDefaults] registerDefaults:userDefaultsDefaults];

    }
//
//
//    NSDictionary *userDefaultsDefaults = [NSDictionary dictionaryWithObjectsAndKeys:locBaseURL, @"server",                                 nil];
//    [[NSUserDefaults standardUserDefaults] setObject:super.urlPILOT forKey:@"server"];

    NSString *url = [NSString stringWithFormat:@"%@%@", locBaseURL, @"/Authorize"];
    NSLog(url);
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            
//    NSString *postData = [NSString stringWithFormat:@"{\"userName\":\"%@\", \"password\":\"%@\"}", username, password];
//    EWHLog(@"PostData:%@", [postData dataUsingEncoding:NSUTF8StringEncoding]);
    
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
    username, @"userName",
    password, @"password",
    nil];
    
    AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];
    [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:@"" forHTTPHeaderField:@"authHash"];
    
    AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
    securityPolicy.allowInvalidCertificates = YES;
    [securityPolicy setValidatesDomainName:NO];
    
    manager.securityPolicy = securityPolicy;
    [manager POST:url parameters:params headers:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
                    NSError *e = nil;
//                    NSDictionary* dictionary = [jsonParser objectWithString:responseObject error:&e];
        NSDictionary* dictionary = (NSDictionary*) responseObject;
                    NSDictionary* usr = [dictionary objectForKey:@"AuthorizeResult"];
                    self.user = [[EWHUser alloc]initWithDictionary:usr];
        
                    NSLog(@"Message: %@, UserID: %ld, BaseURL: %@",self.user.Message,(long)self.user.UserId,super.baseURL);
                    if ((!self.user.Message) && self.user.UserId>0 && (!super.baseURL)) {
                        NSLog(@"Set setting: %@", locBaseURL);
                        [[NSUserDefaults standardUserDefaults] setObject:locBaseURL forKey:@"server"];
                    }
                    if (!self.user.Message) {
                        NSLog(@"No message");
                    }
        
                    if (self.user.UserId>0) {
                        NSLog(@"userID > 0");
                    }
        
                    if (!super.baseURL) {
                        NSLog(@"No BaseURL");
                    }
        
                    if(self.caller && self.callback){
                        if([self.caller respondsToSelector:self.callback]){
                            [self.caller performSelector:self.callback withObject:self.user];
                        }
                    }
        
        } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
            NSLog(@"error: %@", error);
        }];
    
    
//    [request setRequestMethod:@"POST"];
//    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
//    [request setContentLength:[postData length]];
//    [request addRequestHeader:@"authHash" value:@""];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
//
//    [request setValidatesSecureCertificate:false];
//
//    [request setCompletionBlock:^{
//
//        int code = [sender.request responseStatusCode];
//
//        NSString* responseString = [sender.request responseString];
////        EWHLog(@"%@", responseString);
//        if(code == 200){
//
//            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//            NSError *e = nil;
//            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//            NSDictionary* usr = [dictionary objectForKey:@"AuthorizeResult"];
//            self.user = [[EWHUser alloc]initWithDictionary:usr];
//
//            NSLog(@"Message: %@, UserID: %ld, BaseURL: %@",self.user.Message,(long)self.user.UserId,super.baseURL);
//            if ((!self.user.Message) && self.user.UserId>0 && (!super.baseURL)) {
//                NSLog(@"Set setting: %@", locBaseURL);
//                [[NSUserDefaults standardUserDefaults] setObject:locBaseURL forKey:@"server"];
//            }
//            if (!self.user.Message) {
//                NSLog(@"No message");
//            }
//
//            if (self.user.UserId>0) {
//                NSLog(@"userID > 0");
//            }
//
//            if (!super.baseURL) {
//                NSLog(@"No BaseURL");
//            }
//
//            if(self.caller && self.callback){
//                if([self.caller respondsToSelector:self.callback]){
//                    [self.caller performSelector:self.callback withObject:self.user];
//                }
//            }
//        }
//        else {
//            if(self.caller && self.errorCallback){
//                if([self.caller respondsToSelector:self.errorCallback]){
//                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
////                    [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
//                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
//                    [self.caller performSelector:self.errorCallback withObject:self.error];
//                }
//            }
//        }
//    }];
//
//    [request setFailedBlock:^{
////        __strong ASIHTTPRequest *req = request;
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
