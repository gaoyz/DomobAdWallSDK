/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+DMWebCache.h"

@implementation UIImageView (DMWebCache)

- (void)setDMImageWithURL:(NSURL *)url
{
    [self setDMImageWithURL:url placeholderImage:nil];
}

- (void)setDMImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setDMImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setDMImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
    DMSDWebImageManager *manager = [DMSDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
}

#if NS_BLOCKS_AVAILABLE
- (void)setDMImageWithURL:(NSURL *)url success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setDMImageWithURL:url placeholderImage:nil success:success failure:failure];
}

- (void)setDMImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    [self setDMImageWithURL:url placeholderImage:placeholder options:0 success:success failure:failure];
}

- (void)setDMImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options success:(void (^)(UIImage *image))success failure:(void (^)(NSError *error))failure;
{
    DMSDWebImageManager *manager = [DMSDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options success:success failure:failure];
    }
}
#endif

- (void)cancelDMCurrentImageLoad
{
    [[DMSDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(DMSDWebImageManager *)imageManager didProgressWithPartialImage:(UIImage *)image forURL:(NSURL *)url
{
    self.image = image;
}

- (void)webImageManager:(DMSDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
    self.image = image;
}

@end
