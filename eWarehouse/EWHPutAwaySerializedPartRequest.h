//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequest.h"
#import "EWHReceiptDetail.h"
#import "EWHResponse.h"

@interface EWHPutAwaySerializedPartRequest : EWHRequest
{
}

- (void)putAwayPart:(EWHReceiptDetail *)receiptDetail location:(NSString *)locationName serialNumbers:(NSString *) serialNumbers user:(EWHUser *)user;

@end