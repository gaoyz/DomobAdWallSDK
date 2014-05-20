//
//  DMAdWallLandscapeViewController.m
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/17.
//  Copyright (c) 2010～2014 Domob Ltd. All rights reserved.
//

#import "DMHMSegmentedControl.h"

#import "DMUtil.h"
#import "DMAWAdInfo.h"
#import "DMAWConrtolInfo.h"
#import "DMLoadingView.h"
#import "DMDataModelView.h"
#import "DMButton.h"
#import "DMAdWallLandscapeViewController.h"

#define kDMAWCategorySegmentedControlHeight 35
#define kDMAWBannerControlHeight 100

@interface DMAdWallLandscapeViewController () {
    DMAWConrtolInfo *dataModelControlInfo;
    DMAdWallDataManager *dataModelManager;
    
    double lastRequestTime;
    BOOL isRequesting;
    
    NSMutableArray *adDataModels;
    NSMutableArray *bannerDataModels;
    NSMutableArray *extendDataModels;
    
    UIScrollView *containerView;
    DMLoadingView *loadingView;

    DMButton *allDataModelButton;
    DMButton *gameDataModelButton;
    DMButton *appDataModelButton;
    UIView *toolbar;
    UILabel *titleLabel;
    UIButton *closeButton;
    UIStatusBarStyle statusBarStyle;
}

@end

@implementation DMAdWallLandscapeViewController
@synthesize allModelsView = _allModelsView;
@synthesize gameModelsView = _gameModelsView;
@synthesize appModelsView = _appModelsView;

#pragma mark - lifeCycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    statusBarStyle = [[UIApplication sharedApplication] statusBarStyle];
    
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)]) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    [self.view setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];

    UIImage *image = [DMUtil getUIImageFromDMBundleWithImageName:@"bg_nav"];
    CGFloat barHeight = 20.0f;
    
    if (iPhone5) {
        if ([DMUtil supportiOSVerson:7.0f]) {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 144.0f, self.view.frame.size.width)];
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 144.0f, self.view.frame.size.width+barHeight)];
        }
        else {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 144.0f, self.view.frame.size.width)];
        }
    }
    else {
        if ([DMUtil supportiOSVerson:7.0f]) {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 124.0f, self.view.frame.size.width)];
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 124.0f, self.view.frame.size.width+barHeight)];
        }
        else {
            toolbar = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 124.0f, self.view.frame.size.width)];
        }
    }

    [toolbar setBackgroundColor:[UIColor colorWithPatternImage:image]];
    [self.view addSubview:toolbar];
    
    NSString *title = @"应用推荐";
    UIFont *font = [UIFont boldSystemFontOfSize:23.0f];
    CGSize size = CGSizeZero;
    
#if  __IPHONE_OS_VERSION_MIN_REQUIRED >= 70000
        size = [title sizeWithAttributes:@{NSFontAttributeName:font}];
#else
        size = [title sizeWithFont:font];
