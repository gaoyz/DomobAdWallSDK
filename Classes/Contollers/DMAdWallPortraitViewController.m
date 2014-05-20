//
//  DMAdWallPortraitViewController.m
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-8.
//  Copyright (c) 2010～2014 Domob Ltd. All rights reserved.
//

#import "DMHMSegmentedControl.h"

#import "DMUtil.h"
#import "DMAWAdInfo.h"
#import "DMAWConrtolInfo.h"
#import "DMDataModelView.h"
#import "DMLoadingView.h"
#import "DMAdWallPortraitViewController.h"

#define kDMAWCategorySegmentedControlHeight 35
#define kDMAWBannerControlHeight 100

@interface DMAdWallPortraitViewController () {
    DMAdWallDataManager *dataModelManager;
    DMAWConrtolInfo *dataModelControlInfo;
    
    double lastRequestTime;
    BOOL isRequesting;
    
    NSMutableArray *adDataModels;
    NSMutableArray *bannerDataModels;
    NSMutableArray *extendDataModels;
    UIScrollView *containerView;
    DMHMSegmentedControl *categorySegmentedControl;
    DMLoadingView *loadingView;
    UIStatusBarStyle statusBarStyle;
}

@end

@implementation DMAdWallPortraitViewController
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

    UIColor *barColor = [UIColor colorWithHexString:@"#5abd21" alpha:1.0f];

    if ([DMUtil supportiOSVerson:7.0]) {
        [self.navigationController.navigationBar setBarTintColor:barColor];
        [self.navigationController.navigationBar setTranslucent:NO];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20], NSFontAttributeName, nil];
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    UIImage *backgroundImage = [DMUtil getUIImageFromDMBundleWithImageName:@"dm_navBar"];
    
    if ([DMUtil supportiOSVerson:5.0]) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationItem setTitle:@"应用推荐"];

    self.navigationItem.leftBarButtonItem = [UIBarButtonItem dmDefaultBackButton:self action:@selector(onBack:)];
    
    CGFloat statusBarHeight1 = [[UIApplication sharedApplication] statusBarFrame].size.height;
    CGFloat navigationBarHeight = self.navigationController.navigationBar.frame.size.height;
    CGFloat offsetY = 0.0f;
    
    if (navigationBarHeight == 0) {
        navigationBarHeight = DMDefaultNavBarHeight;
    }
    
    categorySegmentedControl = [[DMHMSegmentedControl alloc] initWithSectionTitles:@[@"全部", @"游戏", @"应用"]];
    [categorySegmentedControl setSegmentEdgeInset:UIEdgeInsetsMake(0, 10, 0, 10)];
    [categorySegmentedControl setSelectionStyle:DMHMSegmentedControlSelectionStyleFullWidthStripe];
    [categorySegmentedControl setSelectionIndicatorLocation:DMHMSegmentedControlSelectionIndicatorLocationDown];
    [categorySegmentedControl setScrollEnabled:YES];
    [categorySegmentedControl setTextColor:[UIColor grayColor]];
    [categorySegmentedControl setFont:[UIFont systemFontOfSize:15.0f]];
    [categorySegmentedControl setSelectionIndicatorColor:[UIColor colorWithHexString:@"#69c42b" alpha:1.0f]];
    [categorySegmentedControl setSelectedTextColor:[UIColor colorWithHexString:@"#69c42b" alpha:1.0f]];
    [categorySegmentedControl setSelectionIndicatorHeight:2.0f];
    [categorySegmentedControl setAutoresizingMask:UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth];
    [categorySegmentedControl setFrame:CGRectMake(0, offsetY, self.view.frame.size.width, kDMAWCategorySegmentedControlHeight)];
    [categorySegmentedControl addTarget:self action:@selector(handleCategorySegmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:categorySegmentedControl];
    
    offsetY = categorySegmentedControl.frame.origin.y+categorySegmentedControl.frame.size.height;
    
    UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, offsetY, self.view.frame.size.width, 0.5f)];
    [separator setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.2f]];
    [self.view addSubview:separator];
    
    offsetY = separator.frame.origin.y+separator.frame.size.height;
    
    if ([DMUtil supportiOSVerson:7.0f]) {
        containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height-offsetY-statusBarHeight1-navigationBarHeight)];
    }
    else {
        containerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, offsetY, self.view.frame.size.width, self.view.frame.size.height-offsetY-navigationBarHeight)];
    }
    
    [containerView setContentSize:CGSizeMake(self.view.frame.size.width*3, containerView.frame.size.height)];
    [containerView setPagingEnabled:YES];
    [containerView setBackgroundColor:[UIColor redColor]];
    [containerView setDelegate:self];
    [self.view addSubview:containerView];
    
    DMDataModelView *modelView = [[DMDataModelView alloc] initWithFrame:containerView.bounds];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:NO];
    [containerView addSubview:modelView];
    [self setAllModelsView:modelView];
    [self.allModelsView setDataModelManager:dataModelManager];
    
    modelView = [[DMDataModelView alloc] initWithFrame:CGRectMake(containerView.frame.size.width, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:NO];
    [containerView addSubview:modelView];
    [self setGameModelsView:modelView];
    [self.gameModelsView setDataModelManager:dataModelManager];
    
    modelView = [[DMDataModelView alloc] initWithFrame:CGRectMake(containerView.frame.size.width*2, 0, containerView.frame.size.width, containerView.frame.size.height)];
    [modelView setBackgroundColor:[UIColor clearColor]];
    [modelView setIsLandscape:NO];
    [containerView addSubview:modelView];
    [self setAppModelsView:modelView];
    [self.appModelsView setDataModelManager:dataModelManager];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    UIColor *barColor = [UIColor colorWithHexString:@"#5abd21" alpha:1.0f];

    if ([DMUtil supportiOSVerson:7.0]) {
        [self.navigationController.navigationBar setBarTintColor:barColor];
        [self.navigationController.navigationBar setTranslucent:NO];
        
        NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont boldSystemFontOfSize:20], NSFontAttributeName, nil];
        [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    }
    else {
        [self.navigationController.navigationBar setTintColor:barColor];
        [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    }
    
    UIImage *backgroundImage = [DMUtil getUIImageFromDMBundleWithImageName:@"dm_navBar"];
    
    if ([DMUtil supportiOSVerson:5.0]) {
        [self.navigationController.navigationBar setBackgroundImage:backgroundImage forBarMetrics:UIBarMetricsDefault];
    }
    
    [self.navigationItem setTitle:@"应用推荐"];
}

