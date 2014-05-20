//
//  DMDataModelView.m
//  DomobAdWallCoreSDK
//
//  Created by Domob Ltd on 2014/02/12.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import "UIImageView+DMWebCache.h"

#import "DMARCMacro.h"
#import "DMUtil.h"
#import "DMAWAdInfo.h"
#import "DMAdWallDataManager.h"
#import "DMDataModelView.h"

#define kDMAWAdsIconWidth 60
#define kDMAWAdsIconHeight 60
#define kDMAWAdsCellHeight 86
#define kDMAWBannerControlHeight 100
#define kDMAWBannerCellHeight 105
#define kDMAWBlankMarginHeight 12

@implementation DMDataModelView
@synthesize dataModelManager = _dataModelManager;
@synthesize dataModelCategory = _dataModelCategory;
@synthesize dataModels = _dataModels;
@synthesize bannerDataModels = _bannerDataModels;
@synthesize tableView = _tableView;
@synthesize isLandscape = _isLandscape;
@synthesize hasBanner = _hasBanner;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];

    if (self) {
        [self setIsLandscape:NO];
        
        UITableView *tv = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        [tv setBackgroundView:nil];
        [tv setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
        [tv setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        [tv setIndicatorStyle:UIScrollViewIndicatorStyleDefault];
        [tv setDataSource:self];
        [tv setDelegate:self];
        [self addSubview:tv];
        [self setTableView:tv];
        
        [self.tableView reloadData];
    }
    
    return self;
}

- (void)dealloc
{
    DM_SAFE_ARC_SUPER_DEALLOC();
    
    DM_SAFE_ARC_RELEASE(self.tableView);
    DM_SAFE_ARC_RELEASE(self.dataModelManager);
    DM_SAFE_ARC_RELEASE(self.dataModels);
    DM_SAFE_ARC_RELEASE(self.bannerDataModels);
}

#pragma mark -
#pragma mark - BannerControl Delegate

- (NSInteger)numberOfOptionsInScrollView:(DMBannerScrollView *)scrollView
{
    return self.bannerDataModels.count;
}

- (void)scrollView:(DMBannerScrollView *)scrollView customizeCell:(DMBannerCell *)cell atIndex:(NSInteger)index
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, scrollView.frame.size.width, scrollView.frame.size.height)];

    DMAWAdInfo *dataModel = [self.bannerDataModels objectAtIndex:index];
    
    [imageView setDMImageWithURL:[NSURL URLWithString:dataModel.imageUrl] placeholderImage:nil];
    [imageView setClipsToBounds:YES];

    [cell addSubview:imageView];
    
    DM_SAFE_ARC_RELEASE(imageView);
}

- (void)scrollView:(DMBannerScrollView *)scrollView didScrollToIndex:(NSInteger)index
{
    // 发送banner展现报告
    DMAWAdInfo *dataModel = [self.bannerDataModels objectAtIndex:index];
    [self.dataModelManager sendImpressionReportWithAdList:[NSArray arrayWithObject:dataModel]];
}

- (void)scrollView:(DMBannerScrollView *)scrollView didSelectAtIndex:(NSInteger)index
{
    // 触发banner广告点击事件
    DMAWAdInfo *dataModel = [self.bannerDataModels objectAtIndex:index];
    [self.dataModelManager onClickAdItemWithInfo:dataModel type:kDMAWClickTypeBanner position:0];
}

