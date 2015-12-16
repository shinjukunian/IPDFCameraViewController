//
//  IPDFCameraViewController.h
//  InstaPDF
//
//  Created by Maximilian Mackh on 06/01/15.
//  Copyright (c) 2015 mackh ag. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FeatureDetectionViewController.h"

typedef NS_ENUM(NSInteger,IPDFCameraViewType)
{
    IPDFCameraViewTypeBlackAndWhite,
    IPDFCameraViewTypeNormal
};

typedef NS_ENUM(NSInteger,featureDetectionType)
{
    RectangleFeatureDetection,
    QRCodeFeatureDetection,
};


@protocol IPDFCameraViewDelegate;


@interface IPDFCameraView : UIView

- (void)setupCameraView;

- (void)start;
- (void)stop;

@property (nonatomic,assign,getter=isBorderDetectionEnabled) BOOL enableBorderDetection;
@property (nonatomic,assign,getter=isTorchEnabled) BOOL enableTorch;
@property (nonatomic,assign) IPDFCameraViewType cameraViewType;
@property (nonatomic,assign) featureDetectionType detectionType;
@property (weak) IBOutlet id<IPDFCameraViewDelegate> cameraViewDelegate;
@property (nonatomic,assign) UIDeviceOrientation orientation;

- (void)focusAtPoint:(CGPoint)point completionHandler:(void(^)())completionHandler;
- (void)captureImageWithCompletionHander:(void(^)(NSString *imageFilePath))completionHandler;

@end


@protocol IPDFCameraViewDelegate <NSObject>

-(void)cameraView:(IPDFCameraView*)view didDetectFeatures:(id)features ofType:(featureDetectionType)type;


@end