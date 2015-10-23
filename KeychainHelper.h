//
//  KeychainHelper.h
//  YiLife
//
//  Created by zengchao on 14-8-1.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Security/Security.h> 

@interface KeychainHelper : NSObject

+ (void) save:(NSString *)service data:(id)data;
+ (id)   load:(NSString *)service;
+ (void) deleteData:(NSString *)service;

@end