#endif
    
    titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((toolbar.frame.size.width-size.width)/2, 27, size.width, size.height)];
    [titleLabel setFont:font];
    [titleLabel setTextColor:[UIColor whiteColor]];
    [titleLabel setText:title];
    [titleLabel setBackgroundColor:[UIColor clearColor]];
    [toolbar addSubview:titleLabel];
    
    UIView *separator = [[UIView alloc] initWithFrame:CGRectMake(0, 69.0f, toolbar.frame.size.width, 1.0f)];
    [separator setBackgroundColor:[UIColor colorWithHexString:@"#3f3f3f" alpha:1.0f]];
    [toolbar addSubview:separator];
    
    image = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_all_grey"];
    UIImage *selectedImage = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_all_green"];
    allDataModelButton = [[DMButton alloc] initWithTitle:@"全部" image:image selectedImage:selectedImage];
    [allDataModelButton setFrame:CGRectMake(0, 70.0f, toolbar.frame.size.width, 50.0f)];
    [allDataModelButton setSelected:YES];
    [allDataModelButton addTarget:self action:@selector(handleAllDataModelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:allDataModelButton];
    
    image = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_game_grey"];
    selectedImage = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_game_green"];
    gameDataModelButton = [[DMButton alloc] initWithTitle:@"游戏" image:image selectedImage:selectedImage];
    [gameDataModelButton setFrame:CGRectMake(0, allDataModelButton.frame.origin.y+allDataModelButton.frame.size.height, toolbar.frame.size.width, 50.0f)];
    [gameDataModelButton addTarget:self action:@selector(handleGameDataModelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:gameDataModelButton];
    
    image = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_app_grey"];
    selectedImage = [DMUtil getUIImageFromDMBundleWithImageName:@"ico_app_green"];
    appDataModelButton = [[DMButton alloc] initWithTitle:@"应用" image:image selectedImage:selectedImage];
    [appDataModelButton setFrame:CGRectMake(0, gameDataModelButton.frame.origin.y+gameDataModelButton.frame.size.height, toolbar.frame.size.width, 50.0f)];
    [appDataModelButton addTarget:self action:@selector(handleAppDataModelButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:appDataModelButton];
    
    [allDataModelButton setButtonSelected:[NSNumber numberWithBool:YES]];
    
    image = [DMUtil getUIImageFromDMBundleWithImageName:@"btn_close_normal"];
    selectedImage = [DMUtil getUIImageFromDMBundleWithImageName:@"btn_close_pressed"];
    closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:image forState:UIControlStateNormal];
    [closeButton setBackgroundImage:selectedImage forState:UIControlStateHighlighted];
    [closeButton setFrame:CGRectMake((toolbar.frame.size.width-image.size.width)/2, toolbar.frame.size.height-image.size.height-21, image.size.width, image.size.height)];
    [closeButton addTarget:self action:@selector(handleCloseButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [toolbar addSubview:closeButton];

    if (iPhone5) {
        if ([DMUtil supportiOSVerson:7.0f]) {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+22.0f, 0.0f, 402.0f, self.view.frame.size.width)];
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+22.0f, 0.0f, 402.0f, self.view.frame.size.width+barHeight)];
        }
        else {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+22.0f, 0.0f, 402.0f, self.view.frame.size.width)];
        }
    }
    else {
        if ([DMUtil supportiOSVerson:7.0f]) {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+15.0f, 0.0f, 341.0f, self.view.frame.size.width)];
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+15.0f, 0.0f, 341.0f, self.view.frame.size.width+barHeight)];
        }
        else {
            containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(toolbar.frame.origin.x+toolbar.frame.size.width+15.0f, 0.0f, 341.0f, self.view.frame.size.width)];
        }
    }
    
    [containerView setContentSize:CGSizeMake(containerView.frame.size.width*3, containerView.frame.size.height)];
    [containerView setPagingEnabled:YES];
    [containerView setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
    [containerView setDelegate:self];
    [self.view addSubview:containerView];
    
    DMDataModelView *modelView = [[DMDataModelView alloc] initWithFrame:containerView.bounds];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:YES];
    [containerView addSubview:modelView];
    [self setAllModelsView:modelView];
    [self.allModelsView setDataModelManager:dataModelManager];
    
    modelView = [[DMDataModelView alloc] initWithFrame:CGRectMake(containerView.frame.size.width, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:YES];
    [containerView addSubview:modelView];
    [self setGameModelsView:modelView];
    [self.gameModelsView setDataModelManager:dataModelManager];
    
    modelView = [[DMDataModelView alloc] initWithFrame:CGRectMake(containerView.frame.size.width*2, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:YES];
    [containerView addSubview:modelView];
    [self setAppModelsView:modelView];
    [self.appModelsView setDataModelManager:dataModelManager];
}

- (void)dealloc
{
    DM_SAFE_ARC_RELEASE(self.allModelsView);
    DM_SAFE_ARC_RELEASE(self.gameModelsView);
    DM_SAFE_ARC_RELEASE(self.appModelsView);
    DM_SAFE_ARC_RELEASE(loadingView);
    DM_SAFE_ARC_RELEASE(containerView);
    DM_SAFE_ARC_RELEASE(titleLabel);
    DM_SAFE_ARC_RELEASE(toolbar);
    DM_SAFE_ARC_RELEASE(adDataModels);
    DM_SAFE_ARC_RELEASE(dataModelManager);
    DM_SAFE_ARC_RELEASE(allDataModelButton);
    DM_SAFE_ARC_RELEASE(gameDataModelButton);
    DM_SAFE_ARC_RELEASE(appDataModelButton);
    DM_SAFE_ARC_RELEASE(dataModelControlInfo);

    [dataModelManager setDelegate:nil];

    DM_SAFE_ARC_SUPER_DEALLOC();
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [[UIApplication sharedApplication] setStatusBarStyle:statusBarStyle];
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsLandscape(interfaceOrientation);
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

-(UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

#pragma mark - Intance Method

- (id)initWithPublisherId:(NSString *)publisherId placementId:(NSString *)placementId
{
    if (self = [super init]) {
        
        dataModelManager = [[DMAdWallDataManager alloc] initWithPublisherId:publisherId placementId:placementId rootViewController:self];
        [dataModelManager setDelegate:self];
        
        CGFloat barHeight = 20.0f;

        if ([DMUtil supportiOSVerson:7.0f]) {
            if (iPhone5) {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(144.0f, 0, self.view.frame.size.height-144.0f, self.view.frame.size.width)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(124.0f, 0, self.view.frame.size.height-124.0f, self.view.frame.size.width)];
            }
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            if (iPhone5) {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(144.0f, 0, self.view.frame.size.height-144.0f, self.view.frame.size.width+barHeight)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(124.0f, 0, self.view.frame.size.height-124.0f, self.view.frame.size.width+barHeight)];
            }
        }
        else {
            if (iPhone5) {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(144.0f, 0, self.view.frame.size.height-144.0f, self.view.frame.size.width)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(124.0f, 0, self.view.frame.size.height-124.0f, self.view.frame.size.width)];
            }
        }

        [loadingView setDelegate:self];
        [self.view addSubview:loadingView];
    }
 
    return self;
}

