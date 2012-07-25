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

- (void)testLogin
{
    __block BOOL finished = NO;

    MTAsana *asana = [[MTAsana alloc] init];
    [asana login:kASANA_API_TOKEN callback:^void(NSError *error, NSObject *value) {
        STAssertNil(error, @"should succeed");

        NSDictionary *user = (NSDictionary *)value;
        NSLog(@"user = %@", user);
        STAssertNotNil([user objectForKey:@"id"], @"user should have an id");

        NSArray *workspaces = [user objectForKey:@"workspaces"];
        STAssertTrue([workspaces count] > 0, @"user should have at least one workspace");

        finished = YES;
    }];

    while (! finished)
        sleep(1);
}

- (void)testProjects
{
    __block BOOL finished = NO;

    MTAsana *asana = [[MTAsana alloc] init];

    [asana login:kASANA_API_TOKEN callback:^void(NSError *error, NSObject *value) {
        NSDictionary *user = (NSDictionary *)value;
        NSArray *workspaces = [user objectForKey:@"workspaces"];
        [asana projects:kASANA_API_TOKEN workspace:[[workspaces objectAtIndex:0] objectForKey:@"id"] callback:^void(NSError *error, NSObject *value2) {
            STAssertNil(error, @"should succeed");

            NSArray *projects = (NSArray *)value2;
            NSLog(@"projects = %@", projects);
            STAssertTrue([projects count] > 0, @"user should have at least one project");

            finished = YES;
        }];
    }];

    while (! finished)
        sleep(1);
}

@end