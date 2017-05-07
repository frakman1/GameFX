//
//  myVidViewController.m
//  GameFX
//
//  Created by alnaumf on 7/21/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import "myVidViewController.h"
#import "YTPlayerView.h"
#import <LIFXKit/LIFXKit.h>
#import "UIImageAverageColorAddition.h"
#include <OpenGLES/ES2/gl.h>
//#include "GLESHelper.h"
//#import "EAGLView.h"


OBJC_EXTERN UIImage *_UICreateScreenUIImage(void);
CGImageRef UIGetScreenImage(void);

@interface myVidViewController ()

@end

@implementation myVidViewController

NSTimer *vidtimer;





-(void)myvidTick:(NSTimer *)timer
{
    NSLog(@"myvidTick..");
    //UIImage *capturedScreen ;
    
 
   
    UIImage *capturedScreen = [ self.VidPlayer.moviePlayer thumbnailImageAtTime:(self.VidPlayer.moviePlayer.currentPlaybackTime)*1.0f timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    /*
     [ self.VidPlayer.moviePlayer requestThumbnailImagesAtTimes:@[@8.f] timeOption:MPMovieTimeOptionNearestKeyFrame];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(MPMoviePlayerThumbnailImageRequestDidFinishNotification:) name:MPMoviePlayerThumbnailImageRequestDidFinishNotification object:self.VidPlayer.moviePlayer];
    */
    ///
   /*
    UIView *myview = [self.playerView snapshotViewAfterScreenUpdates: NO];
    UIGraphicsBeginImageContextWithOptions(myview.frame.size , NO , 2.0 );
    
    if ([myview respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [myview drawViewHierarchyInRect:myview.frame afterScreenUpdates:NO];
    } else {
        [myview.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
*/
    
    ///
    
    NSLog(@"Captured image size is %f X %f",capturedScreen.size.width,capturedScreen.size.height);
    UIColor* averageColor = [capturedScreen mergedColor];
    CGFloat red, green, blue;
    CGFloat hue, saturation, brightness, alpha;
    LFXHSBKColor *lifxColor;
    
    [averageColor getRed:&red green:&green blue:&blue alpha:NULL];
    [averageColor getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha];
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    [localNetworkContext.allLightsCollection setPowerState:LFXPowerStateOn];
    lifxColor = [LFXHSBKColor colorWithHue:(hue*360) saturation:saturation brightness:brightness];
    [localNetworkContext.allLightsCollection setColor:lifxColor overDuration:1];
    NSLog(@"%@",[NSString stringWithFormat:@"average color: %.2f %.2f %.2f", red, green, blue]);
    NSLog(@"%@",[NSString stringWithFormat:@"hue: %.2f saturation: %.2f  brightness: %.2f alpha: %.2f", hue, saturation, brightness, alpha]);

}


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
   /*
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    self.playerView.delegate = self;
    [self.playerView loadWithVideoId:@"g9Q4l8HPYzo" playerVars:playerVars];
    [[self.playerView superview] sendSubviewToBack:self.playerView];
   
    
    vidtimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(myvidTick:) userInfo: nil repeats:YES];
*/
    
    NSString *videoIdentifier = @"7hAHSqBcUSY"; // A 11 characters YouTube video identifier
    [[XCDYouTubeClient defaultClient] getVideoWithIdentifier:videoIdentifier completionHandler:^(XCDYouTubeVideo *video, NSError *error) {
        if (video)
        {
            // Do something with the `video` object
            self.VidPlayer = [[XCDYouTubeVideoPlayerViewController alloc] initWithVideoIdentifier:videoIdentifier];
            [self presentMoviePlayerViewControllerAnimated:self.VidPlayer];
           
        }
        else
        {
            // Handle error
        }
    }];
    
    vidtimer = [NSTimer scheduledTimerWithTimeInterval: 0.2 target: self selector:@selector(myvidTick:) userInfo: nil repeats:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)playVideo:(id)sender {
    [self.playerView playVideo];
}

- (IBAction)stopVideo:(id)sender {
    [self.playerView stopVideo];
}



- (void)playerView:(YTPlayerView *)playerView didChangeToState:(YTPlayerState)state {
    switch (state) {
        case kYTPlayerStatePlaying:
            NSLog(@"Started playback");
            break;
        case kYTPlayerStatePaused:
            NSLog(@"Paused playback");
            break;
        default:
            NSLog(@"UNKNOWN");
            break;
    }
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


@end
