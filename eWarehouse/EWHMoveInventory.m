//
//  EWHMoveInventory.m
//  eWarehouse
//
//  Created by Brian Torkelson on 5/26/17.
//
//

#import "EWHMoveInventory.h"

@implementation EWHMoveInventory

-(void)moveInventory:(EWHWarehouse *)warehouse location:(NSString *)location catalog:(EWHCatalog *)catalog quantity:(NSInteger)quantity newlocation:(NSString *)newlocation serials:(NSMutableArray *)serials user:(EWHUser *)user
{
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/MoveInventory"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZZ"];
    
    
    NSString *numbers = [[serials valueForKey:@"description"] componentsJoinedByString:@","];
    
    NSString *postData = [NSString stringWithFormat:@"{\"item\":{\"PartNumber\":\"%@\",\"CatalogId\":%ld,\"WarehouseId\":%ld,\"LocationName\":\"%@\",\"IsBulk\":\"%@\",\"Quantity\":%ld,\"Number\":\"%@\"},\"moveToLocationName\":\"%@\",\"userId\":%ld}", catalog.ItemNumber, (long)catalog.CatalogId, (long)warehouse.Id, location, catalog.IsBulk ? @"true" : @"false", (long)quantity, numbers, newlocation, (long)user.UserId];
    
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
