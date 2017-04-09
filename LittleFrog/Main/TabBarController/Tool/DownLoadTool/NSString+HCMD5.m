//
//  NSString+HCMD5.m
//  HCDownLoaderDemo
//
//  Created by Simon Lo on 2017/3/22.
//  Copyright © 2017年 Simon Lo. All rights reserved.
//

#import "NSString+HCMD5.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (HCMD5)

- (NSString *)md5Str {
    
    const char *data = self.UTF8String;
    
    unsigned char digest[CC_MD5_DIGEST_LENGTH];
    
    CC_MD5(data, (CC_LONG)strlen(data), digest);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i ++) {
        [result appendFormat:@"%02x", digest[i]];
    }
    
    return result;
    
}


@end


