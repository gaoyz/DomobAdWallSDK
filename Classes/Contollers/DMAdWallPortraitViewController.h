//
//  DMAdWallPortraitViewController.h
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-8.
//  Copyright (c) 2010～2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMARCMacro.h"
#import "DMAdWallDataManager.h"
#import "DMLoadingView.h"

@class DMDataModelView;

@interface DMAdWallPortraitViewController : UIViewController <UIScrollViewDelegate, DMAdWallDataManagerDelegate, DMLoadingViewDelegate>

@property (nonatomic, DM_STRONG) DMDataModelView *allModelsView;
@property (nonatomic, DM_STRONG) DMDataModelView *gameModelsView;
@property (nonatomic, DM_STRONG) DMDataModelView *appModelsView;

/**
 *  实例化
 *
 *  @param publisherId 开发者ID
 *  @param placementId 广告位ID
 *
 *  @return DMAppWallViewController
 */
- (id)initWithPublisherId:(NSString *)publisherId placementId:(NSString *)placementId;

/**
 *  预加载推广墙数据
 */
- (void)loadWallData;

/**
 *  显示推广墙
 *
 *  @param viewContoller UIViewController
 */
- (void)presentAppWallWith:(UIViewController *)viewContoller;

@end
