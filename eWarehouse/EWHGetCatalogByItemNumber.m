//
//  EWHGetCatalogByItemNumber.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHGetCatalogByItemNumber.h"

@implementation EWHGetCatalogByItemNumber

- (void)getCatalogByItemNumber:(NSInteger)programId itemNumber:(NSString *)itemnumber withAuthHash:(NSString *)authHash
{
    
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetCatalogByItemNumber"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"programId\":%d,\"itemNumber\":\"%@\"}", programId, itemnumber];
    
    [request setRequestMethod:@"POST"];
    [request appendPostData:[postData dataUsingEncoding:NSUTF8StringEncoding]];
    [request setContentLength:[postData length]];
    [request addRequestHeader:@"authHash" value:authHash];
    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
    
    [request setValidatesSecureCertificate:false];
    
    EWHLog(@"%@", postData);
    [request setDelegate:self];
    [request setCompletionBlock:^{
        int code = [sender.request responseStatusCode];
        NSString* responseString = [sender.request responseString];
        EWHLog(@"%@", responseString);
        
        if(code == 200){
            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
            NSError *e = nil;
            NSMutableArray* receipts = [[NSMutableArray alloc] init];
            
            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//            NSDictionary* element = [dictionary objectForKey:@"GetCatalogByItemNumberResult"];
            //            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
            
            //            for (NSDictionary* element in [dictionary objectForKey:@"GetSavedReceiptResult"]) {
            //                EWHReceipt* receipt = [[EWHReceipt alloc] initWithDictionary:element];
            //                [receipts addObject:receipt];
            //            }
            
            EWHCatalog* catalog = [[EWHCatalog alloc]initWithDictionary:dictionary];
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:catalog];
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
