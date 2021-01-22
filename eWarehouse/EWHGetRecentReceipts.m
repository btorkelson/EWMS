//
//  EWHGetRecentReceipts.m
//  eWarehouse
//
//  Created by Brian Torkelson on 1/21/21.
//

#import "EWHGetRecentReceipts.h"

@implementation EWHGetRecentReceipts

- (void)getRecentReceipts:(NSInteger)warehouseId programId:(NSInteger)programId withAuthHash:(NSString *)authHash
{
    
//    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/GetReceiptsRecent"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"warehouseId\":\"%ld\",\"programId\":\"%ld\"}", (long)warehouseId, (long)programId];
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
            
            NSDictionary* dictionary = (NSDictionary*) responseObject;
            
            NSMutableArray* receipts = [[NSMutableArray alloc] init];
            for (NSDictionary* element in [dictionary objectForKey:@"GetReceiptsRecentResult"]) {
                EWHReceipt* receipt = [[EWHReceipt alloc] initWithDictionary:element];
                [receipts addObject:receipt];
            }
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:receipts];
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
        

    
}
@end
