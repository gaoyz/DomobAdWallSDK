//
//  DMBannerScrollVew.h
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-10.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "DMARCMacro.h"

@class DMBannerScrollView;
@class DMBannerCell;

@protocol DMBannerScrollVewDelegate <NSObject>

- (NSInteger)numberOfOptionsInScrollView:(DMBannerScrollView *)scrollView;
- (void)scrollView:(DMBannerScrollView *)scrollView
     customizeCell:(DMBannerCell *)cell
           atIndex:(NSInteger)index;
- (void)scrollView:(DMBannerScrollView *)scrollView
  didScrollToIndex:(NSInteger)index;
- (void)scrollView:(DMBannerScrollView *)scrollView
  didSelectAtIndex:(NSInteger)index;

@end

/**
 *  banner 广告自动滚动控件
 */

@interface DMBannerScrollView : UIView<UIScrollViewDelegate> {
    
    UIScrollView *_scrollView;
    
    NSMutableArray *_cellArray;
    NSInteger _currentIndex;
    NSInteger _numberOfOptions;
    
    NSTimer *_timer;
}

@property(nonatomic,DM_WEAK)id<DMBannerScrollVewDelegate>delegate;

/**
 *  banner滚动间隔时间，单位秒
 */
@property(nonatomic,assign)double interval;

- (void) reloadData;

@end

/**
 *  banner 内容视图
 */
@interface DMBannerCell : UIButton

/**
 *  设置banner图片
 *
 *  @param image
 */
- (void)setBannerContent:(UIImage *)image;

@end
