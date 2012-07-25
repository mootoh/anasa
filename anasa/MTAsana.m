//
//  MTAsana.m
//  anasa
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import "MTAsana.h"
#import "NSData+Base64.h"

#define kASANA_API_URL @"https://app.asana.com/api/1.0"

@implementation MTAsana

- (void) login:(NSString *)apiKey callback:(void (^)(NSError *))callback
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
            NSLog(@"error: %@", error);
            callback(error);
            return;
        }
        NSLog(@"status code = %d", [(NSHTTPURLResponse *)response statusCode]);
        NSString *retString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"response = %@", retString);

        // TODO: parse JSON and create user/workspace object.
        callback(nil);
    }];
}

@end