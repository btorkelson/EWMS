//
//  EWHGetOriginsByProgramWarehouse.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/4/14.
//
//

#import "EWHGetOriginsByProgramWarehouse.h"

@implementation EWHGetOriginsByProgramWarehouse

- (void)getOriginsByProgramWarehouse:(NSInteger)programId warehouseid:(NSInteger)warehouseId withAuthHash:(NSString *)authHash{
    
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetProgramOriginsList"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"programId\":\"%d\",\"warehouseId\":\"%d\"}", programId, warehouseId];
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setContentLength:[postData length]];
    [request addRequestHeader:@"authHash" value:authHash];
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
            NSMutableArray* origins = [[NSMutableArray alloc] init];
            for (NSDictionary* element in [dictionary objectForKey:@"GetProgramOriginsListResult"]) {
                EWHOrigin* origin = [[EWHOrigin alloc] initWithDictionary:element];
                [origins addObject:origin];
            }
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:origins];
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
                //                [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
                self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
                [self.caller performSelector:self.errorCallback withObject:self.error];
            }
        }
    }
    
        }
    }];
    
    [request startAsynchronous];
}

@end