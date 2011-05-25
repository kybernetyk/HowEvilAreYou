//
//  ImageEditingViewController.m
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "ImageEditingViewController.h"
#import "XFFaceView.h"
#import "AnalyzeViewController.h"
#import "WaitViewController.h"
#import "HelpViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "NSDataAdditions.h"

@implementation ImageEditingViewController
@synthesize faceView;
@synthesize lastEvil;
@synthesize lastMD5;
/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[faceView layer] setCornerRadius: K_CORNER_RADIUS];
	[[faceView layer] setMasksToBounds: YES];
	[[faceView layer] setBorderColor: [[UIColor blackColor] CGColor]];
	[[faceView layer] setBorderWidth: 1.0];

	[faceView setFaceImage2: [UIImage imageNamed: @"face.png"]];
	[self setTitle: NSLocalizedString(@"Main",nil)];
	[calculateButton setEnabled: NO];
	lastEvil = 0.0;
	
	[[NSNotificationCenter defaultCenter] addObserver: self selector: @selector(handleClearMarkers:) name:@"clearAllMarkers" object: nil];
	queue = [[NSOperationQueue alloc] init];
}

- (void) handleClearMarkers: (NSNotification *) notification
{
	[faceView clearMarkers];
}

- (void) viewWillAppear: (BOOL) animated
{
	NSLog(@".......agaag");
//	[faceView clearMarkers];
	
	[[self navigationController] setNavigationBarHidden: YES animated: animated];
}


/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
	[[NSNotificationCenter defaultCenter] removeObserver: self];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	[self setFaceView: nil];
}


- (void)dealloc 
{
	[queue release];
	queue = nil;
    [super dealloc];
}

#pragma mark -
#pragma mark actions
- (IBAction) help: (id) sender
{
	[[NSNotificationCenter defaultCenter] postNotificationName: @"clearAllMarkers" object: self];
	
	HelpViewController *hvc = [[HelpViewController alloc] initWithNibName: @"HelpViewController" bundle: nil];
	[[self navigationController] pushViewController: hvc animated: YES];
	[hvc release];
}

//TODO: 3DANN ALT HIER SCHAUEN
- (IBAction) choosePicture: (id) sender
{
	UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
	
	if ([UIImagePickerController isCameraDeviceAvailable: UIImagePickerControllerCameraDeviceRear])
	{
		NSLog(@"cam ther!");
		imagePickerController.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;	
	}
	else 
	{
		NSLog(@"lol no cam :[");
		imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;		
	}

	
	imagePickerController.delegate = self;
	[imagePickerController setAllowsEditing: YES];
	[self presentModalViewController: imagePickerController animated: YES];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
	[self dismissModalViewControllerAnimated:YES];
		
	UIImage *img = [info objectForKey: UIImagePickerControllerEditedImage];
	if (!img)
		img = [info objectForKey: UIImagePickerControllerOriginalImage];
		if (!img)
		{
			NSLog(@"wtf no image oO");
			[picker autorelease];
			return;
		}
	
	[faceView setFaceImage: img];
	
	//get saved value for image
	//hab gehoert es wird alles, was im block refernziert wird, vom compiler schoen
	//retained. MAL HOFFEN DASS DAS SO IST LOL xD
	NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:
							^(void)
							{
								NSUserDefaults *defs = [[NSUserDefaults alloc] init]; 
								
								NSData *d = UIImagePNGRepresentation(img);
								[self setLastMD5: [d md5Hash]];
	
								NSNumber *evil = [defs objectForKey: lastMD5];
								if (!evil)
								{	
									[self setLastEvil: 0.0f];
									NSLog(@"no saved value found for %@", lastMD5);
								}
								else
								{
									//	lastEvil = [evil floatValue];
									[self setLastEvil: [evil floatValue]];
									NSLog(@"value %@ for %@", lastMD5, evil);
								}
								[defs release];
							}];
	[queue addOperation: op];
	[picker autorelease];

}

//donald e. knuth certified 
- (int) minValueFromX: (float) x andY: (float) y
{
	if (x < y)
		return 0;
	if (y > x)
		return 1;
	
	return -1;
}

- (int) maxValueFromX: (float) x andY: (float) y
{
	if (x > y)
		return 0;
	if (y < x)
		return 1;
	
	return -1;
}

- (CGPoint *) minXFromPointA: (CGPoint *) a pointB: (CGPoint *) b
{
	if (a->x < b->x)
		return a;
	if (b->x < a->x)
		return b;
	
	return 0; //pray this won't happen <3<3<3<3<<3<3
}

- (CGPoint *) maxXFromPointA: (CGPoint *) a pointB: (CGPoint *) b
{
	if (a->x > b->x)
		return a;
	if (b->x > a->x)
		return b;
	
	return 0;
}


