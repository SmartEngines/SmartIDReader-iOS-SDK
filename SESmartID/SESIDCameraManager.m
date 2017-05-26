/**
 Copyright (c) 2012-2017, Smart Engines Ltd
 All rights reserved.
 
 Redistribution and use in source and binary forms, with or without modification,
 are permitted provided that the following conditions are met:
 
 * Redistributions of source code must retain the above copyright notice,
 this list of conditions and the following disclaimer.
 * Redistributions in binary form must reproduce the above copyright notice,
 this list of conditions and the following disclaimer in the documentation
 and/or other materials provided with the distribution.
 * Neither the name of the Smart Engines Ltd nor the names of its
 contributors may be used to endorse or promote products derived from this
 software without specific prior written permission.
 
 THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND
 ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
 WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
 DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT OWNER OR CONTRIBUTORS BE LIABLE
 FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
 DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
 SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
 CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
 OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
 OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
 */

#import "SESIDCameraManager.h"

@interface SESIDCameraManager()

@property (nonatomic) AVCaptureDevice *captureDevice;
@property (nonatomic) AVCaptureDeviceInput *captureDeviceInput;
@property (nonatomic) AVCaptureVideoDataOutput *captureVideoDataOutput;

@property (nonatomic) AVCaptureSession *captureSession;

@end

@implementation SESIDCameraManager

- (id) init {
  if (self = [super init]) {
    [self initVideoCapture];
  }
  return self;
}

- (void) initVideoCapture {
  // capture device
  self.captureDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];

  // setting continuous auto focus
  if ([self.captureDevice lockForConfiguration:nil]) {
    if ([self.captureDevice isFocusModeSupported:AVCaptureFocusModeContinuousAutoFocus]) {
      self.captureDevice.focusMode = AVCaptureFocusModeContinuousAutoFocus;
    }
    [self.captureDevice unlockForConfiguration];
  }
  
  // capture video data output
  self.captureVideoDataOutput = [[AVCaptureVideoDataOutput alloc] init];
  self.captureVideoDataOutput.videoSettings = @{(NSString*)kCVPixelBufferPixelFormatTypeKey:
                                                  @(kCVPixelFormatType_32BGRA)};
  self.captureVideoDataOutput.alwaysDiscardsLateVideoFrames = YES;
  
  // capture device input
  self.captureDeviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.captureDevice
                                                                  error:nil];
  
  // capture session
  self.captureSession = [[AVCaptureSession alloc] init];
  self.captureSession.sessionPreset = AVCaptureSessionPreset1280x720;
  
  if([self.captureSession canAddInput:self.captureDeviceInput]) {
    [self.captureSession addInput:self.captureDeviceInput];
  }
  
  [self.captureSession addOutput:self.captureVideoDataOutput];
}

- (void) startCaptureSession {
  [self.captureSession startRunning];
}

- (void) stopCaptureSession {
  [self.captureSession stopRunning];
}

- (AVCaptureVideoPreviewLayer *) addPreviewLayerToView:(UIView *)view
                                           orientation:(AVCaptureVideoOrientation)orientation {
  CALayer *viewLayer = view.layer;
  
  AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [AVCaptureVideoPreviewLayer
                                                          layerWithSession:self.captureSession];
  
  captureVideoPreviewLayer.frame = viewLayer.bounds;
  captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
  captureVideoPreviewLayer.position = CGPointMake(CGRectGetMidX(viewLayer.bounds),
                                                  CGRectGetMidY(viewLayer.bounds));
  captureVideoPreviewLayer.connection.videoOrientation = orientation;
  
  [viewLayer insertSublayer:captureVideoPreviewLayer atIndex:0];
  
  return captureVideoPreviewLayer;
}

- (void) setSampleBufferDelegate:(id<AVCaptureVideoDataOutputSampleBufferDelegate>)delegate {
  dispatch_queue_t videoQueue = dispatch_queue_create("biz.smartengines.video-queue", 0);
  [self.captureVideoDataOutput setSampleBufferDelegate:delegate
                                                 queue:videoQueue];
}

- (CGSize) videoSize {
  return CGSizeMake(1280, 720);
}

@end
