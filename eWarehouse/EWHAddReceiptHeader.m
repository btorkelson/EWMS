//
//  EWHAddReceiptHeader.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/5/14.
//
//

#import "EWHAddReceiptHeader.h"

@implementation EWHAddReceiptHeader

-(void)addReceiptHeader:(EWHNewReceiptDataObject *)receipt user:(EWHUser *)user
{
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/AddReceipt"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZZ"];
    
    NSMutableArray<NSDictionary*> *jsonOffers = [NSMutableArray array];
    for (EWHInboundCustomAttribute* ca in receipt.InboundCustomAttributes) {
        [jsonOffers addObject:[ca toJSON]];
    }
    NSError *e = nil;
    NSData * JSONData = [NSJSONSerialization dataWithJSONObject:jsonOffers options:kNilOptions error:&e];
//    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:receipt.InboundCustomAttributes options:NSJSONWritingPrettyPrinted error:&e];
    NSString *jsonCustomAttributes = [[NSString alloc] initWithData:JSONData encoding:NSUTF8StringEncoding];
    
//    NSString *postData = [NSString stringWithFormat:@"{\"receipt\":{\"ReceiptId\":%ld ,\"isContainer\":\"%@\",\"ProgramName\":\"%@\",\"WarehouseId\":%ld,\"ProgramId\":%ld,\"ProjectId\":%ld,\"ProjectNumber\":\"%@\",\"ProjectSequenceNumber\":\"%@\",\"CarrierInfoId\":0,\"CarrierId\":%ld,\"CarrierTrackingNumber\":\"%@\",\"VendorInvoiceNumber\":\"%@\",\"VendorInfoId\":0,\"VendorId\":%ld,\"OriginId\":%ld,\"DestinationId\":%ld,\"ShippingMethod\":%ld,\"Comment\":\"%@\",\"ReceivedDate\":\"%@\",\"InboundCustomAttributes\":%@},{\"userId\":%ld}}", (long)receipt.ReceiptId, receipt.isContainer ? @"true" : @"false", receipt.program.Name, (long)receipt.warehouse.Id, (long)receipt.program.ProgramId, (long)receipt.ProjectId, receipt.ProjectNumber, receipt.ProjectSequenceNumber,  (long)receipt.carrier.CarrierId, receipt.CarrierTrackingNumber,receipt.VendorInvoiceNumber, (long)receipt.vendor.VendorId, (long)receipt.origin.OriginId, (long)receipt.DestinationId, (long)receipt.shipmethod.ShipMethodId,  receipt.Comments, [formatter stringFromDate:receipt.ReceivedDate],jsonCustomAttributes, (long)user.UserId];
    NSString *postData = [NSString stringWithFormat:@"{\"receipt\":{\"ReceiptId\":%ld ,\"isContainer\":\"%@\",\"ProgramName\":\"%@\",\"WarehouseId\":%ld,\"ProgramId\":%ld,\"ProjectId\":%ld,\"ProjectNumber\":\"%@\",\"ProjectSequenceNumber\":\"%@\",\"CarrierInfoId\":0,\"CarrierId\":%ld,\"CarrierTrackingNumber\":\"%@\",\"VendorInfoId\":0,\"VendorId\":%ld,\"OriginId\":%ld,\"DestinationId\":%ld,\"ShippingMethod\":%ld,\"Comment\":\"%@\",\"ReceivedDate\":\"%@\",\"InboundCustomAttributes\":%@},{\"userId\":%ld}}", (long)receipt.ReceiptId, receipt.isContainer ? @"true" : @"false", receipt.program.Name, (long)receipt.warehouse.Id, (long)receipt.program.ProgramId, (long)receipt.ProjectId, receipt.ProjectNumber, receipt.ProjectSequenceNumber,  (long)receipt.carrier.CarrierId, receipt.CarrierTrackingNumber, (long)receipt.vendor.VendorId, (long)receipt.origin.OriginId, (long)receipt.DestinationId, (long)receipt.shipmethod.ShipMethodId,  receipt.Comments, [formatter stringFromDate:receipt.ReceivedDate],jsonCustomAttributes, (long)user.UserId];
    
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
