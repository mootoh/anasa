//
//  MTAsana.h
//  anasa
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAsana : NSObject

/*
 * user: {
 *   email,
 *   id,
 *   name,
 *   workspaces: [
 *     {
 *       id,
 *       name
 *     },
 *   ...
 *   ]
 * }
 */
- (void) login:(NSString *)apiKey callback:(void (^)(NSError *, NSDictionary *user))callback;

- (void) projects:(NSString *)apiKey workspace:(NSString *)workspace callback:(void (^)(NSError *, NSArray *projects))callback;

@end