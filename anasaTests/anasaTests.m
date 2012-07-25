//
//  anasaTests.m
//  anasaTests
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import "anasaTests.h"
#import "MTAsana.h"
#import "anasaApiKey.h"

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

    MTAsana *asana = [[MTAsana alloc] init];
    [asana login:kASANA_API_TOKEN callback:^void(NSError *error, NSDictionary *user) {
        STAssertNil(error, @"should succeed");

        NSLog(@"user = %@", user);
        STAssertNotNil([user objectForKey:@"id"], @"user should have an id");

        NSArray *workspaces = [user objectForKey:@"workspaces"];
        STAssertTrue([workspaces count] > 0, @"user should have at least one workspace");

        finished = YES;
    }];

    while (! finished)
        sleep(1);
}

@end
