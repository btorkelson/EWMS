//
//  EWHAddReceiptHeader.m
//  eWarehouse
//
//  Created by Brian Torkelson on 2/5/14.
//
//

#import "EWHAddReceiptHeader.h"

@implementation EWHAddReceiptHeader

-(void)addReceiptHeader:(EWHReceipt *)receipt user:(EWHUser *)user
{
    __weak EWHRequest *sender = self;
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/AddReceipt"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    
    
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy-MM-dd HH:mm:ss ZZZZZ"];
    
    NSString *postData = [NSString stringWithFormat:@"{\"receipt\":{\"ReceiptId\":%d ,\"isContainer\":\"%@\",\"ProgramName\":\"%@\",\"WarehouseId\":%d,\"ProgramId\":%d,\"ProjectId\":%d,\"ProjectNumber\":\"%@\",\"ProjectSequenceNumber\":\"%@\",\"CarrierInfoId\":%d,\"CarrierId\":%d,\"CarrierTrackingNumber\":\"%@\",\"VendorInfoId\":%d,\"VendorId\":%d,\"OriginId\":%d,\"DestinationId\":%d,\"ShippingMethod\":%d,\"Comment\":\"%@\",\"ReceivedDate\":\"%@\"},{\"userId\":%d}}", receipt.ReceiptId, receipt.isContainer ? @"true" : @"false", receipt.ProgramName, receipt.WarehouseId, receipt.ProgramId, receipt.ProjectId, receipt.ProjectNumber, receipt.ProjectSequenceNumber, receipt.CarrierInfoId, receipt.CarrierId, receipt.CarrierTrackingNumber, receipt.VendorInfoId, receipt.VendorId, receipt.OriginId, receipt.DestinationId, receipt.ShippingMethod,  receipt.Comments, [formatter stringFromDate:receipt.ReceivedDate], user.UserId];
    
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
