//
//  AnalyzeViewController.h
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface AnalyzeViewController : UIViewController 
{
	IBOutlet UIImageView *imageView;
	IBOutlet UIImageView *villainImageView;
	IBOutlet UILabel *textView;
	IBOutlet UILabel *youAreTextView;
	IBOutlet UILabel *label;
	UIImage *image;
	
	NSNumber *evil;
	
	NSArray *villains;
	
	NSString *wikiurl;
}
@property (retain, readwrite) UIImage *image;
@property (retain, readwrite) NSNumber *evil;

- (IBAction) visitWikipedia: (id) sender;

@end
