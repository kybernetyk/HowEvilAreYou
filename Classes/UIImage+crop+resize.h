//
//  UIImage+crop+resize.h
//  XFTest
//
//  Created by jrk on 24/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface UIImage (crop_resize)
- (UIImage*)imageByScalingAndCroppingForSize:(CGSize)targetSize;


@end
