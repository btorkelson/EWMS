	//
//  EWHGetCatalogByItemNumberandLocationforMoving.m
//  eWarehouse
//
//  Created by Brian Torkelson on 4/11/19.
//
//

#import "EWHGetCatalogByItemNumberandLocationforMoving.h"

@implementation EWHGetCatalogByItemNumberandLocationforMoving

- (void)getCatalogByItemNumberandLocationforMoving:(NSInteger)programId warehouseId:(NSInteger)warehouseId itemNumber:(NSString *)itemnumber location:(NSString *)location withAuthHash:(NSString *)authHash
{
    
//    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetCatalogByItemNumberandLocationforMoving"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"programId\":%d,\"warehouseId\":%d,\"currentLocationName\":\"%@\",\"itemNumber\":\"%@\"}", programId, warehouseId,location,itemnumber];
       NSData *data = [postData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        [manager.requestSerializer setValue:authHash forHTTPHeaderField:@"authHash"];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        [securityPolicy setValidatesDomainName:NO];
        
        manager.securityPolicy = securityPolicy;
        [manager POST:url parameters:params headers:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSError *e = nil;
            NSMutableArray* catalogs = [[NSMutableArray alloc] init];
            NSDictionary* dictionary = (NSDictionary*) responseObject;
            
            for (NSDictionary* element in [dictionary objectForKey:@"GetCatalogByItemNumberAndLocationForMovingResult"]) {
                EWHCatalog* catalog = [[EWHCatalog alloc] initWithDictionary:element];
                [catalogs addObject:catalog];
            }

            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:catalogs];
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
//    [request addRequestHeader:@"authHash" value:authHash];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
//
//    [request setValidatesSecureCertificate:false];
//
//    EWHLog(@"%@", postData);
//    [request setDelegate:self];
//    [request setCompletionBlock:^{
//        int code = [sender.request responseStatusCode];
//        NSString* responseString = [sender.request responseString];
//        EWHLog(@"%@", responseString);
//
//        if(code == 200){
//            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//            NSError *e = nil;
//            NSMutableArray* catalogs = [[NSMutableArray alloc] init];
//            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//            for (NSDictionary* element in [dictionary objectForKey:@"GetCatalogByItemNumberAndLocationForMovingResult"]) {
//                EWHCatalog* catalog = [[EWHCatalog alloc] initWithDictionary:element];
//                [catalogs addObject:catalog];
//            }
//
//
//            //            NSDictionary* element = [dictionary objectForKey:@"GetCatalogByItemNumberResult"];
//            //            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
//
//            //            for (NSDictionary* element in [dictionary objectForKey:@"GetSavedReceiptResult"]) {
//            //                EWHReceipt* receipt = [[EWHReceipt alloc] initWithDictionary:element];
//            //                [receipts addObject:receipt];
//            //            }
//
//            //EWHCatalog* catalog = [[EWHCatalog alloc]initWithDictionary:dictionary];
//            if(self.caller && self.callback){
//                if([self.caller respondsToSelector:self.callback]){
//                    [self.caller performSelector:self.callback withObject:catalogs];
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
//                    //                [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
//                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
//                    [self.caller performSelector:self.errorCallback withObject:self.error];
//                }
//            }
//        }
//
//    }];
//
//    [request startAsynchronous];
    
}

@end
