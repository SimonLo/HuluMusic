//
//  HCLrcTool.m
//  LittleFrog
//
//  Created by huangcong on 16/4/24.
//  Copyright © 2016年 HuangCong. All rights reserved.
//

#import "HCLrcTool.h"
#import "HCLrcView.h"
#import "HCLrcModel.h"
@implementation HCLrcTool
+ (void)lrcToolDownloadWithUrl:(NSString *)url setUpLrcView:(HCLrcView *)lrcView
{
    [HCNetWorkTool netWorkToolDownloadWithUrl:url targetPath:NSDocumentDirectory DomainMask:NSUserDomainMask endPath:^(NSURL *endPath) {
        NSMutableArray *lrcArrayM = [NSMutableArray array];
        NSString *path = (NSString *)endPath;
        NSString *lrc = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSArray *Array = [lrc componentsSeparatedByString:@"\n"];
        for (NSString *lrc in Array) {
            if ([lrc hasPrefix:@"[ti:"] || [lrc hasPrefix:@"[ar:"] || [lrc hasPrefix:@"[al:"] || ![lrc hasPrefix:@"["]) {
                continue;
            }
            HCLrcModel *lrcModel = [HCLrcModel lrcModelWithLrcString:lrc];
            [lrcArrayM addObject:lrcModel];
        }
        lrcView.lrcArray = lrcArrayM;
    }];
}
@end
