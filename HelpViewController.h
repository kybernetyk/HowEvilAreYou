//
//  HelpViewController.h
//  HowEvil
//
//  Created by jrk on 13/9/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface HelpViewController : UIViewController 
{
	IBOutlet UITextView *helpTextView;
}

@property (readwrite, retain) UITextView *helpTextView;

@end
