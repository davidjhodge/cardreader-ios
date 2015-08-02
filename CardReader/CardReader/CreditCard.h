//
//  CreditCard.h
//  CardReader
//
//  Created by David Hodge on 8/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CreditCard : NSObject

@property (nonatomic, strong) NSString *redactedCardNumber;
@property (nonatomic) NSInteger expirationMonth;
@property (nonatomic) NSInteger expirationYear;
@property (nonatomic) NSInteger cvv;

@end
