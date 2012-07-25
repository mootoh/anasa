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

- (void) sendAsynchrnousRequest:(NSString *)param apiKey:(NSString *)apiKey callback:(void (^)(NSError *, NSObject *))callback
{
    NSURLRequest *request = [self createRequest:param apiKey:apiKey];
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error) {
        if (error) {
            callback(error, nil);
            return;
        }

        callback(nil, [[data JSONValue] objectForKey:@"data"]);
    }];
}

@end

@implementation MTAsana

- (void) login:(NSString *)apiKey callback:(void (^)(NSError *, NSObject *))callback
{
    [self sendAsynchrnousRequest:@"/users/me" apiKey:apiKey callback:callback];
}

- (void) projects:(NSString *)apiKey workspace:(NSString *)workspace callback:(void (^)(NSError *, NSObject *))callback
{
    [self sendAsynchrnousRequest:[NSString stringWithFormat:@"/projects?workspace=%@", workspace] apiKey:apiKey callback:callback];
}

@end