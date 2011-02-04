//
//  TestAppViewController.m
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "TestAppViewController.h"

@implementation TestAppViewController

@synthesize tfTrack, tfKey, buttonLoad, scrollView, labelDiagnostics, scpView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	// instantiate SCPlayerWebViewController and add its view as a subview (over the top of the scpView placeholder)
	scpController = [[SCPlayerViewController alloc] initWithWidth:scpView.frame.size.width];
	UIView *v = scpController.view;
	v.frame = scpView.frame;
	[self.view addSubview:v];
}

/*
// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations.
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
*/

- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}

- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
	self.tfTrack = self.tfKey = nil;
	self.buttonLoad = nil;
	self.scpView = nil;
	self.labelDiagnostics = nil;
	self.scrollView = nil;
	
	[scpController release];
	scpController = nil;
}

- (void)dealloc {
	[tfTrack release];
	[tfKey release];
	[buttonLoad release];
	[scpView release];
	[labelDiagnostics release];
	[scrollView release];
	[scpController release];
	
    [super dealloc];
}

#pragma mark -

- (IBAction)buttonPressed:(id)sender {
	// load track
	NSLog(@"load pressed: track: %@", tfTrack.text);

	[tfTrack resignFirstResponder];
	[scpController setClientKey:tfKey.text];
	[scpController loadTrack:tfTrack.text];
}

@end
