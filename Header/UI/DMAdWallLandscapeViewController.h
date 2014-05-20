//
//  DMAdWallLandscapeViewController.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/17.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMARCMacro.h"
#import "DMAdWallDataManager.h"
#import "DMLoadingView.h"

@class DMDataModelView;

@interface DMAdWallLandscapeViewController : UIViewController <UIScrollViewDelegate, DMAdWallDataManagerDelegate, DMLoadingViewDelegate>

@property (nonatomic, DM_STRONG) DMDataModelView *allModelsView;
@property (nonatomic, DM_STRONG) DMDataModelView *gameModelsView;
@property (nonatomic, DM_STRONG) DMDataModelView *appModelsView;

//
//  用发布者 ID 和广告位 ID 初始化
//
//  @param publisherId 开发者ID
//  @param placementId 广告位ID
//
//  @return DMAppWallViewController
//

- (id)initWithPublisherId:(NSString *)publisherId placementId:(NSString *)placementId;

//
//  请求推广墙数据
//

- (void)loadWallData;

//
//  显示横屏推广墙
//
//  @param viewContoller UIViewController
//
//

- (void)presentAppWallWith:(UIViewController *)viewContoller;

@end
