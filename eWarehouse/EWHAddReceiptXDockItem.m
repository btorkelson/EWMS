//
//  EWHAddReceiptItem.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/10/14.
//
//

#import "EWHAddReceiptXDockItem.h"

@implementation EWHAddReceiptXDockItem

-(void)addReceiptItemforXDock:(NSInteger)warehouseId programId:(NSInteger)programId receiptId:(NSInteger)receiptId locationId:(NSInteger)locationId catalogId:(NSInteger)catalogId quantity:(NSInteger)quantity IsBulk:(BOOL)isBulk customAttributes:(NSMutableArray *)customAttributes itemScan:(NSString *)itemScan destinationId:(NSInteger)destinationId inventoryTypeId:(NSInteger)inventoryTypeId shipMethodId:(NSInteger)shipMethodId UOMs:(NSMutableArray *)UOMs deliveryDate:(NSDate*)deliveryDate user:(EWHUser *)user lineNumber:(NSString *)lineNumber lotNumber:(NSString *)lotNumber
{
//    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/AddItemForXDock"];
//    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    NSData *caData = [NSJSONSerialization dataWithJSONObject:customAttributes options:NSJSONWritingPrettyPrinted error:nil];
    NSString *CACListString = [[NSString alloc] initWithData:caData encoding:NSUTF8StringEncoding];
//    NSData *caData2 = [NSJSONSerialization dataWithJSONObject:UOMs options:NSJSONWritingPrettyPrinted error:nil];
//    NSString *UOMListString = [[NSString alloc] initWithData:caData2 encoding:NSUTF8StringEncoding];
    
    
    NSString *itemsArray = @"";
    for (int i=0; i<[UOMs count]; i++)
    {
        EWHUOM *uom = [UOMs objectAtIndex:i];
        //        NSError *e = nil;
        //        NSData *jsonArray = [NSJSONSerialization JSONObjectWithData:detail options:0 error: &e];
        NSString *formatItem = [NSString stringWithFormat:@"{\"UnitOfMeasureId\":%ld,\"UnitOfMeasureName\":\"%@\",\"ProgramId\":%ld,\"Value\":%@,\"SizeType\":%ld,\"UnitOfMeasureType\":%ld},",(long)uom.UnitofMeasureId,uom.UnitOfMeasureName,(long)uom.ProgramId,uom.Value,(long)uom.SizeType,(long)uom.UnitOfMeasureType];
        
        itemsArray = [itemsArray stringByAppendingString:formatItem];
    }
    if (itemsArray.length>0) {
        itemsArray = [itemsArray substringToIndex:[itemsArray length]-1];
    }
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
//    NSString *jsonDeliveryDate = [NSString stringWithFormat:@"/Date(%.0f000%@)/", [deliveryDate timeIntervalSince1970],[formatter stringFromDate:deliveryDate]];

    
    NSString *postData = [NSString stringWithFormat:@"{\"item\":{\"WarehouseId\":%ld ,\"ProgramId\":%ld,\"ReceiptId\":%ld,\"LocationId\":%ld,\"CatalogId\":%ld,\"Quantity\":%ld,\"IsBulk\":\"%@\",\"InventoryTypeId\":\"%ld\",\"CACList\":\%@,\"UOMList\":[%@]},\"destinationId\":%ld,\"shipMethodId\":%ld,\"userId\":%ld,\"deliveryDate\":\"%@\",\"LineNumber\":\"%@\",\"LotNumber\":\"%@\"}", (long)warehouseId,(long)programId,(long)receiptId,(long)locationId,(long)catalogId, (long)quantity, isBulk ? @"true" : @"false",(long)inventoryTypeId, CACListString,itemsArray, (long)destinationId, (long)shipMethodId, (long)user.UserId, [formatter stringFromDate:deliveryDate],lineNumber,lotNumber];
    
    EWHLog(@"%@", postData);
        NSData *data = [postData dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *params = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        
        AFHTTPSessionManager *manager = [[AFHTTPSessionManager alloc]initWithSessionConfiguration:[NSURLSessionConfiguration defaultSessionConfiguration]];
        manager.requestSerializer = [AFJSONRequestSerializer serializer];
        [manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    [manager.requestSerializer setValue:user.AuthHash forHTTPHeaderField:@"authHash"];
        
        AFSecurityPolicy *securityPolicy = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        securityPolicy.allowInvalidCertificates = YES;
        [securityPolicy setValidatesDomainName:NO];
        
        manager.securityPolicy = securityPolicy;
        [manager POST:url parameters:params headers:nil progress:nil  success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
    //    NSError *e = nil;
            
            NSDictionary* dictionary = (NSDictionary*) responseObject;
            
            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
            if(self.caller && self.callback){
                if([self.caller respondsToSelector:self.callback]){
                    [self.caller performSelector:self.callback withObject:response];
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
//    [request addRequestHeader:@"authHash" value:user.AuthHash];
//    [request addRequestHeader:@"Content-Type" value:@"application/json; charset=UTF-8"];
//    [request setTimeOutSeconds:60];
//
//
//    [request setValidatesSecureCertificate:false];
//
//    [request setDelegate:self];
//    [request setCompletionBlock:^{
//        int code = [sender.request responseStatusCode];
//        NSString* responseString = [sender.request responseString];
//        EWHLog(@"%@", responseString);
//        if(code == 200){
//            SBJsonParser* jsonParser = [[SBJsonParser alloc] init];
//            NSError *e = nil;
//            NSDictionary* dictionary = [jsonParser objectWithString:responseString error:&e];
//            EWHResponse* response = [[EWHResponse alloc]initWithDictionary:dictionary];
//            if(self.caller && self.callback){
//                if([self.caller respondsToSelector:self.callback]){
//                    [self.caller performSelector:self.callback withObject:response];
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
//                    [errorDetail setValue:responseString forKey:NSLocalizedDescriptionKey];
//                    self.error = [NSError errorWithDomain:@"everywarehouse.com" code:code userInfo:errorDetail];
//                    [self.caller performSelector:self.errorCallback withObject:self.error];
//                }
//            }
//        }
//    }];
//
//    [request setFailedBlock:^{
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