- (void)loadWallData {
    
    if (isRequesting) {
        return;
    }

    isRequesting = YES;
    lastRequestTime = [[NSDate date] timeIntervalSince1970];
    [dataModelManager requestAdData];
    
    [loadingView showDataLoading];
}

- (void)presentAppWallWith:(UIViewController *)viewContoller
{
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];

    // 发送显示广告界面
    [dataModelManager sendActivityReport:kActivityEnterReport];
    
    [viewContoller setModalPresentationStyle:UIModalPresentationFullScreen];
    [viewContoller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [viewContoller presentViewController:self animated:YES completion:nil];
    
    BOOL shouldReload = NO;
    // 超时后重新请求广告
    double timeOutInterval = [dataModelControlInfo.timeOutInterval longLongValue];
    
    if (lastRequestTime>0&&timeOutInterval>0) {
        if (([[NSDate date] timeIntervalSince1970]-lastRequestTime)*1000>timeOutInterval) {
            
            shouldReload = YES;
        }
    }
    // 广告列表无数据时也重新请求广告
    if (adDataModels.count <= 0) {
        shouldReload = YES;
    }
    
    if (shouldReload) {
        [self loadWallData];
    }
    else {
        [self.allModelsView setDataModels:adDataModels];
        [self.allModelsView setHasBanner:NO];
        [self.allModelsView setBannerDataModels:nil];
        [self.allModelsView.tableView reloadData];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 1];
        NSArray *dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.gameModelsView setDataModels:dataModels];
        [self.gameModelsView setHasBanner:NO];
        [self.gameModelsView setBannerDataModels:nil];
        
        [self.gameModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 2];
        dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.appModelsView setDataModels:dataModels];
        [self.appModelsView setHasBanner:NO];
        [self.appModelsView setBannerDataModels:nil];
        
        [self.appModelsView.tableView reloadData];
    }
}

#pragma mark - UIResponder

- (void)handleAllDataModelButtonTapped:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@ ", [DMButton class]];
    NSArray *buttons = [toolbar.subviews filteredArrayUsingPredicate:predicate];
    
    [buttons makeObjectsPerformSelector:@selector(setButtonSelected:) withObject:[NSNumber numberWithBool:NO]];

    [sender setSelected:YES];
    
    [containerView scrollRectToVisible:CGRectMake(0, 0, containerView.frame.size.width, containerView.frame.size.height) animated:YES];
}

