//
//  ImageEditingViewController.h
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XFFaceView.h"

@interface ImageEditingViewController : UIViewController 
{
	IBOutlet XFFaceView *faceView;
	
	IBOutlet UIBarButtonItem *helpButton;
	IBOutlet UIBarButtonItem *cameraButton;
	IBOutlet UIBarButtonItem *calculateButton;
	
	float lastEvil;
	NSString *lastMD5;
	
	NSOperationQueue *queue;
}

@property (readwrite, retain) XFFaceView *faceView;
@property (readwrite, assign) float lastEvil;
@property (readwrite, retain) NSString *lastMD5;

- (IBAction) choosePicture: (id) sender;
- (IBAction) calculate: (id) sender;
- (IBAction) help: (id) sender;
@end
