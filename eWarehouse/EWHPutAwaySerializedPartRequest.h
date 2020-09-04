//
//  EWHLoginNetworkProvider.h
//  eWarehouse
//
//  Created by Zbigniew Kisiel on 7/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "EWHRequestAF.h"
#import "EWHReceiptDetail.h"
#import "EWHResponse.h"

@interface EWHPutAwaySerializedPartRequest : EWHRequestAF
{
}

- (void)putAwayPart:(EWHReceiptDetail *)receiptDetail location:(NSString *)locationName serialNumbers:(NSString *) serialNumbers user:(EWHUser *)user;

@end
