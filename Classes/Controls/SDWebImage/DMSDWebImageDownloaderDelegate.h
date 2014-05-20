/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "DMSDWebImageCompat.h"

@class DMSDWebImageDownloader;

/**
 * Delegate protocol for SDWebImageDownloader
 */
@protocol DMSDWebImageDownloaderDelegate <NSObject>

@optional

- (void)imageDownloaderDidFinish:(DMSDWebImageDownloader *)downloader;

/**
 * Called repeatedly while the image is downloading when [SDWebImageDownloader progressive] is enabled.
 *
 * @param downloader The SDWebImageDownloader instance
 * @param image The partial image representing the currently download portion of the image
 */
- (void)imageDownloader:(DMSDWebImageDownloader *)downloader didUpdatePartialImage:(UIImage *)image;

/**
 * Called when download completed successfuly.
 *
 * @param downloader The SDWebImageDownloader instance
 * @param image The downloaded image object
 */
- (void)imageDownloader:(DMSDWebImageDownloader *)downloader didFinishWithImage:(UIImage *)image;

/**
 * Called when an error occurred
 *
 * @param downloader The SDWebImageDownloader instance
 * @param error The error details
 */
- (void)imageDownloader:(DMSDWebImageDownloader *)downloader didFailWithError:(NSError *)error;

@end
