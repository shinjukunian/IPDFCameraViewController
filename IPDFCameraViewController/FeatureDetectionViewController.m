//
//  ViewController.m
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import "FeatureDetectionViewController.h"
#import "IPDFCameraView.h"
@import CoreMotion;

@interface FeatureDetectionViewController ()<IPDFCameraViewDelegate>

@property (weak, nonatomic) IBOutlet IPDFCameraView *cameraView;
@property (weak, nonatomic) IBOutlet UIImageView *focusIndicator;
@property (weak,nonatomic) IBOutlet UIButton *captureButton;

@property (copy) QRCompletionBlock qrBlock;
@property CMMotionManager *motionManager;
@end

@implementation FeatureDetectionViewController

#pragma mark -
#pragma mark View Lifecycle


-(instancetype)initQRDetectionControllerWithCompletion:(QRCompletionBlock)completion{
    self=[super initWithNibName:@"FeatureDetectionCameraViewController" bundle:[NSBundle bundleForClass:[FeatureDetectionViewController class]]];
    if (self) {
        self.qrBlock=completion;
        if (!self.cameraView) {
            self.cameraView=[IPDFCameraView new];
        }
        self.cameraView.detectionType=QRCodeFeatureDetection;
    }
    
    return self;
}





- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self.cameraView setupCameraView];
    [self.cameraView setEnableBorderDetection:YES];
   // [self updateTitleLabel];
}

- (void)viewDidAppear:(BOOL)animated
{
    if (self.motionManager.deviceMotionAvailable) {
        __weak FeatureDetectionViewController *weakself=self;
        NSOperationQueue *queue=[[NSOperationQueue alloc]init];
        self.motionManager.deviceMotionUpdateInterval=0.2;
        
        __block UIDeviceOrientation orientation=UIDeviceOrientationPortrait;
        [self.cameraView setOrientation:UIDeviceOrientationPortrait];
        
        [self.motionManager startDeviceMotionUpdatesToQueue:queue withHandler:^(CMDeviceMotion *motion, NSError *error){
            
            UIDeviceOrientation newOrientation=orientation;
            if (motion.gravity.z>-0.5) {
                if (motion.gravity.x>0.75 && fabs(motion.gravity.y)<0.3) {
                    newOrientation=UIDeviceOrientationLandscapeLeft;
                }
                if (motion.gravity.x<-0.75 && fabs(motion.gravity.y)<0.3) {
                    newOrientation=UIDeviceOrientationLandscapeRight;
                }
                if (fabs(motion.gravity.x)<0.3 && motion.gravity.y<-0.75) {
                    newOrientation=UIDeviceOrientationPortrait;
                }
            }
            
            if (newOrientation!=orientation) {
                orientation=newOrientation;
                [weakself.cameraView setOrientation:orientation];
            }
            
            
        }];
    }

    
    
    [self.cameraView start];
}

-(void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:animated];
    [self.motionManager stopDeviceMotionUpdates];
    [self.cameraView stop];
    
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}


-(void)cameraView:(IPDFCameraView *)view didDetectFeatures:(id)f ofType:(featureDetectionType)type{
    switch (type) {
        case QRCodeFeatureDetection:{
            NSArray *features=f;
            for (NSString *message in features) {
                 BOOL close=self.qrBlock([message dataUsingEncoding:NSUTF8StringEncoding]);
                if (close) {
                    [self dismissViewControllerAnimated:YES completion:nil];
                }
            }
            break;
        }
        default:
            break;
    }
}

#pragma mark -
#pragma mark CameraVC Actions

- (IBAction)focusGesture:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateRecognized)
    {
        CGPoint location = [sender locationInView:self.cameraView];
        
        [self focusIndicatorAnimateToPoint:location];
        
        [self.cameraView focusAtPoint:location completionHandler:^
         {
             [self focusIndicatorAnimateToPoint:location];
         }];
    }
}

- (void)focusIndicatorAnimateToPoint:(CGPoint)targetPoint
{
    [self.focusIndicator setCenter:targetPoint];
    self.focusIndicator.alpha = 0.0;
    self.focusIndicator.hidden = NO;
    
    [UIView animateWithDuration:0.4 animations:^
    {
         self.focusIndicator.alpha = 1.0;
    }
    completion:^(BOOL finished)
    {
         [UIView animateWithDuration:0.4 animations:^
         {
             self.focusIndicator.alpha = 0.0;
         }];
     }];
}

- (IBAction)borderDetectToggle:(id)sender
{
    BOOL enable = !self.cameraView.isBorderDetectionEnabled;
    [self changeButton:sender targetTitle:(enable) ? @"CROP On" : @"CROP Off" toStateEnabled:enable];
    self.cameraView.enableBorderDetection = enable;
    //[self updateTitleLabel];
}

- (IBAction)filterToggle:(id)sender
{
    [self.cameraView setCameraViewType:(self.cameraView.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? IPDFCameraViewTypeNormal : IPDFCameraViewTypeBlackAndWhite];
    //[self updateTitleLabel];
}

- (IBAction)torchToggle:(id)sender
{
    BOOL enable = !self.cameraView.isTorchEnabled;
    [self changeButton:sender targetTitle:(enable) ? @"FLASH On" : @"FLASH Off" toStateEnabled:enable];
    self.cameraView.enableTorch = enable;
}

//- (void)updateTitleLabel
//{
//    CATransition *animation = [CATransition animation];
//    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
//    animation.type = kCATransitionPush;
//    animation.subtype = kCATransitionFromBottom;
//    animation.duration = 0.35;
//    [self.titleLabel.layer addAnimation:animation forKey:@"kCATransitionFade"];
//    
//    NSString *filterMode = (self.cameraView.cameraViewType == IPDFCameraViewTypeBlackAndWhite) ? @"TEXT FILTER" : @"COLOR FILTER";
//    self.titleLabel.text = [filterMode stringByAppendingFormat:@" | %@",(self.cameraView.isBorderDetectionEnabled)?@"AUTOCROP On":@"AUTOCROP Off"];
//}

- (void)changeButton:(UIButton *)button targetTitle:(NSString *)title toStateEnabled:(BOOL)enabled
{
    [button setTitle:title forState:UIControlStateNormal];
    [button setTitleColor:(enabled) ? [UIColor colorWithRed:1 green:0.81 blue:0 alpha:1] : [UIColor whiteColor] forState:UIControlStateNormal];
}


#pragma mark -
#pragma mark CameraVC Capture Image

- (IBAction)captureButton:(id)sender
{
    __weak typeof(self) weakSelf = self;
    
    [self.cameraView captureImageWithCompletionHander:^(NSString *imageFilePath)
    {
        UIImageView *captureImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageFilePath]];
        captureImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
        captureImageView.frame = CGRectOffset(weakSelf.view.bounds, 0, -weakSelf.view.bounds.size.height);
        captureImageView.alpha = 1.0;
        captureImageView.contentMode = UIViewContentModeScaleAspectFit;
        captureImageView.userInteractionEnabled = YES;
        [weakSelf.view addSubview:captureImageView];
        
        UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissPreview:)];
        [captureImageView addGestureRecognizer:dismissTap];
        
        [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^
        {
            captureImageView.frame = weakSelf.view.bounds;
        } completion:nil];
    }];
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap
{
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
    {
        dismissTap.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
    }
    completion:^(BOOL finished)
    {
        [dismissTap.view removeFromSuperview];
    }];
}

@end