- (void)handleGameDataModelButtonTapped:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@ ", [DMButton class]];
    NSArray *buttons = [toolbar.subviews filteredArrayUsingPredicate:predicate];
    
    [buttons makeObjectsPerformSelector:@selector(setButtonSelected:) withObject:[NSNumber numberWithBool:NO]];
 
    [sender setSelected:YES];
    
    [containerView scrollRectToVisible:CGRectMake(containerView.frame.size.width, 0, containerView.frame.size.width, containerView.frame.size.height) animated:YES];
}

- (void)handleAppDataModelButtonTapped:(id)sender
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@ ", [DMButton class]];
    NSArray *buttons = [toolbar.subviews filteredArrayUsingPredicate:predicate];
    
    [buttons makeObjectsPerformSelector:@selector(setButtonSelected:) withObject:[NSNumber numberWithBool:NO]];

    [sender setSelected:YES];
    
    [containerView scrollRectToVisible:CGRectMake(containerView.frame.size.width*2, 0, containerView.frame.size.width, containerView.frame.size.height) animated:YES];
}

- (void)handleCloseButtonTapped:(id)sender
{
    // 发送退出广告界面报告
    [dataModelManager sendActivityReport:kActivityExitReport];
    
    if ([self respondsToSelector:@selector(dismissViewControllerAnimated:completion:)]) {
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    } else {
        
        [self dismissModalViewControllerAnimated:NO];
    }
}

#pragma mark -
#pragma mark - DMLoadingView Delegate

- (void) reloadData
{
    [self loadWallData];
}

#pragma mark -
#pragma mark - DMDataManager Delegate

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager didReceiveAdList:(NSArray *)adList controlInfo:(DMAWConrtolInfo *)controlInfo bannerList:(NSArray *)bannerList extendList:(NSArray *)extendList
{
    [loadingView removeDataLoading];
    
    isRequesting = NO;
    
    DM_SAFE_ARC_RELEASE(dataModelControlInfo);
    
    dataModelControlInfo = DM_SAFE_ARC_RETAIN(controlInfo);
    
    adDataModels = [[NSMutableArray alloc] initWithArray:adList copyItems:YES];
    bannerDataModels = [[NSMutableArray alloc] initWithArray:bannerList copyItems:YES];
    extendDataModels = [[NSMutableArray alloc] initWithArray:extendList copyItems:YES];
    
    NSPredicate *predicate = nil;
    NSArray *dataModels = nil;
    
    if (![dataModelControlInfo showWithCategory]) {
        predicate = [NSPredicate predicateWithFormat:@"self isKindOfClass:%@ ", [DMButton class]];
        dataModels = [toolbar.subviews filteredArrayUsingPredicate:predicate];

        for (DMButton *iterator in dataModels) {
            [iterator setHidden:YES];
        }

        [containerView setContentSize:CGSizeMake(self.view.frame.size.width, containerView.frame.size.height)];
        [self.allModelsView setDataModels:adList];
        [self.allModelsView setHasBanner:NO];
        [self.allModelsView setBannerDataModels:nil];
        [self.allModelsView.tableView reloadData];
    }
    else {
        [self.allModelsView setDataModels:adList];
        [self.allModelsView setHasBanner:NO];
        [self.allModelsView setBannerDataModels:nil];
        [self.allModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 1];
        dataModels = [adList filteredArrayUsingPredicate:predicate];
        [self.gameModelsView setDataModels:dataModels];
        [self.gameModelsView setHasBanner:NO];
        [self.gameModelsView setBannerDataModels:nil];
        [self.gameModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 2];
        dataModels = [adList filteredArrayUsingPredicate:predicate];
        [self.appModelsView setDataModels:dataModels];
        [self.appModelsView setHasBanner:NO];
        [self.appModelsView setBannerDataModels:nil];
        [self.appModelsView.tableView reloadData];
    }
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager requestAdDataFailed:(NSError *)error
{
    [loadingView showNetworkUnreachable];

    isRequesting = NO;
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager didReceiveSearchedAdList:(NSArray *)adList recommandList:(NSArray *)recommandList
{
    
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager searchAdListFailed:(NSError *)error
{
    
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager didReceiveHotWordArray:(NSArray *)hotWordArray
{
    
}

- (void)DMAdWallDataManager:(DMAdWallDataManager *)manager requestHotWordFailed:(NSError *)error
{
}

@end
