//
//  anasaTests.m
//  anasaTests
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import "anasaTests.h"
#import "MTAsana.h"

#define kASANA_API_TOKEN @"your_api_token"

@implementation anasaTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testExample
{
    __block BOOL finished = NO;
    __block BOOL errorOccurred = NO;

    MTAsana *asana = [[MTAsana alloc] init];
    [asana login:kASANA_API_TOKEN callback:^void(NSError *error, NSDictionary *user) {
        errorOccurred = (error != nil);
        finished = YES;
    }];

    while (! finished)
        sleep(1);

    STAssertFalse(errorOccurred, @"should succeed in login");
}

@end
