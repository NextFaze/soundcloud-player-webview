//
//  TestAppViewController.h
//  soundcloud-player-webview
//
//  Created by Andrew Williams on 4/02/11.
//  Copyright 2011 2moro mobile. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SCPlayerViewController.h"

@interface TestAppViewController : UIViewController <SCPlayerViewControllerDelegate> {
	UITextField *tfTrack, *tfKey;
	UIButton *buttonLoad;
	UILabel *labelDiagnostics;
	UIScrollView *scrollView;
	UIView *scpView;  // placeholder for positioning
	
	SCPlayerViewController *scpController;
}

@property (nonatomic, retain) IBOutlet UIButton *buttonLoad;
@property (nonatomic, retain) IBOutlet UITextField *tfTrack, *tfKey;
@property (nonatomic, retain) IBOutlet UIScrollView *scrollView;
@property (nonatomic, retain) IBOutlet UILabel *labelDiagnostics;
@property (nonatomic, retain) IBOutlet UIView *scpView;

- (IBAction)buttonPressed:(id)sender;

@end
