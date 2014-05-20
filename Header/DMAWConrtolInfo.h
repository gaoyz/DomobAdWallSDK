//
//  DMAdConrtolInfo.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2013/12/14.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "DMARCMacro.h"

typedef enum {
    
    kAdWallSortOwn = 1,//自助广告优先，默认
    kAdWallSortDomob ,//多盟广告优先
    kAdWallSortCustom//自定义
    
}AdWallSortMode;

@interface DMAWConrtolInfo : NSObject


@property(nonatomic, assign)BOOL updateEntrnaceImage;         //是否更新入口图片
@property(nonatomic, DM_STRONG)NSString *entranceImageUrl;    //入口图片url
@property(nonatomic, assign)BOOL showUpdate;                  //入口显示更新
@property(nonatomic, DM_STRONG)NSNumber *bannerPlayInterval;  //banner轮播时间
@property(nonatomic, DM_STRONG)NSNumber *adListNumber;        //每页显示广告数目，默认15
@property(nonatomic, assign)AdWallSortMode type;              //广告列表排序模式
@property(nonatomic, assign)BOOL showWithCategory;            //应用列表分类显示，如游戏、应用
@property(nonatomic, DM_STRONG)NSNumber *presentAdLimit;      //每个广告显示的上限，默认10，达到上限后将该广告所在广告位的所有广告记录发送给服务端
@property(nonatomic, assign)BOOL showBanner;                  //是否显示banner
@property(nonatomic, DM_STRONG)NSNumber *timeOutInterval;     //广告过期时间，需重新请求
@property(nonatomic, assign)BOOL showListItemNew;             //新添加的广告是否显示new
@property(nonatomic, assign)BOOL showSearchEntrance;          //是否提供搜索广告功能

@end
