//
//  DMAdInfo.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2013-12-14.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMARCMacro.h"

@interface DMAWAdInfo : NSObject

@property(nonatomic, DM_STRONG)NSString *adId;          // 应用的唯一标识
@property(nonatomic, DM_STRONG)NSNumber *type;          // 应用的类型 1代表游戏，2代表应用
@property(nonatomic, DM_STRONG)NSNumber *position;      // 应用在UI展示中的位置，如在列表中展示
@property(nonatomic, DM_STRONG)NSString *logoUrl;       // 应用的图标 URL
@property(nonatomic, DM_STRONG)NSString *imageUrl;      // 应用的 Banner URL
@property(nonatomic, DM_STRONG)NSString *thumbnailUrl;  // 应用的缩略图 URL
@property(nonatomic, DM_STRONG)NSString *name;          // 应用的名称
@property(nonatomic, DM_STRONG)NSString *title;         // 应用的广告创意名称
@property(nonatomic, DM_STRONG)NSString *text;          // 应用的宣传语
@property(nonatomic, DM_STRONG)NSString *provider;      // 应用的发行商
@property(nonatomic, DM_STRONG)NSString *identifier;    // 应用的标识
@property(nonatomic, DM_STRONG)NSNumber *versonCode;    // 应用的版本号
@property(nonatomic, DM_STRONG)NSNumber *actionType;    // 广告行为类型
@property(nonatomic, DM_STRONG)NSString *actionUrl;     // 广告行为的 URL
@property(nonatomic, DM_STRONG)NSNumber *size;          // 应用的大小
@property(nonatomic, DM_STRONG)NSNumber *releaseTime;   // 应用的发布时间
@property(nonatomic, DM_STRONG)NSString *tracker;       // 点击报告 ID
@property(nonatomic, DM_STRONG)NSString *trackerUrl;    // 点击报告 URL
@property(nonatomic, DM_STRONG)NSString *itunesId;      // 应用的 iTunes ID
@property(nonatomic, assign) BOOL isNew;              // 应用是否自上次更新以来是否是新的

@end
