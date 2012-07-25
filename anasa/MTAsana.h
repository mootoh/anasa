//
//  MTAsana.h
//  anasa
//
//  Created by Motohiro Takayama on 7/24/12.
//  Copyright (c) 2012 mootoh.net. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MTAsana : NSObject

- (void) login:(NSString *)apiKey callback:(void (^)(NSError *))callback;

@end