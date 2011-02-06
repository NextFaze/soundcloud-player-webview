//
//  TestAppViewController.m
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import "TestAppViewController.h"

#define DEFAULT_KEY @"ClientKey"
#define DEFAULT_TRACK @"Track"

@implementation TestAppViewController

@synthesize tfTrack, tfKey, buttonLoad, scrollView, labelDiagnostics, scpView;

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
    [super viewDidLoad];
	
	NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
	tfKey.text = [defaults valueForKey:DEFAULT_KEY];
	tfTrack.text = [defaults valueForKey:DEFAULT_TRACK];
	
	// instantiate SCPlayerWebViewController and add its view as a subview (over the top of the scpView placeholder)
	scpController = [[SCPlayerViewController alloc] initWithFrame:scpView.frame];
	scpController.delegate = self;
	[self.view addSubview:scpController.view];
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

- (void)appendLog:(NSString *)log {
	labelDiagnostics.text = [NSString stringWithFormat:@"%@\n%@", labelDiagnostics.text, log];
	
	CGSize maxSize = CGSizeMake(260, 9999);
    CGSize size = [labelDiagnostics.text sizeWithFont:labelDiagnostics.font 
										 constrainedToSize:maxSize 
										 lineBreakMode:labelDiagnostics.lineBreakMode];
	CGRect frame = labelDiagnostics.frame;
	frame.size = size;
	labelDiagnostics.frame = frame;
	
	[scrollView setContentSize:size];
	
	CGPoint bottomOffset = CGPointMake(0, size.height - scrollView.frame.size.height);
	if (bottomOffset.y > 0) [scrollView setContentOffset:bottomOffset animated:YES];	
}

- (IBAction)buttonPressed:(id)sender {
	if(sender == buttonLoad) {
		// load track
		NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
		[self appendLog:[NSString stringWithFormat:@"loading track %@", tfTrack.text]];
		
		[defaults setValue:tfKey.text forKey:DEFAULT_KEY];
		[defaults setValue:tfTrack.text forKey:DEFAULT_TRACK];
		
		[tfTrack resignFirstResponder];
		[scpController setClientKey:tfKey.text];
		[scpController loadTrack:tfTrack.text];
	}
	else {
		// clear diagnostics log
		labelDiagnostics.text = @"";
	}
}

#pragma mark - SCPlayerViewControllerDelegate

- (void)scplayerViewController:(SCPlayerViewController *)scpvc didFailLoadWithError:(NSError *)error {
	SCPLAYER_LOG(@"error: %@", error);
	[self appendLog:[NSString stringWithFormat:@"error: %@", error]];
}

- (void)scplayerViewControllerDidFinishLoad:(SCPlayerViewController *)scpvc {
	[self appendLog:@"finished loading"];
}

@end
