//
//  AnalyzeViewController.m
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "AnalyzeViewController.h"
#import "UIImage+crop+resize.h"
#import <QuartzCore/QuartzCore.h>

@implementation AnalyzeViewController
@synthesize image;
@synthesize evil;

/*
 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/


- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	NSMutableArray *temp = [NSMutableArray arrayWithCapacity: 32];
	
	NSDictionary *d = nil;
	
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Muammar\nal-Gaddafi", @"name",
		 [NSNumber numberWithFloat: 46.0f-2.0f], @"evil",
		 @"gaddafi.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Muammar_al-Gaddafi",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Adolf\nHitler", @"name",
		 [NSNumber numberWithFloat: 48.0f-2.0f], @"evil",
		 @"adolf_hitler.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Adolf_Hitler",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Saddam\nHussein", @"name",
		 [NSNumber numberWithFloat: 50.0f-2.0f], @"evil",
		 @"saddam_hussein.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Saddam_Hussein",nil),@"wikiurl",
		 nil];
	[temp addObject: d];

	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Ted\nBundy", @"name",
		 [NSNumber numberWithFloat: 51.0f-2.0f], @"evil",
		 @"ted_bundy.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Ted_Bundy",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Osama\nBin Laden", @"name",
		 [NSNumber numberWithFloat: 52.0f-2.0f], @"evil",
		 @"osama_bin_laden.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Osama_bin_Laden",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Hans\nReiser", @"name",
		 [NSNumber numberWithFloat: 52.40f-2.0f], @"evil",
		 @"hans_reiser.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Hans_Reiser",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Charles\nManson", @"name",
		 [NSNumber numberWithFloat: 54.0f-2.0f], @"evil",
		 @"charles_manson.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Charles_Manson",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	

	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Josef\nStalin", @"name",
		 [NSNumber numberWithFloat: 55.0f-2.0f], @"evil",
		 @"josef_stalin.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Joseph_Stalin",nil),@"wikiurl",
		 nil];
	[temp addObject: d];

	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Kim\nJong Il", @"name",
		 [NSNumber numberWithFloat: 56.0f-2.0f], @"evil",
		 @"kim_jong_il.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Kim_Jong-il",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Shoko\nAsahara", @"name",
		 [NSNumber numberWithFloat: 58.0f-2.0f], @"evil",
		 @"shoko_asahara.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Shoko_Asahara",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
		
	d = [NSDictionary dictionaryWithObjectsAndKeys:
		 @"Robert\nMugabe", @"name",
		 [NSNumber numberWithFloat: 60.0f-2.0f], @"evil",
		 @"robert_mugabe.png",@"image",
		 NSLocalizedString(@"http://en.wikipedia.org/wiki/Robert_Mugabe",nil),@"wikiurl",
		 nil];
	[temp addObject: d];
	
	villains = [[NSArray alloc] initWithArray: temp];
	
	[[textView layer] setCornerRadius: K_CORNER_RADIUS];
	[[youAreTextView layer] setCornerRadius: K_CORNER_RADIUS];
	[[label layer] setCornerRadius: K_CORNER_RADIUS];

	[[imageView layer] setCornerRadius: K_CORNER_RADIUS];
	[[imageView layer] setMasksToBounds: YES];

//	imageView.layer.borderColor = [UIColor blackColor].CGColor;
//	imageView.layer.borderWidth = 2.0;
	
	[[villainImageView layer] setCornerRadius: K_CORNER_RADIUS];
	[[villainImageView layer] setMasksToBounds: YES];
	
//	villainImageView.layer.borderColor = [UIColor blackColor].CGColor;
//	villainImageView.layer.borderWidth = 2.0;

}

- (void) visitWikipedia: (id) sender
{
	[[UIApplication sharedApplication] openURL:[NSURL URLWithString: wikiurl]];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void) viewWillAppear:(BOOL)animated
{
	[self setTitle: NSLocalizedString(@"Results ...",nil)];
	[imageView setImage: image];
	[textView setText: [NSString stringWithFormat: NSLocalizedString (@"Your rating is: %.2f.", nil), [evil floatValue]]];

	
	
	
	//NSMutableDictionary *blubb = [NSMutableDictionary dictionaryWithCapacity: 32];
	
	
	float smallest_diff = 100000000000000.0f;
	NSDictionary *smallest_p = nil;
	for (NSDictionary *dict in villains)
	{
		float diff = abs ([[dict objectForKey: @"evil"] floatValue] - round([evil floatValue]));
		if (diff < smallest_diff)
		{
			smallest_diff = diff;
			smallest_p = dict;
		}
	}
	

	NSString *name = [smallest_p objectForKey: @"name"];
	NSString *imageName = [smallest_p objectForKey: @"image"];
	wikiurl = [[NSString alloc] initWithString: [smallest_p objectForKey: @"wikiurl"]];
	
	//UIImage *img = [[UIImage imageNamed: imageName] imageByScalingAndCroppingForSize: [villainImageView frame].size];
	
	UIImage *img = [UIImage imageNamed: imageName];
	
	
	[youAreTextView setText: name];
	[villainImageView setImage: img];

	//kick out the wait controller from our stack. user shouldn't go back to the wait controller 
	NSArray *a = [[self navigationController] viewControllers];
	NSMutableArray *b = [NSMutableArray arrayWithCapacity: 4];
	
	id rem = [a objectAtIndex: [a count]-2];
	for (id c in a)
	{
		if (c != rem)
			[b addObject: c];
	}

	[[self navigationController] setViewControllers: b animated: NO];
	[[self navigationController] setNavigationBarHidden: NO animated: animated];

}

- (void) viewDidAppear:(BOOL)animated
{

}

- (void)didReceiveMemoryWarning 
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload 
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc 
{
	NSLog(@"analyze dealloc: %@", image);
	[self setEvil: nil];
	[imageView setImage: nil];
	[self setImage: nil];
	[wikiurl release], wikiurl = nil;
    [super dealloc];
}


@end
