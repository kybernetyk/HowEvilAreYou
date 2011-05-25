//
//  XFFaceView.m
//  XFTest
//
//  Created by jrk on 24/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//
#import "XFFaceView.h"
#import "UIImage+crop+resize.h"
#import "MGTouchView.h"
#import <QuartzCore/QuartzCore.h>

#define CROPSCALING 1

@implementation XFFaceView
@synthesize faceImage;
@synthesize markers;
@synthesize delegate;

- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) 
	{
		[self setup];
    }
    return self;
}


- (void)awakeFromNib
{
	[self setup];
}

- (void) addMarkerAtPosition: (CGPoint) position
{
	if (!markers)
		markers = [[NSMutableArray alloc] initWithCapacity: 3];
	
	MGTouchView *tv = [[MGTouchView alloc] initWithFrame: CGRectMake(0, 0, 50, 50)];
	tv.center = position;
	tv.color = [UIColor colorWithRed: 0.2 green: 1.0 blue:0.0 alpha:0.7];
	tv.showArrows = YES;
	
	MGTouchView *view = tv;
	
	CAKeyframeAnimation *rotation = [CAKeyframeAnimation animationWithKeyPath: @"transform"];
	rotation.repeatCount = HUGE_VALF; // "1000 full-circle repetitions ought to be enough for anybody."
	rotation.values = [NSArray arrayWithObjects:
					   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(0.0f, 0.0f, 0.0f, 1.0f)],
					   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI, 0.0f, 0.0f, 1.0f)],
					   [NSValue valueWithCATransform3D:CATransform3DMakeRotation(M_PI * 2.0, 0.0f, 0.0f, 1.0f)],
					   nil];
	rotation.duration = 1.5; // duration to animate a full revolution of 2*Pi radians.
	[view.layer addAnimation:rotation forKey:@"transform"];
	

	CAKeyframeAnimation *zoom = [CAKeyframeAnimation animationWithKeyPath: @"transform.scale"];
	zoom.repeatCount = HUGE_VALF; // "1000 full-circle repetitions ought to be enough for anybody."
	zoom.values = [NSArray arrayWithObjects:
					   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)],
					   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.7, 0.7, 1.0)],
					   [NSValue valueWithCATransform3D:CATransform3DMakeScale(0.5, 0.5, 1.0)],
				   nil];
	zoom.duration = 1.0; // duration to animate a full revolution of 2*Pi radians.
	[view.layer addAnimation:zoom forKey:@"transform.scale"];

/*	CAAnimationGroup *g = [CAAnimationGroup animation];
	[g setAnimations:[NSArray arrayWithObjects:rotation,zoom,nil]];
	g.duration = 3.0;
	g.repeatCount = 1000;
	[view.layer addAnimation:g forKey:@"zoomAndRotate"];
*/	
	
	[markers addObject: tv];
	[tv release];
	
	[self addSubview: tv];
	
	[delegate faceView: self markersDidChange: markers];
}

- (void)setup
{
	NSLog(@"penissssssssss");
	markerIndex = 0;
/*	[self addMarkerAtPosition: CGPointMake(40.0, 100.0)];
	[self addMarkerAtPosition: CGPointMake(200.0, 100.0)];
	[self addMarkerAtPosition: CGPointMake(120.0, 300.0)];
	[self addMarkerAtPosition: CGPointMake(120.0, 100.0)];	*/
}

- (void) clearMarkers
{
	NSLog(@"clearing markers!");
	
	for (UIView *marker in markers)
	{
		[marker removeFromSuperview];		
	}
	[markers release], markers = nil;

	[self setNeedsDisplay];
	[delegate faceView: self markersDidChange: markers];
}

- (void)setFaceImage: (UIImage *) newImage
{
	[faceImage release], faceImage = nil;
	for (UIView *marker in markers)
	{
		[marker removeFromSuperview];		
	}
	[markers release], markers = nil;
	
	if (newImage)
	{
#ifdef CROPSCALING
		CGSize viewSize = [self bounds].size;
		viewSize.width *= 2.0;
		viewSize.height *= 2.0; //lol retina hardcode. (fuer lol normaltelefone skallieren wir hoch und dann wieder runter xD)
		faceImage = [newImage imageByScalingAndCroppingForSize: viewSize];
#else
		faceImage = newImage;
#endif
		[faceImage retain];
	}
	[self setNeedsDisplay];
	[delegate faceView: self markersDidChange: markers];
}

//no cropping popping
//for our high quality default images
- (void)setFaceImage2: (UIImage *) newImage
{
//	CGSize viewSize = [self bounds].size;
//	NSLog(@"%f, %f",viewSize.width,viewSize.height );
	
	[faceImage release], faceImage = nil;
	for (UIView *marker in markers)
	{
		[marker removeFromSuperview];		
	}
	[markers release], markers = nil;
	
	if (newImage)
	{
		faceImage = newImage;
		[faceImage retain];
	}
	[self setNeedsDisplay];
	[delegate faceView: self markersDidChange: markers];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect 
{
	[[UIColor blackColor] set];
	UIRectFill(rect);
	
	if (faceImage)
	{
/*#ifdef CROPSCALING
		CGSize imgSize = faceImage.size;
		CGSize viewSize = [self bounds].size;
		CGPoint pt = CGPointMake((viewSize.width - imgSize.width) / 2.0, (viewSize.height - imgSize.height) / 2.0);
		[faceImage drawAtPoint:pt blendMode:kCGBlendModeNormal alpha:1.0];
#else*/
		[faceImage drawInRect: [self bounds]];
//#endif
	}
	
	[[UIColor colorWithWhite: 1.0f alpha: 0.5] set];
	

	for (int i = 1; i <= [markers count]; i++)
	{
		int one = i -1;
		int two = i;
		
		if (i == [markers count])
		{
			if ([markers count] > 2)
			{			
				one = 0;
				two = i-1;	
			}
			else
			{
				break;
			}
			
		}
		
		UIView *prevView = [markers objectAtIndex: one];
		UIView *thisView = [markers objectAtIndex: two];
		
		//draw lines
		UIBezierPath *path = [UIBezierPath bezierPath];
		[path setLineWidth: 4.0];
		
		CGPoint pt = [prevView center];
		[path moveToPoint:pt];
		
		CGPoint dt = [thisView center];
/*		
		float dx = (dt.x - pt.x) * lineperc;
		float dy = (dt.y - pt.y) * lineperc;
		
		pt.x += dx;
		pt.y += dy;*/
		[path addLineToPoint: dt];
		[path closePath];
		[path stroke];
	}
	
	
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
	if (!faceImage)
		return;
	
	// Create new MGTouchView(s) at appropriate coordinates, and begin tracking them.
	for (UITouch *touch in touches) 
	{
		CGPoint pos = [touch locationInView: self];
		
		if ([markers count] < 3)
		{
			[self addMarkerAtPosition: pos];	
		}
		/*else
		{
			UIView *marker = [markers objectAtIndex: markerIndex ++];
			[marker setCenter: pos];
			if (markerIndex >= 3)
				markerIndex = 0;
		}*/

		
	}
	
	[self setNeedsDisplay];
}

- (void)dealloc 
{
	[markers release], markers = nil;
    [super dealloc];
}


@end