- (IBAction) calculate: (id) sender
{
	if ([[faceView markers] count] == 3)
	{
		CGPoint pa[3] = {{0.0,0.0},{0.0,0.0},{0.0,0.0}};
		int i = 0;
		for (UIView *marker in [faceView markers])
		{
			pa[i++] = [marker center];
		}
		
		float avg_y = (pa[0].y + pa[1].y + pa[2].y)/3;

		//mathe? sort? LOL! brute force xD
		//ich glaub ich brauch das gar net :(
		float most_diff = -1000;
		int most_bottom_index;
		for ( int i = 0; i < 3; i++)
		{	
			if (abs(pa[i].y - avg_y) > most_diff)
			{
				most_diff = abs(pa[i].y - avg_y);
				most_bottom_index = i;
			}
		}
		
		CGPoint left;
		CGPoint right;
		CGPoint bottom = pa[most_bottom_index];
		
		if (most_bottom_index == 0)
		{
			left = *[self minXFromPointA: &pa[1] pointB: &pa[2]];
			right = *[self maxXFromPointA: &pa[1] pointB: &pa[2]];
		}
		if (most_bottom_index == 1)
		{
			left = *[self minXFromPointA: &pa[0] pointB: &pa[2]];
			right = *[self maxXFromPointA: &pa[0] pointB: &pa[2]];
		}
		if (most_bottom_index == 2)
		{
			left = *[self minXFromPointA: &pa[0] pointB: &pa[1]];
			right = *[self maxXFromPointA: &pa[0] pointB: &pa[1]];
		}
		
		
/*
		//LOL SCHEISS DRAUF! WIR FAKEN MIT SPEICHERN LOL
		float long_side = sqrt( fabs ((left.x - right.x) * (left.x - right.x)  + (left.y - right.y) * (left.y - right.y)) );
		 long_side /= 200.0;
		if (long_side > 1.0)
			long_side = 1.0;
		
		int raster_size = 18 * long_side;
		
		for (int y = 0; y < 480; y+= raster_size)
		{
			if (left.y >= y && left.y < y+raster_size)
				left.y = y+raster_size/2;
			if (right.y >= y && right.y < y+raster_size)
				right.y = y+raster_size/2;
			if (bottom.y >= y && bottom.y < y+raster_size)
				bottom.y = y+raster_size/2;
		}
		for (int x = 0; x < 320; x+= raster_size)
		{
			if (left.x >= x && left.x < x+raster_size)
				left.x = x+raster_size/2;
			if (right.x >= x && right.x < x+raster_size)
				right.x = x+raster_size/2;
			if (bottom.x >= x && bottom.x < x+raster_size)
				bottom.x = x+raster_size/2;
		}

		NSLog(@"---------------");
		NSLog(@"long side: %f", long_side);
		NSLog(@"raster size: %i", raster_size);
		NSLog(@"most left: {%f,%f}", left.x, left.y);
		NSLog(@"most right: {%f,%f}", right.x,right.y);
		NSLog(@"most bottom: {%f,%f}", bottom.x,bottom.y);
		NSLog(@"---------------");
*/
		
		float c = sqrt( fabs ((left.x - right.x) * (left.x - right.x)  + (left.y - right.y) * (left.y - right.y)) );
		float a = sqrt( fabs((left.x - bottom.x) * (left.x - bottom.x)  + (left.y - bottom.y) * (left.y - bottom.y)) );
		float b = sqrt( fabs((right.x - bottom.x) * (right.x - bottom.x)  + (right.y - bottom.y) * (right.y - bottom.y)) );
		
		if (a == 0.0 || b == 0.0 || c == 0.0)
		{
			NSLog(@"NAN U TOOL!");
			return;
		}

		float evil = acos( fabs( ((a*a) + (b*b) - (c*c))/(2*a*b) )) * (180.0f/M_PI);
		NSLog(@"realevil: %@", [NSNumber numberWithFloat: evil]);
		
		//habn wir schon nen evil wert fuer dieses bild?
		if ([self lastEvil] > 0.0)
		{	
			if (fabs(evil-[self lastEvil]) > 7.5)
			{	
				[self setLastEvil: evil];
			}
			else
			{	
				evil = [self lastEvil];
			}
		}
		else
		{	
			[self setLastEvil: evil];
		}
		
		NSLog(@"shownevil: %@", [NSNumber numberWithFloat: evil]);
		
		//aktuellen evil wert fuer das bild speich0rn
		//BLOCK OPERATION MULTI THREADING weil ... kein plan wie lang md5 aufm device dauert :[
		NSBlockOperation *op = [NSBlockOperation blockOperationWithBlock:
								^(void)
								{
									NSUserDefaults *defs = [[NSUserDefaults alloc] init];  //[NSUserDefaults standardUserDefaults];
									
									//save old shit
									if ([self lastMD5] && [self lastEvil] > 0.0)
									{
										NSNumber *savevil = [NSNumber numberWithFloat: [self lastEvil]];
										[defs setObject: savevil forKey: [self lastMD5]];
										[defs synchronize];	
										NSLog(@"saving %@ for %@", savevil, [self lastMD5]);
									}
									[defs synchronize];
									[defs release];
								}];
		[queue addOperation: op];
		
		[[NSNotificationCenter defaultCenter] postNotificationName: @"clearAllMarkers" object: self];
		
		WaitViewController *wvc = [[WaitViewController alloc] initWithNibName: @"WaitViewController" bundle: nil];
		[wvc setImage: [faceView faceImage]];
		[wvc setEvil: [NSNumber numberWithFloat: evil]];
		[[self navigationController] pushViewController: wvc animated: YES];
		[wvc release];
	}
}

- (void) faceView: (XFFaceView *) aFaceView markersDidChange: (NSArray *) markers
{
	//[calculateButton setEnabled: ([markers count] == 3)];

	[calculateButton setEnabled: NO];
	if ([markers count] == 3)
	{
		[calculateButton setEnabled: YES];
	}
}

@end
