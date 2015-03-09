//
//  EWHGetDestinationsByProgramWarehouse.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHGetDestinationsByProgramWarehouse.h"

@implementation EWHGetDestinationsByProgramWarehouse

- (void)getDestinationsByProgramWarehouse:(NSInteger)programId warehouseId:(NSInteger)warehouseId locationId:(NSInteger)locationId withAuthHash:(NSString *)authHash
{
    
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetProgramDestinations"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"programId\":%d,\"warehouseId\":%d,\"locationId\":%d}", programId,warehouseId,locationId];
    
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
            NSMutableArray* destinations = [[NSMutableArray alloc] init];
            for (NSDictionary* element in [dictionary objectForKey:@"GetProgramDestinationsListResult"]) {
                EWHDestination* destination = [[EWHDestination alloc] initWithDictionary:element];
//                destination.Address1=@"addre1";
//                destination.Address2=@"addre2";
//                destination.City=@"cityyy";
//                destination.State=@"statee";
//                destination.Zip=@"12345";
                [destinations addObject:destination];
            }
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:destinations];
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
                    //                [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
                    [self.caller performSelector:self.errorCallback withObject:self.error];
                }
            }
        }
        
    }];
    
    [request startAsynchronous];
    
}
@end