#pragma mark -
#pragma mark - UITableView Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    NSInteger sections = 0;
    
    sections = 2;
    
    return sections;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSInteger rows = 0;
    
    switch (section) {
        case 0: {
            rows = 1;

            break;
        }
        case 1: {
            rows = [self.dataModels count];
        }
        default: {
            rows = [self.dataModels count];
            break;
        }
    }
    
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *tableCellIdentifier = @"TableTableViewCell";
    UITableViewCell *cell = nil;
    
    if (!cell){
        cell = DM_SAFE_ARC_AUTORELEASE([[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:tableCellIdentifier]);
    }
    else {
//        [[cell subviews] makeObjectsPerformSelector:@selector(removeFromSuperview)];
    }
    
    if (indexPath.section == 0 ) {
        [cell setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
        
        if (self.hasBanner) {
            DMBannerScrollView *bannerContainerView = [[DMBannerScrollView alloc] initWithFrame:CGRectMake(0, 0, cell.frame.size.width, kDMAWBannerControlHeight)];
            [bannerContainerView setDelegate:self];
            [bannerContainerView setBackgroundColor:[UIColor whiteColor]];
            [bannerContainerView setInterval:5.0f];
            [cell addSubview:bannerContainerView];
            DM_SAFE_ARC_RELEASE(bannerContainerView);
            
            UIImageView *separator = [[UIImageView alloc] initWithFrame:CGRectMake(0, bannerContainerView.frame.origin.y+bannerContainerView.frame.size.height, cell.frame.size.width, 0.5f)];
            [separator setBackgroundColor:[UIColor colorWithHexString:@"#000000" alpha:0.2f]];
            [cell addSubview:separator];
            DM_SAFE_ARC_RELEASE(separator);
            
            [bannerContainerView reloadData];
        }
    }
    else {
        UIImage *image = [DMUtil getUIImageFromDMBundleWithImageName:@"dm_list_bg"];
        UIImageView *backgroundImageView = [[UIImageView alloc] initWithImage:image];
        
        if (self.isLandscape) {
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            [cell setBackgroundColor:[UIColor colorWithHexString:@"#eaeaea" alpha:1.0f]];
            
            if (iPhone5) {
                [backgroundImageView setFrame:CGRectMake(0, 0, tableView.frame.size.width-22, image.size.height)];
            }
            else {
                [backgroundImageView setFrame:CGRectMake(0, 0, tableView.frame.size.width-15, image.size.height)];
            }
            
            [cell addSubview:backgroundImageView];

            DM_SAFE_ARC_RELEASE(backgroundImageView);
        }
        else {
            UIImage *selectedImage = [DMUtil getUIImageFromDMBundleWithImageName:@"dm_list_bg_pressed"];
            UIImageView *selectedBackgroundImageView = [[UIImageView alloc] initWithImage:selectedImage];

            [cell setBackgroundView:backgroundImageView];
            [cell setSelectedBackgroundView:selectedBackgroundImageView];

            DM_SAFE_ARC_RELEASE(backgroundImageView);
            DM_SAFE_ARC_RELEASE(selectedBackgroundImageView);
        }
        
        DMAWAdInfo *dataModel = [self.dataModels objectAtIndex:indexPath.row];
        
        UIImageView *imageView = nil;
        
        if (self.isLandscape) {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(16, 10, kDMAWAdsIconWidth, kDMAWAdsIconHeight)];
        }
        else {
            imageView = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, kDMAWAdsIconWidth, kDMAWAdsIconHeight)];
        }
        
        [imageView setDMImageWithURL:[NSURL URLWithString:dataModel.logoUrl] placeholderImage:nil];
        [imageView.layer setCornerRadius:10];
        [imageView.layer setBorderColor:[[UIColor colorWithHexString:@"#000000" alpha:0.2f] CGColor]];
        [imageView.layer setBorderWidth:0.5];
        [imageView setClipsToBounds:YES];
        [cell addSubview:imageView];
        DM_SAFE_ARC_RELEASE(imageView);
        
        UIFont *font = [UIFont boldSystemFontOfSize:19.0f];
        CGSize labelSize = [dataModel.title sizeWithFont:font constrainedToSize:CGSizeMake(cell.frame.size.width-kDMAWAdsIconWidth-30-20, cell.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+11, imageView.frame.origin.y+7, labelSize.width, labelSize.height)];
        [nameLabel setTextColor:[UIColor colorWithHexString:@"#3d3d3d" alpha:1.0f]];
        [nameLabel setFont:font];
        [nameLabel setText:dataModel.title];
        [nameLabel setNumberOfLines:0];
        [nameLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [nameLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:nameLabel];
        DM_SAFE_ARC_RELEASE(nameLabel);
        
        font = [UIFont systemFontOfSize:14.0f];
        labelSize = [dataModel.text sizeWithFont:font constrainedToSize:CGSizeMake(cell.frame.size.width-kDMAWAdsIconWidth-30-20, cell.frame.size.height-nameLabel.frame.size.height) lineBreakMode:NSLineBreakByCharWrapping];
        UILabel *descriptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(imageView.frame.origin.x+imageView.frame.size.width+11, nameLabel.frame.origin.y+nameLabel.frame.size.height-5, labelSize.width, font.lineHeight*2+10)];
        [descriptionLabel setTextColor:[UIColor colorWithHexString:@"#afafaf" alpha:1.0f]];
        [descriptionLabel setFont:font];
        [descriptionLabel setText:dataModel.text];
        [descriptionLabel setNumberOfLines:0];
        [descriptionLabel setLineBreakMode:NSLineBreakByCharWrapping];
        [descriptionLabel setBackgroundColor:[UIColor clearColor]];
        [cell addSubview:descriptionLabel];
        DM_SAFE_ARC_RELEASE(descriptionLabel);
        
        UIImageView *accessoryView = [[UIImageView alloc] initWithImage:[DMUtil getUIImageFromDMBundleWithImageName:@"dm_list_arrow"]];
        
        if (self.isLandscape) {
            CGFloat height = [self tableView:tableView heightForRowAtIndexPath:indexPath];
            
            if (iPhone5) {
                [accessoryView setFrame:CGRectMake(tableView.frame.size.width-accessoryView.frame.size.width-29-22, (height-accessoryView.frame.size.height)/2, accessoryView.frame.size.width, accessoryView.frame.size.height)];
            }
            else {
                [accessoryView setFrame:CGRectMake(tableView.frame.size.width-accessoryView.frame.size.width-18-15, (height-accessoryView.frame.size.height)/2, accessoryView.frame.size.width, accessoryView.frame.size.height)];
            }
            
            [cell addSubview:accessoryView];
        }
        else {
            [cell setAccessoryView:accessoryView];
        }

        DM_SAFE_ARC_RELEASE(accessoryView);
        
        dataModel.position = [NSNumber numberWithInteger:indexPath.row+1];
        [self.dataModelManager sendImpressionReportWithAdList:[NSArray arrayWithObject:dataModel]];
    }
    
    return cell;
}

#pragma mark -
#pragma mark - UITableView Delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat height = 0.0f;
    
    switch (indexPath.section) {
        case 0: {
            if (self.hasBanner) {
                height = kDMAWBannerCellHeight;
            }
            else {
                height = kDMAWBlankMarginHeight;
            }

            break;
        }
        case 1: {
            height = kDMAWAdsCellHeight;
            break;
        }
        default: {
            height = kDMAWAdsCellHeight;
            break;
        }
    }

    return height;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row < self.dataModels.count) {
        DMAWAdInfo *dataModel = [self.dataModels objectAtIndex:indexPath.row];
        
        if (dataModel && self.dataModelManager) {
            [self.dataModelManager onClickAdItemWithInfo:dataModel type:kDMAWClickTypeListItem position:[dataModel.position integerValue]];
        }
    }
}

@end