- (void)dealloc
{
    DM_SAFE_ARC_RELEASE(self.allModelsView);
    DM_SAFE_ARC_RELEASE(self.gameModelsView);
    DM_SAFE_ARC_RELEASE(self.appModelsView);
    DM_SAFE_ARC_RELEASE(loadingView);
    DM_SAFE_ARC_RELEASE(categorySegmentedControl);
    DM_SAFE_ARC_RELEASE(containerView);
    DM_SAFE_ARC_RELEASE(dataModelManager);
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
    return NO;
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return UIInterfaceOrientationIsPortrait(interfaceOrientation);
}

- (BOOL)prefersStatusBarHidden
{
    return NO;
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
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            }
        }
        else if ([DMUtil supportiOSVerson:6.0f]) {
            if (iPhone5) {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height+barHeight)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height+barHeight)];
            }
        }
        else {
            if (iPhone5) {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
            }
            else {
                loadingView = [[DMLoadingView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, self.view.frame.size.width, self.view.frame.size.height)];
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
    // 发送显示广告界面
    [dataModelManager sendActivityReport:kActivityEnterReport];
    
    UINavigationController *navContrller = [[UINavigationController alloc] initWithRootViewController:self];
    [viewContoller setModalPresentationStyle:UIModalPresentationFullScreen];
    [viewContoller setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [viewContoller presentViewController:navContrller animated:YES completion:nil];
    
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
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.allModelsView setHasBanner:YES];
            [self.allModelsView setBannerDataModels:bannerDataModels];
        }

        [self.allModelsView.tableView reloadData];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 1];
        NSArray *dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.gameModelsView setDataModels:dataModels];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.gameModelsView setHasBanner:YES];
            [self.gameModelsView setBannerDataModels:bannerDataModels];
        }

        [self.gameModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 2];
        dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.appModelsView setDataModels:dataModels];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.appModelsView setHasBanner:YES];
            [self.appModelsView setBannerDataModels:bannerDataModels];
        }

        [self.appModelsView.tableView reloadData];
    }
}

#pragma mark - UIResponder

- (void)onBack:(id)sender
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
#pragma mark - DMHMSegmentedControlDelegate

- (void) handleCategorySegmentedControlChangedValue:(DMHMSegmentedControl *)segmentedControl
{
    NSInteger selectedPage = segmentedControl.selectedSegmentIndex;
    CGFloat offsetX = selectedPage*containerView.frame.size.width;
    CGFloat offsetY = containerView.contentOffset.y;
    [containerView setContentOffset:CGPointMake(offsetX, offsetY) animated:YES];
}

#pragma mark -
#pragma mark - UIScrollViewDelegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pageWidth = containerView.frame.size.width;
	NSInteger currentPage = floor((containerView.contentOffset.x - pageWidth/2)/pageWidth)+1;
    
    [categorySegmentedControl setSelectedSegmentIndex:currentPage];
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
    CGFloat offsetY = 0.0f;
    
    if (![dataModelControlInfo showWithCategory]) {
        [categorySegmentedControl setHidden:YES];
        [containerView setFrame:CGRectMake(0, offsetY, containerView.frame.size.width, containerView.frame.size.height+categorySegmentedControl.frame.size.height)];
        [containerView setContentSize:CGSizeMake(self.view.frame.size.width, containerView.frame.size.height)];
        [self.allModelsView setFrame:containerView.bounds];
        [self.allModelsView.tableView setFrame:containerView.bounds];
        [self.allModelsView setDataModels:adList];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.allModelsView setHasBanner:YES];
            [self.allModelsView setBannerDataModels:bannerDataModels];
        }
        
        [self.allModelsView.tableView reloadData];
    }
    else {
        [categorySegmentedControl setHidden:NO];
        offsetY = categorySegmentedControl.frame.origin.y+categorySegmentedControl.frame.size.height;
        [containerView setFrame:CGRectMake(0, offsetY, containerView.frame.size.width, containerView.frame.size.height)];
        [containerView setContentSize:CGSizeMake(self.view.frame.size.width*3, containerView.frame.size.height)];
        [self.allModelsView setDataModels:adList];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.allModelsView setHasBanner:YES];
            [self.allModelsView setBannerDataModels:bannerDataModels];
        }
        
        [self.allModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 1];
        dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.gameModelsView setDataModels:dataModels];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.gameModelsView setHasBanner:YES];
            [self.gameModelsView setBannerDataModels:bannerDataModels];
        }
        
        [self.gameModelsView.tableView reloadData];
        
        predicate = [NSPredicate predicateWithFormat:@"self.type.integerValue == %d", 2];
        dataModels = [adDataModels filteredArrayUsingPredicate:predicate];
        [self.appModelsView setDataModels:dataModels];
        
        if (dataModelControlInfo.showBanner && [bannerDataModels count] > 0) {
            [self.appModelsView setHasBanner:YES];
            [self.appModelsView setBannerDataModels:bannerDataModels];
        }
        
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
