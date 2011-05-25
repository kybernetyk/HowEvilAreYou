//
//  XFFaceView.h
//  XFTest
//
//  Created by jrk on 24/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface XFFaceView : UIView 
{
	UIImage *faceImage;
	
	NSMutableArray *markers;
	int markerIndex;
	
	id delegate;
}

@property (readwrite, retain) UIImage *faceImage;
@property (readonly) NSArray *markers;
@property (readwrite, assign) id delegate;

- (void) clearMarkers;
- (void)setup;

@end
