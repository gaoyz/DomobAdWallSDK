//
//  DMDataModelView.h
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/12.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMARCMacro.h"
#import "DMBannerScrollView.h"

@class DMAdWallDataManager;

@interface DMDataModelView : UIView <UITableViewDataSource, UITableViewDelegate, DMBannerScrollVewDelegate>

@property (nonatomic, readwrite) BOOL hasBanner;
@property (nonatomic, readwrite) BOOL isLandscape;
@property (nonatomic, readwrite) NSInteger dataModelCategory;
@property (nonatomic, DM_STRONG) DMAdWallDataManager *dataModelManager;
@property (nonatomic, DM_STRONG) NSArray *dataModels;
@property (nonatomic, DM_STRONG) NSArray *bannerDataModels;
@property (nonatomic, DM_STRONG) UITableView *tableView;

@end
