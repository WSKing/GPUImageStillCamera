//
//  ViewController.m
//  GPUImageStillCamera
//
//  Created by wsk on 17/6/10.
//  Copyright © 2017年 wsk. All rights reserved.
//

#import "ViewController.h"
#import "GPUImage.h"

@interface ViewController (){
    GPUImageStillCamera *imageCamera;
    GPUImageOutput<GPUImageInput>  *filter;
}

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //相机
    imageCamera=[[GPUImageStillCamera alloc] initWithSessionPreset:AVCaptureSessionPreset1280x720 cameraPosition:AVCaptureDevicePositionBack];
    imageCamera.outputImageOrientation=UIInterfaceOrientationPortrait;
    
    filter=[[GPUImageSepiaFilter alloc] init]; //褐色怀旧滤镜.
    GPUImageView *iv = (GPUImageView *)self.view;

    [imageCamera addTarget:filter];
    [filter addTarget:iv];
    [imageCamera startCameraCapture];//开启摄像头

}


- (IBAction)takeAction:(UIButton *)sender {
    [imageCamera capturePhotoAsImageProcessedUpToFilter:filter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
         [imageCamera stopCameraCapture];
        UIImageWriteToSavedPhotosAlbum(processedImage, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
    }];
}

- (void)image: (UIImage *) image didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo

{
   
    NSString *msg = nil ;
    if(error != NULL){
        msg = @"保存图片失败" ;
    }else{
        msg = @"保存图片成功" ;
    }
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"保存图片结果提示"
                                                    message:msg
                                                   delegate:self
                                          cancelButtonTitle:@"确定"
                                          otherButtonTitles:nil];
    [alert show];
}



@end
