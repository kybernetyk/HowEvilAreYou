//
//  MGTouchView.m
//  TouchTest
//
//  Created by Matt Gemmell on 08/05/2010.
//

#import "MGTouchView.h"
#import <QuartzCore/QuartzCore.h>


@implementation MGTouchView


#pragma mark Setup and teardown


- (id)initWithFrame:(CGRect)frame
{
    if ((self = [super initWithFrame:frame])) {
        self.color = [UIColor colorWithWhite:1.0 alpha:0.8];
		self.opaque = NO;
		self.showArrows = NO;
    }
    return self;
}


- (void)dealloc
{
	NSLog(@"marker dealloc!");
	self.color = nil;
	
	[super dealloc];
}


#pragma mark Drawing


- (void)drawRect:(CGRect)theRect
{
	// Outer ring.
	CGRect rect = self.bounds;
	UIBezierPath *path = [UIBezierPath bezierPathWithOvalInRect:rect];
	rect = CGRectInset(rect, 5, 5);
	[path appendPath:[UIBezierPath bezierPathWithOvalInRect:rect]];
	path.usesEvenOddFillRule = YES;
	[self.color set];
	[path fill];
	
	// Inner disc.
	rect = CGRectInset(rect, 15, 15);
	path = [UIBezierPath bezierPathWithOvalInRect:rect];
	[path fill];
	
	// Arrows.
	if (showArrows) {
		// Top.
		path = [UIBezierPath bezierPath];
		float baseWidth = 14.0;
		float height = 12.0;
		CGPoint pt = CGPointMake(rect.origin.x + ((rect.size.width / 2.0) - (baseWidth / 2.0)), rect.origin.y - (10 + (height / 2.0)));
		[path moveToPoint:pt];
		pt.x += baseWidth;
		[path addLineToPoint:pt];
		pt.x -= (baseWidth / 2.0);
		pt.y += height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Bottom.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x + ((rect.size.width / 2.0) - (baseWidth / 2.0)), 
						 rect.origin.y  + rect.size.height + (10 + (height / 2.0)));
		[path moveToPoint:pt];
		pt.x += baseWidth;
		[path addLineToPoint:pt];
		pt.x -= (baseWidth / 2.0);
		pt.y -= height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Left.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x - (10 + (height / 2.0)),
						 rect.origin.y + ((rect.size.height / 2.0) - (baseWidth / 2.0)));
		[path moveToPoint:pt];
		pt.y += baseWidth;
		[path addLineToPoint:pt];
		pt.y -= (baseWidth / 2.0);
		pt.x += height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
		
		// Right.
		path = [UIBezierPath bezierPath];
		pt = CGPointMake(rect.origin.x + rect.size.height + (10 + (height / 2.0)),
						 rect.origin.y + ((rect.size.height / 2.0) - (baseWidth / 2.0)));
		[path moveToPoint:pt];
		pt.y += baseWidth;
		[path addLineToPoint:pt];
		pt.y -= (baseWidth / 2.0);
		pt.x -= height;
		[path addLineToPoint:pt];
		[path closePath];
		[path fill];
	}
}

#pragma mark Interaction


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{

	
	// Create new MGTouchView(s) at appropriate coordinates, and begin tracking them.
	for (UITouch *touch in touches) 
	{
		CGPoint pos = [touch locationInView: [self superview]];
		NSLog(@"new point: %f, %f",pos.x,pos.y);
	}
	
	[self setNeedsDisplay];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
	for (UITouch *touch in touches) 
	{
		[self setCenter: [touch locationInView: [self superview]]];

		CGRect sf = [[self superview] bounds];
		CGRect me = [self frame];
	
		if (me.origin.x < sf.origin.x)
			me.origin.x = sf.origin.x;
		if (me.origin.y < sf.origin.y)
			me.origin.y = sf.origin.y;
		if (me.origin.x+me.size.width > sf.origin.x+sf.size.width)
			me.origin.x = sf.origin.x+sf.size.width-me.size.width;
		if (me.origin.y+me.size.height > sf.origin.y+sf.size.height)
			me.origin.y = sf.origin.y+sf.size.height-me.size.height;

		[self setFrame: me];
		
		//NSLog(@"super: %f, %f, %f,%f",sf.origin.x, sf.origin.y, sf.size.width, sf.size.height);
		//NSLog(@"meeee: %f, %f, %f,%f",me.origin.x, me.origin.y, me.size.width, me.size.height);
	}
	
	[[self superview] setNeedsDisplay];
	[self setNeedsDisplay];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
}


- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//	NSLog(@"CANCELLED LOLLLLL!");
	[self touchesEnded:touches withEvent:event];
}





#pragma mark Accessors and properties


- (void)setColor:(UIColor *)newColor
{
	if (newColor && newColor != color) {
		[color release];
		color = [newColor retain];
		
		[self setNeedsDisplay];
	}
}


- (void)setShowArrows:(BOOL)flag
{
	if (flag != showArrows) {
		showArrows = flag;
		[self setNeedsDisplay];
	}
}




@synthesize color;
@synthesize showArrows;


@end
