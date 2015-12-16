//
//  ViewController.h
//  IPDFCameraViewController
//
//  Created by Maximilian Mackh on 11/01/15.
//  Copyright (c) 2015 Maximilian Mackh. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^rectangleCompletionBlock)(UIImage* image);
typedef BOOL(^QRCompletionBlock)(NSData* QRData);

@interface FeatureDetectionViewController : UIViewController


-(instancetype)initRectangleDetectionControllerWithCOmpletion:(rectangleCompletionBlock)completion;
-(instancetype)initQRDetectionControllerWithCompletion:(QRCompletionBlock)completion; 

@end

