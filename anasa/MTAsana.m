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

@implementation MTAsana (Private)

- (void) addBasicAuthentication:(NSMutableURLRequest *)request apiKey:(NSString *)apiKey
{
    NSString *credential = [NSString stringWithFormat:@"%@:", apiKey];
    NSData *credentialData = [credential dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authValue = [NSString stringWithFormat:@"Basic %@", [credentialData base64EncodingWithLineLength:0]];
    [request setValue:authValue forHTTPHeaderField:@"Authorization"];
}

- (NSURLRequest *) createRequest:(NSString *)param apiKey:(NSString *)apiKey
{
    NSURL *url = [NSURL URLWithString:[kASANA_API_URL stringByAppendingString:param]];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [self addBasicAuthentication:request apiKey:apiKey];
    return request;
}

@end

@implementation MTAsana

- (void) login:(NSString *)apiKey callback:(void (^)(NSError *, NSDictionary *))callback
{
    NSURLRequest *request = [self createRequest:@"/users/me" apiKey:apiKey];

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
    NSURLRequest *request = [self createRequest:[NSString stringWithFormat:@"/projects?workspace=%@", workspace] apiKey:apiKey];

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