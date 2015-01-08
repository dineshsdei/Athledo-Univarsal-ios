/*
 * This file is part of the SDWebImage package.
 * (c) Olivier Poitrey <rs@dailymotion.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import "UIImageView+WebCache.h"
//static UIActivityIndicatorView *loader;

@implementation UIImageView (WebCache)

- (void)setImageWithURL:(NSURL *)url
{
    [self setImageWithURL:url placeholderImage:nil];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder
{
    [self setImageWithURL:url placeholderImage:placeholder options:0];
}

- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholder options:(SDWebImageOptions)options
{
//    [loader removeFromSuperview];
//    loader = nil;
//    loader = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
//    [self addSubview:loader];
//    loader.frame = CGRectMake(self.bounds.size.width/2 - 15, self.bounds.size.height/2 - 15, 30, 30);
//    [loader setHidesWhenStopped:YES];    
//    [loader startAnimating];
    
    SDWebImageManager *manager = [SDWebImageManager sharedManager];

    // Remove in progress downloader from queue
    [manager cancelForDelegate:self];

    self.image = placeholder;

    if (url)
    {
        [manager downloadWithURL:url delegate:self options:options];
    }
//    else
//    {
//        [loader stopAnimating];
//        [loader removeFromSuperview];
//        loader = nil;
//
//    }
}

- (void)cancelCurrentImageLoad
{
//    [loader stopAnimating];
//    [loader removeFromSuperview];
//    loader = nil;

    [[SDWebImageManager sharedManager] cancelForDelegate:self];
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image
{
//    [loader stopAnimating];
//    [loader removeFromSuperview];
//    loader = nil;
    self.image = image;
}

@end
