//
//  EWHProcessCycleCountDetailByLocation.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/14/20.
//

#import "EWHProcessCycleCountDetailByLocation.h"

@implementation EWHProcessCycleCountDetailByLocation

-(void)processCycleCountDetailByLocation:(NSMutableArray *)details user:(EWHUser *)user
{
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/ProcessCycleCountDetailByLocation"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
//    NSString *numbers = [[serials valueForKey:@"description"] componentsJoinedByString:@","];
    NSError *e = nil;
    
    NSMutableArray<NSDictionary*> *jsonOffers = [NSMutableArray array];
    for (EWHCycleCountCatalogbyLocation* ca in details) {
        [jsonOffers addObject:[ca toJSON]];
    }
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:jsonOffers options:kNilOptions error:&e];
    //    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:receipt.InboundCustomAttributes options:NSJSONWritingPrettyPrinted error:&e];
    NSString *jsonString = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
    
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:details options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    NSString *postData = [NSString stringWithFormat:@"{\"details\":%@,\"userId\":%ld}", jsonString, (long)user.UserId];
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
        NSString* responseString = [sender.request responseString];
        EWHLog(@"%@", responseString);
        if(code == 200){
            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
            NSError *e = nil;
            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:response];
                }
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
