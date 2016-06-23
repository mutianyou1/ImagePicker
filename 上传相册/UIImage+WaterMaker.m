//
//  UIImage+WaterMaker.m
//  上传相册
//
//  Created by 潘元荣(外包) on 16/6/23.
//  Copyright © 2016年 mutianyou1. All rights reserved.
//

#import "UIImage+WaterMaker.h"
#define kSCALE (self.size.width*self.size.height) / ([UIScreen mainScreen].bounds.size.width*[UIScreen mainScreen].bounds.size.height)
#define kPROPORTIONH self.size.height / [UIScreen mainScreen].bounds.size.height
#define kPROPORTIONW self.size.width / [UIScreen mainScreen].bounds.size.height
#define kSYSTEMGARY [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:0.8]

@implementation UIImage (WaterMaker)
- (UIImage *)waterMakerWithString:(NSString *)string{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 1.0);
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    [string drawAtPoint:CGPointMake(self.size.width - 200*kPROPORTIONW, 40) withAttributes:@{NSFontAttributeName : [UIFont systemFontOfSize:(self.size.height>self.size.width?30*kPROPORTIONW:30*kPROPORTIONH)],NSForegroundColorAttributeName : kSYSTEMGARY}];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}
@end
