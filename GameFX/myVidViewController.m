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


@interface myVidViewController ()

@end

@implementation myVidViewController

NSTimer *vidtimer;




-(void)myvidTick:(NSTimer *)timer
{
    NSLog(@"myvidTick..");
    //UIImage *capturedScreen ;
    
    
    // create graphics context with screen size
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    UIGraphicsBeginImageContext(screenRect.size);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    [[UIColor blackColor] set];
    CGContextFillRect(ctx, screenRect);
    
    // grab reference to our window
    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    
    // transfer content into our context
    [window.layer renderInContext:ctx];
    UIImage *capturedScreen     = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    /*
    //store the original framesize to put it back after the snapshot
    CGRect originalFrame = self.playerView.webView.frame;
    
    //get the width and height of webpage using js (you might need to use another call, this doesn't work always)
    int webViewHeight = [[self.playerView.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollHeight;"] integerValue];
    int webViewWidth = [[self.playerView.webView stringByEvaluatingJavaScriptFromString:@"document.body.scrollWidth;"] integerValue];
    
    //set the webview's frames to match the size of the page
    [self.playerView.webView setFrame:CGRectMake(0, 0, webViewWidth, webViewHeight)];
    
    //make the snapshot
    UIGraphicsBeginImageContextWithOptions(self.playerView.webView.frame.size, false, 0.0);
    [self.playerView.webView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    //set the webview's frame to the original size
    [self.playerView.webView setFrame:originalFrame];
    */

   /*
    UIGraphicsBeginImageContextWithOptions(self.playerView.bounds.size, YES, [[UIScreen mainScreen] scale]);
    CGRect rect = self.playerView.bounds;
    //CGRect rect2 = CGRectMake(rect.origin.x, rect.origin.y+200, rect.size.width, rect.size.height/2);
    [self.playerView drawViewHierarchyInRect:rect afterScreenUpdates:NO];
    UIImage* capturedScreen =UIGraphicsGetImageFromCurrentImageContext();
    */
    /*
    UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
    CGRect rect = [keyWindow bounds];
    UIGraphicsBeginImageContextWithOptions(rect.size,YES,0.0f);
    CGContextRef context = UIGraphicsGetCurrentContext();
    [keyWindow.layer renderInContext:context];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    /*
    UIGraphicsBeginImageContext(CGSizeMake(self.playerView.frame.size.width, self.playerView.frame.size.height));
    [self.playerView drawViewHierarchyInRect:CGRectMake(0, 0, self.playerView.frame.size.width, self.playerView.frame.size.height) afterScreenUpdates:YES];
    UIImage *capturedScreen = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
*/
    
    
    
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
    
    NSDictionary *playerVars = @{
                                 @"playsinline" : @1,
                                 };
    self.playerView.delegate = self;
    [self.playerView loadWithVideoId:@"0M3zdMXkkdw" playerVars:playerVars];
    [[self.playerView superview] sendSubviewToBack:self.playerView];
   
    
    vidtimer = [NSTimer scheduledTimerWithTimeInterval: 0.5 target: self selector:@selector(myvidTick:) userInfo: nil repeats:YES];

    
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
