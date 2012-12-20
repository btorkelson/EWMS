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
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/Authorize"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
            
    NSString *postData = [NSString stringWithFormat:@"{\"userName\":\"%@\", \"password\":\"%@\"}", username, password];
//    EWHLog(@"PostData:%@", postData);
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setContentLength:[postData length]];
    [request addRequestHeader:@"authHash" value:@""];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    
    [request setValidatesSecureCertificate:false];

//    [request startSynchronous];
//    
//    NSError *error = [request error];
//    if (!error) {
//        //[request readResponseHeaders];
//        int code = [request responseStatusCode];
//        NSString* message = [request responseStatusMessage];
//        NSString* response = [request responseString];
//    }
        
//    [request setDelegate:self];
    [request setCompletionBlock:^{
        // Use when fetching text data
//        __strong ASIHTTPRequest *req = request;
        int code = [sender.request responseStatusCode];
//        NSString* message = [request responseStatusMessage];
//        NSData* responseData = [request responseData];
        NSString* responseString = [sender.request responseString];
        EWHLog(@"%@", responseString);
        if(code == 200){
            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
            NSError *e = nil;
            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
            NSDictionary* usr = [dictionary objectForKey:@"AuthorizeResult"];
            self.user = [[EWHUser alloc]initWithDictionary:usr];
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:self.user];
                }
            }
        }
        else {
            if(self.caller && self.errorCallback){
                if([self.caller respondsToSelector:self.errorCallback]){
                    NSMutableDictionary *errorDetail = [NSMutableDictionary dictionary];
                    [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
                    [self.caller performSelector:self.errorCallback withObject:self.error];
                }
            }
        }
    }];
    
    [request setFailedBlock:^{
//        __strong ASIHTTPRequest *req = request;
        self.error = [sender.request error];
        if(self.caller && self.errorCallback){
            if([self.caller respondsToSelector:self.errorCallback]){
                [self.caller performSelector:self.errorCallback withObject:self.error];
            }
        }
    }];

    [request startAsynchronous];
}
                                                                                                                                                                                                                            
@end
