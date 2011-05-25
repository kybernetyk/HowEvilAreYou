//
//  WaitViewController.m
//  HowEvil
//
//  Created by jrk on 31/8/10.
//  Copyright 2010 flux forge. All rights reserved.
//

#import "WaitViewController.h"
#import "AnalyzeViewController.h"
#import <QuartzCore/QuartzCore.h>

@implementation WaitViewController
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


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad 
{
    [super viewDidLoad];
	
	[[label layer] setCornerRadius: K_CORNER_RADIUS];
	
	[[imageView layer] setCornerRadius: K_CORNER_RADIUS];
	[[imageView layer] setMasksToBounds: YES];
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
	[imageView setImage: image];
	[[self navigationItem] setTitle: NSLocalizedString(@"Analyzing ...",nil)];
	[[self navigationController] setNavigationBarHidden: YES animated: animated];
	
	[evilView setAlpha:0.25];
}

- (void) viewDidAppear:(BOOL)animated
{

	[UIView beginAnimations:@"theAnimation" context:NULL];
	[UIView setAnimationDuration:2.9];
	[UIView setAnimationDelegate: self];
	[UIView setAnimationDidStopSelector: @selector(showNext:)];
	[evilView setAlpha:1.0];
	[UIView commitAnimations];	

//	[self performSelector: @selector(showNext:) withObject: self afterDelay: 3.0];
	
}

- (void) showNext: (id) sender
{
	AnalyzeViewController *avc = [[AnalyzeViewController alloc] initWithNibName: @"AnalyzeViewController" bundle: nil];
	[avc setImage: image];
	[avc setEvil: evil];
	[[self navigationController] pushViewController: avc animated: YES];
	[avc release];
}

- (void)didReceiveMemoryWarning {
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
	NSLog(@"wait dealloc");
	[imageView setImage: nil];
	[self setImage: nil];
	[self setEvil: nil];
    [super dealloc];
}


@end
