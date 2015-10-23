//
//  XweiUDID.m
//  YiLife
//
//  Created by zengchao on 14-8-1.
//  Copyright (c) 2014年 com.nanjingbroadcast. All rights reserved.
//

#import "XweiUDID.h"
#import <CommonCrypto/CommonDigest.h>
#import "KeychainHelper.h"

static NSString * xweiUDIDSessionCache = nil;
static NSString * const KEY_DIC = @"com.xweisoft.apps.udid.dic";
static NSString * const KEY_UDID = @"com.xweisoft.udid.key";

@implementation XweiUDID

+ (NSString*)generateFreshOpenUDID
{
    CFUUIDRef uuid = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef cfstring = CFUUIDCreateString(kCFAllocatorDefault, uuid);
    const char *cStr = CFStringGetCStringPtr(cfstring,CFStringGetFastestEncoding(cfstring));
    unsigned char result[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), result );
    CFRelease(uuid);
    CFRelease(cfstring);
    
    NSString *openUDID = [NSString stringWithFormat:
                          @"%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%02x%08lx",
                          result[0], result[1], result[2], result[3],
                          result[4], result[5], result[6], result[7],
                          result[8], result[9], result[10], result[11],
                          result[12], result[13], result[14], result[15],
                          (unsigned long)(arc4random() % NSUIntegerMax)];
    return openUDID;
}

+ (NSString *)value
{
    if (xweiUDIDSessionCache) {
        return xweiUDIDSessionCache;
    }
    
    //抓取本地
    NSDictionary *dic = (NSDictionary *)[KeychainHelper load:KEY_DIC];
    
    if (dic && [dic isKindOfClass:[NSDictionary class]]) {
        //
        if ([dic.allKeys containsObject:KEY_UDID]) {
            NSString *udid = [dic objectForKey:KEY_UDID];
            xweiUDIDSessionCache = udid;
            return xweiUDIDSessionCache;
        }
    }
    
    
    NSString *newUdid = [XweiUDID generateFreshOpenUDID];
    xweiUDIDSessionCache = newUdid;
    
    NSMutableDictionary *storeDic = [NSMutableDictionary dictionary];
    [storeDic setObject:newUdid forKey:KEY_UDID];
    
    //本地存储
    [KeychainHelper save:KEY_DIC data:storeDic];
    
    return xweiUDIDSessionCache;
}

@end
