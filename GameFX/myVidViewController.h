//
//  myVidViewController.h
//  GameFX
//
//  Created by alnaumf on 7/21/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YTPlayerView.h"

@interface myVidViewController : UIViewController<YTPlayerViewDelegate>


@property(nonatomic, strong) IBOutlet YTPlayerView *playerView;
//@property(nonatomic, strong) IBOutlet UIView *myView;
- (IBAction)playVideo:(id)sender;
- (IBAction)stopVideo:(id)sender;
@end
