//
//  UIImageView+Cache.m
//  LoadImage
//
//  Created by zdy on 13-8-18.
//  Copyright (c) 2013年 ZDY. All rights reserved.
//

#import "UIImageView+Cache.h"

@implementation UIImageView (Cache)
- (void)dealloc
{
   
    [super dealloc];
}
- (void)setImageWithUrl:(NSString*)url
{
    NSURL *neturl = [NSURL URLWithString:url];
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSData *data = [NSData dataWithContentsOfURL:neturl];
        UIImage *image = [UIImage imageWithData:data];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.image = image;
        });
    });
}
- (void)setImageWithRequest:(NSString *)url
{
    NSURL *neturl = [NSURL URLWithString:url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL:neturl];
    [request setTimeoutInterval:30];
    [request setHTTPMethod:@"GET"];
    [request setCachePolicy:NSURLRequestReturnCacheDataElseLoad];
    NSOperationQueue *queue = [[NSOperationQueue alloc]init];
   [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *reponse, NSData *data, NSError *error) {
       UIImage *image = [UIImage imageWithData:data];
       dispatch_async(dispatch_get_main_queue(), ^{
           self.image = image;
       });
   }];
    [queue release];
    [request release];
  
}

@end
