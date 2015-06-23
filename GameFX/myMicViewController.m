//
//  myMicViewController.m
//  GameFX
//
//  Created by alnaumf on 6/22/15.
//  Copyright (c) 2015 Fraksoft. All rights reserved.
//

#import "myMicViewController.h"
#import "SCAudioMeter.h"
#import <LIFXKit/LIFXKit.h>



@interface myMicViewController ()

@property (nonatomic, strong) SCAudioMeter *audioMeter;

@end

@implementation myMicViewController

LFXHSBKColor *savedColor;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
    self.audioMeter = [[SCAudioMeter alloc] initWithSamplePeriod:0.1];
    
    for (LFXLight *aLight in localNetworkContext.allLightsCollection)
    {
        savedColor = aLight.color;
       
        break;
        
    }
    
    
    
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self becomeFirstResponder];
    //[self.audioMeter.microphone startFetchingAudio];
    // Do any additional setup after loading the view.
    // Let's try the audio meter
    
    [self.audioMeter beginAudioMeteringWithCallback:^(double value) {
        double dBValue = 10 * log10(value);
        double sanval = fabs(dBValue);
        double myval = (value+0.1) * 3; if (myval > 1) myval =1;
        NSLog(@"Value: %0.2f   dBValue:%0.2f  sanval:%0.2f  myval:%0.2f", value,dBValue,sanval,myval);
        savedColor = [LFXHSBKColor colorWithHue:savedColor.hue saturation:savedColor.saturation brightness:myval];
        LFXNetworkContext *localNetworkContext = [[LFXClient sharedClient] localNetworkContext];
        [localNetworkContext.allLightsCollection setColor:savedColor];
        
        
    }];

}
- (void)viewWillDisappear:(BOOL)animated {
    [self resignFirstResponder];
    [super viewWillDisappear:animated];
    //[self.audioMeter.microphone stopFetchingAudio];
    [self.audioMeter endAudioMetering];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
