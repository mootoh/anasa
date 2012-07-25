//
//  MTAsana.m
//  anasa
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import "MTAsana.h"
#import "NSData+Base64.h"
#import "SBJson/SBJson.h"

#define kASANA_API_URL @"https://app.asana.com/api/1.0"

@implementation MTAsana

- (void) login:(NSString *)apiKey callback:(void (^)(NSError *, NSDictionary *))callback
{
    NSURL *url = [NSURL URLWithString:[kASANA_API_URL stringByAppendingString:@"/users/me"]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // make BASIC authentication
    NSString *credential = [NSString stringWithFormat:@"%@:", apiKey];
    NSData *credentialData = [credential dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [credentialData base64EncodingWithLineLength:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            callback(error, nil);
            return;
        }

        NSDictionary *user = [(NSDictionary *)[data JSONValue] objectForKey:@"data"];
        callback(nil, user);
    }];
}

- (void) projects:(NSString *)apiKey workspace:(NSString *)workspace callback:(void (^)(NSError *, NSArray *))callback
{
    NSURL *url = [NSURL URLWithString:[kASANA_API_URL stringByAppendingFormat:@"/projects?workspace=%@", workspace]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];

    // make BASIC authentication
    NSString *credential = [NSString stringWithFormat:@"%@:", apiKey];
    NSData *credentialData = [credential dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [credentialData base64EncodingWithLineLength:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];

    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            callback(error, nil);
            return;
        }

        NSArray *projects = [(NSDictionary *)[data JSONValue] objectForKey:@"data"];
        callback(nil, projects);
    }];
}

@end