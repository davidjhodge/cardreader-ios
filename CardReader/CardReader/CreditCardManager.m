//
//  CreditCardManager.m
//  CardReader
//
//  Created by David Hodge on 8/1/15.
//  Copyright (c) 2015 Genesis Apps, LLC. All rights reserved.
//

#import "CreditCardManager.h"

@interface CreditCardManager()

@end

static CreditCardManager *defaultManager;

@implementation CreditCardManager

+ (instancetype)defaultManager
{
    
    if (!defaultManager)
    {
        static dispatch_once_t onceToken;
        dispatch_once(&onceToken, ^{
            defaultManager = [[self alloc] init];
        });
    }
    
    return defaultManager;
}

- (instancetype)init
{
    self = [super init];
    
    if (self)
    {
        self.card = [[CreditCard alloc] init];
    }
    
    return self;
}

@end
