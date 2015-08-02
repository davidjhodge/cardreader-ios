//
//  CreditCardManager.h
//  CardReader
//
//  Created by David Hodge on 8/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CreditCard.h"

@interface CreditCardManager : NSObject

+ (instancetype)defaultManager;

@property (nonatomic, strong) CreditCard *card;

@end
