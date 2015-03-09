//
//  CMSAddLabelstoPrintQueue.m
//  CMS Driver
//
//  Created by Brian Torkelson on 5/6/14.
//  Copyright (c) 2014 eWMS. All rights reserved.
//

#import "EWHAddLabelstoPrintQueue.h"

@implementation EWHAddLabelstoPrintQueue

-(void)AddLabelPrintQueue:(NSInteger)receiptId itemId:(NSInteger)itemId user:(EWHUser *)user
{
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/AddLabelPrintQueue"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    
    NSString *postData = [NSString stringWithFormat:@"{\"receiptId\":%d,\"itemId\":%d,\"userId\":%d}", receiptId,itemId,user.UserId];
    
    
    EWHLog(@"%@", postData);
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setContentLength:[postData length]];
    [request addRequestHeader:@"authHash" value:user.AuthHash];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    
    [request setValidatesSecureCertificate:false];
    
    [request setDelegate:self];
    [request setCompletionBlock:^{
        int code = [sender.request responseStatusCode];
        NSString* responseString = @"Finished";
        NSString* responseString2 = [sender.request responseString];
        EWHLog(@"%@", responseString2);
        if(code == 200){
            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
            NSError *e = nil;
            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
            //            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
            if(self.caller && self.callback){
                //if([self.caller respondsToSelector:self.callback]){
                [self.caller performSelector:self.callback withObject:responseString];
                //}
            }
        }
        else if(code == 400 || code == 401){
            if(self.caller && self.accessDeniedCallback){
                if([self.caller respondsToSelector:self.accessDeniedCallback]){
                    [self.caller performSelector:self.accessDeniedCallback];
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
