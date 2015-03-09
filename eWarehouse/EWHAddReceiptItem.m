//
//  EWHAddReceiptItem.m
//  eWarehouse
//
//  Created by Brian Torkelson on 3/4/14.
//
//

#import "EWHAddReceiptItem.h"

@implementation EWHAddReceiptItem

-(void)addReceiptItem:(NSInteger)warehouseId programId:(NSInteger)programId receiptId:(NSInteger)receiptId locationId:(NSInteger)locationId catalogId:(NSInteger)catalogId quantity:(NSInteger)quantity IsBulk:(BOOL)isBulk IsSerialized:(BOOL)IsSerialized itemScan:(NSString *)itemScan user:(EWHUser *)user inventoryTypeId:(NSInteger)inventoryTypeId customAttributes:(NSMutableArray *)customAttributes UOMs:(NSMutableArray *)UOMs
{
    __weak EWHRequest *sender = self;
    
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
        NSString *formatItem = [NSString stringWithFormat:@"{\"UnitOfMeasureId\":%d,\"UnitOfMeasureName\":\"%@\",\"ProgramId\":%d,\"Value\":%@,\"SizeType\":%d,\"UnitOfMeasureType\":%d},",uom.UnitofMeasureId,uom.UnitOfMeasureName,uom.ProgramId,uom.Value,uom.SizeType,uom.UnitOfMeasureType];
        
        itemsArray = [itemsArray stringByAppendingString:formatItem];
    }
    if (itemsArray.length>0) {
        itemsArray = [itemsArray substringToIndex:[itemsArray length]-1];
    }
    
    NSString *url = [NSString stringWithFormat:@"%@%@", super.baseURL, @"/AddItem"];
    request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:url]];
    NSString *postData = [NSString stringWithFormat:@"{\"item\":{\"WarehouseId\":%d ,\"ProgramId\":%d,\"ReceiptId\":%d,\"LocationId\":%d,\"CatalogId\":%d,\"Quantity\":%d,\"IsBulk\":\"%@\",\"IsSerialized\":\"%@\",\"ItemScan\":\"\",\"InventoryTypeId\":\"%d\",\"CACList\":\%@,\"UOMList\":[%@]},\"userId\":%d}", warehouseId,programId,receiptId,locationId,catalogId, quantity, isBulk ? @"true" : @"false", IsSerialized ? @"true" : @"false",inventoryTypeId, CACListString,itemsArray, user.UserId];
    
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