//
//  WaitViewController.h
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface WaitViewController : UIViewController 
{
	UIImage *image;
	IBOutlet UIImageView *imageView;
	NSNumber *evil;
	IBOutlet UIImageView *evilView;
	
	IBOutlet UILabel *label;
}

@property (retain, readwrite) UIImage *image;
@property (retain, readwrite) NSNumber *evil;

@end
