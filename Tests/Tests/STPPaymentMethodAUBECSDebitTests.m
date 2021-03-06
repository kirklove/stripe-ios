//
//  STPPaymentMethodAUBECSDebitTests.m
//  StripeiOS Tests
//
//  Created by Cameron Sabol on 3/4/20.
//  Copyright © 2020 Stripe, Inc. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "STPAPIClient+Private.h"
#import "STPPaymentIntent+Private.h"
#import "STPPaymentMethod.h"
#import "STPPaymentMethodAUBECSDebit.h"
#import "STPTestingAPIClient.h"

static NSString * kAUBECSDebitPaymentIntentClientSecret = @"";


@interface STPPaymentMethodAUBECSDebitTests : XCTestCase

@property (nonatomic, readonly) NSDictionary *auBECSDebitJSON;

@end

@implementation STPPaymentMethodAUBECSDebitTests

- (void)_retrieveAUBECSDebitJSON:(void (^)(NSDictionary *))completion {
    if (self.auBECSDebitJSON) {
        completion(self.auBECSDebitJSON);
    } else {
        STPAPIClient *client = [[STPAPIClient alloc] initWithPublishableKey:@""];
        [client retrievePaymentIntentWithClientSecret:kAUBECSDebitPaymentIntentClientSecret
                                               expand:@[@"payment_method"] completion:^(STPPaymentIntent * _Nullable paymentIntent, __unused NSError * _Nullable error) {
            self->_auBECSDebitJSON = paymentIntent.paymentMethod.auBECSDebit.allResponseFields;
            completion(self.auBECSDebitJSON);
        }];
    }
}

// test disabled currently because our test account doesn't support AU BECS at the moment
- (void)_disabled_testCorrectParsing {
    [self _retrieveAUBECSDebitJSON:^(NSDictionary *json) {
         STPPaymentMethodAUBECSDebit *auBECSDebit = [STPPaymentMethodAUBECSDebit decodedObjectFromAPIResponse:json];
           XCTAssertNotNil(auBECSDebit, @"Failed to decode JSON");
    }];
}

// test disabled currently because our test account doesn't support AU BECS at the moment
- (void)_disabled_testFailWithoutRequired {
    [self _retrieveAUBECSDebitJSON:^(NSDictionary *json) {
        NSMutableDictionary *auBECSDebitJSON = [json mutableCopy];
        [auBECSDebitJSON setValue:nil forKey:@"bsb_number"];
        XCTAssertNil([STPPaymentMethodAUBECSDebit decodedObjectFromAPIResponse:auBECSDebitJSON], @"Should not intialize with missing `bsb_number`");
    }];

    [self _retrieveAUBECSDebitJSON:^(NSDictionary *json) {
        NSMutableDictionary *auBECSDebitJSON = [json mutableCopy];
        [auBECSDebitJSON setValue:nil forKey:@"last4"];
        XCTAssertNil([STPPaymentMethodAUBECSDebit decodedObjectFromAPIResponse:auBECSDebitJSON], @"Should not intialize with missing `last4`");
    }];

    [self _retrieveAUBECSDebitJSON:^(NSDictionary *json) {
        NSMutableDictionary *auBECSDebitJSON = [json mutableCopy];
        [auBECSDebitJSON setValue:nil forKey:@"fingerprint"];
        XCTAssertNil([STPPaymentMethodAUBECSDebit decodedObjectFromAPIResponse:auBECSDebitJSON], @"Should not intialize with missing `fingerprint`");
    }];
}

@end
