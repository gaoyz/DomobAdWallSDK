//
//  DMBannerScrollVew.m
//  DMAppWall
//
//  Created by Domob Ltd on 2014-1-10.
//  Copyright (c) 2010~2014 Domob Ltd. All rights reserved.
//

#import "DMARCMacro.h"
#import "DMBannerScrollView.h"


#define kDMBannerScrollVew_interval 2.5
/**
 *  banner 广告自动滚动控件
 */
@implementation DMBannerScrollView

#pragma mark - ViewLife

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        _currentIndex = 0;
        self.interval = kDMBannerScrollVew_interval;
        _cellArray = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)dealloc
{
    DM_SAFE_ARC_SUPER_DEALLOC();
    
    DM_SAFE_ARC_RELEASE(_timer);
    DM_SAFE_ARC_RELEASE(_cellArray);
}

- (void)didMoveToSuperview {
    
    if (!_timer) {
        
        [self performSelector:@selector(initTimer) withObject:nil afterDelay:0];
    }
    if (self.superview) {
        
        [super didMoveToSuperview];
        [self initUI];
        // 最少两项才可滚动
        if (_numberOfOptions>2) {
            
            [_timer fire];
        }
    }
    else {
        
        if ([_timer isValid]) {
            
            [_timer invalidate];
            _timer = nil;
        }
    }
}

- (void) reloadData
{
    [self initUI];
}

#pragma mark - Private Method

- (void)initUI {
    
    for (UIView *aView in self.subviews) {
        [aView removeFromSuperview];
    }
    
    [_cellArray removeAllObjects];
    
    float width = self.frame.size.width;
    float height = self.frame.size.height;
    _scrollView = [[UIScrollView alloc] initWithFrame:self.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    [self addSubview:_scrollView];

    DM_SAFE_ARC_RELEASE(_scrollView);
    
    if (![_delegate respondsToSelector:@selector(numberOfOptionsInScrollView:)]) {
        
        return;
    }
    _numberOfOptions = [_delegate numberOfOptionsInScrollView:self];
    
    if (_numberOfOptions<0) {
        
        _numberOfOptions = 0;
    }
    
    if (_numberOfOptions>0) {
        
        _scrollView.contentSize = CGSizeMake(width*_numberOfOptions, height);
        _scrollView.delegate = self;
    }
    for (int i = 0; i<_numberOfOptions; i++) {
        
        DMBannerCell *cell = [[DMBannerCell alloc] initWithFrame:CGRectZero];
        
        if (![_delegate respondsToSelector:@selector(scrollView:customizeCell:atIndex:)]) {
            
            return;
        }
        
        [_delegate scrollView:self customizeCell:cell atIndex:i];
        cell.frame = CGRectMake(i*width, 0, width, height);
        [cell addTarget:self action:@selector(onItemClick:) forControlEvents:UIControlEventTouchUpInside];
        [_cellArray addObject:cell];
        [_scrollView addSubview:cell];

        DM_SAFE_ARC_RELEASE(cell);
        
        if (_currentIndex==i) {
            
            if ([_delegate respondsToSelector:@selector(scrollView:didScrollToIndex:)]) {
                
                [_delegate scrollView:self didScrollToIndex:_currentIndex];
            }
        }
    }
    
    _currentIndex = 0;
}

- (void)initTimer {
    
    _timer = [NSTimer timerWithTimeInterval:self.interval target:self selector:@selector(autoScroll) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:_timer forMode:NSDefaultRunLoopMode];
}

#pragma mark - UIResponder

// banner滚动方法
- (void)autoScroll {
    
    float width = _scrollView.frame.size.width;
    float height = _scrollView.frame.size.height;
    
    _currentIndex++;
    if (_currentIndex>=_numberOfOptions) {
        
        _currentIndex = 0;
    }
    [_scrollView scrollRectToVisible:CGRectMake(_currentIndex*width, 0, width, height) animated:YES];
    if ([_delegate respondsToSelector:@selector(scrollView:didScrollToIndex:)]) {
        
        [_delegate scrollView:self didScrollToIndex:_currentIndex];
    }
}

// banner被点击
- (void)onItemClick:(id)sender {
    
    for (int i=0;i<_cellArray.count;i++) {
        
        DMBannerCell *cell = [_cellArray objectAtIndex:i];
		if (cell == sender) {
            
            cell.selected = YES;
			NSInteger index = [_cellArray indexOfObject:sender];
            if ([_delegate respondsToSelector:@selector(scrollView:didSelectAtIndex:)]) {
                
                [_delegate scrollView:self didSelectAtIndex:index];
            }
		}
	}
}

#pragma mark - UIScrollView Delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    NSInteger index = _scrollView.contentOffset.x/scrollView.frame.size.width;
    
    if (index != _currentIndex) {
        
        _currentIndex = index;
        if ([_delegate respondsToSelector:@selector(scrollView:didScrollToIndex:)]) {
            
            [_delegate scrollView:self didScrollToIndex:index];
        }
    }
}

@end

/**
 *  banner 内容视图
 */
@implementation DMBannerCell

#pragma mark - Instance Method

// 设置banner图片
- (void)setBannerContent:(UIImage *)image {
    
    [self setBackgroundImage:image forState:UIControlStateNormal];
}

@end
