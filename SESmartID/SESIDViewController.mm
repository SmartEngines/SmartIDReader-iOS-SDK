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

#import "SESIDViewController.h"

#import "SESIDCameraManager.h"
#import "SESIDRecognitionCore.h"

#import "SESIDRoiOverlayView.h"
#import "SESIDQuadrangleView.h"

// SmartIDResultReporter
struct SmartIDResultReporter : public se::smartid::ResultReporterInterface {
  __weak SESIDViewController *smartIdViewController; // to pass data back to view controller
  
  int processedFramesCount;
  
  virtual void SnapshotRejected() override;
  virtual void DocumentMatched(
    const std::vector<se::smartid::MatchResult>& match_results) override;
  virtual void DocumentSegmented(
    const std::vector<se::smartid::SegmentationResult>& segmentation_results) override;
  virtual void SnapshotProcessed(const se::smartid::RecognitionResult& recog_result) override;
  virtual void SessionEnded() override;
  virtual ~SmartIDResultReporter();
};

// SESIDViewController
@interface SESIDViewController () <AVCaptureVideoDataOutputSampleBufferDelegate> {
  SmartIDResultReporter resultReporter_;
}

@property (nonatomic) SESIDCameraManager *cameraManager;
@property (nonatomic) SESIDRecognitionCore *recognitionCore;

@property (nonatomic) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic) SESIDRoiOverlayView *roiOverlayView;
@property (nonatomic) SESIDQuadrangleView *quadrangleView;
@property (nonatomic) UIImageView *logoImageView;

@property (nonatomic, assign) BOOL guiInitialized;

@end

@implementation SESIDViewController

#pragma mark - Initialization and life cycle
- (id) init {
  if (self = [super init]) {
    [self initCameraManager];
    [self initRecognitionCore];
    [self initRoiOverlayView];
    [self initQuadrangleView];
    [self initLogoImageView];
    [self initCancelButton];
    
    self.view.backgroundColor = [UIColor blackColor];
    
    self.displayDocumentQuadrangle = NO;
    self.displayZonesQuadrangles = NO;
  }
  
  return self;
}

- (void) initCameraManager {
  self.cameraManager = [[SESIDCameraManager alloc] init];
  
  __weak typeof(self) weakSelf = self;
  [self.cameraManager setSampleBufferDelegate:weakSelf];
}

- (void) initRecognitionCore {
  self.recognitionCore = [[SESIDRecognitionCore alloc] init];
  
  __weak typeof(self) weakSelf = self;
  resultReporter_.smartIdViewController = weakSelf;
}

- (void) initRoiOverlayView {
  self.roiOverlayView = [[SESIDRoiOverlayView alloc] init];
  [self.view addSubview:self.roiOverlayView];
}

- (void) initQuadrangleView {
  self.quadrangleView = [[SESIDQuadrangleView alloc] init];
  [self.view addSubview:self.quadrangleView];
}

- (void) initLogoImageView {
  UIImage *logoImage = [UIImage imageNamed:@""];
  
  CGRect frame = CGRectMake(10, 10, 60, 60);
  self.logoImageView = [[UIImageView alloc] initWithFrame:frame];
  self.logoImageView.image = logoImage;
}

- (void) initCancelButton {
  self.cancelButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.cancelButton addTarget:self action:@selector(cancelButtonPressed)
              forControlEvents:UIControlEventTouchUpInside];
  [self.cancelButton setTitle:@"X" forState:UIControlStateNormal];
  [self.cancelButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
  [self.cancelButton.titleLabel setFont:[UIFont boldSystemFontOfSize:30.0f]];
  [self.view addSubview:self.cancelButton];
  [self.view bringSubviewToFront:self.cancelButton];
}

- (void) viewDidLayoutSubviews {
  // calculating roi overlay view to aspect fill camera view
  
  CGSize videoSize = self.cameraManager.videoSize;
  CGRect bounds = self.view.bounds;
  CGRect frame = bounds;
  
  if (!UIInterfaceOrientationIsLandscape([UIApplication sharedApplication].statusBarOrientation)) {
    videoSize = CGSizeMake(videoSize.height, videoSize.width);
    
    const CGFloat height = frame.size.width * (videoSize.height / videoSize.width);
    frame.size.height = height;
    frame.origin.y -= (height - frame.size.height) / 2;
  } else {
    const CGFloat width = frame.size.height * (videoSize.width / videoSize.height);
    frame.size.width = width;
    frame.origin.x -= (width - frame.size.width) / 2;
  }
  
  self.roiOverlayView.frame = frame;
  self.previewLayer.frame = self.roiOverlayView.bounds;
  self.quadrangleView.frame = self.roiOverlayView.frame;
  
  // calculating drawing scale for quadrangle view
  self.quadrangleView.drawingScale = CGSizeMake(
            self.quadrangleView.bounds.size.width / videoSize.width,
            self.quadrangleView.bounds.size.height / videoSize.height);
  
  // setting cancel button location
  const CGFloat cancelButtonSize = 80;
  self.cancelButton.frame = CGRectMake(bounds.size.width - cancelButtonSize - 10,
                                       bounds.size.height - cancelButtonSize - 10,
                                       cancelButtonSize, cancelButtonSize);
}

- (void) viewWillAppear:(BOOL)animated {
  [super viewWillAppear:animated];
  
  self.roiOverlayView.backgroundColor = [UIColor blackColor];
  
  self.roiOverlayView.glowColorLevel = 0.0f;
  
  [self.roiOverlayView setNeedsDisplay];
}

- (void) viewDidAppear:(BOOL)animated {
  [super viewDidAppear:animated];
  
  if (!self.guiInitialized) {
    self.previewLayer = [self.cameraManager addPreviewLayerToView:self.roiOverlayView
                         orientation:[self currentVideoOrientation]];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(orientationChanged)
                                                 name:UIDeviceOrientationDidChangeNotification
                                               object:nil];
    [self orientationChanged];
    
    self.guiInitialized = YES;
  }
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.cameraManager startCaptureSession];
    self.roiOverlayView.backgroundColor = [UIColor clearColor];
  });
  
  [self.recognitionCore initializeSessionWithReporter:&resultReporter_];
}

- (void) viewWillDisappear:(BOOL)animated {
  self.recognitionCore.canProcessFrames = NO;
}

- (void) viewDidDisappear:(BOOL)animated {
  dispatch_async(dispatch_get_main_queue(), ^{
    [self.cameraManager stopCaptureSession];
  });
}

#pragma mark - User interaction
- (void) cancelButtonPressed {
  self.recognitionCore.canProcessFrames = NO;
  
  [self.delegate smartIdViewControllerDidCancel];
}

#pragma mark - Interface properties and other methods
- (se::smartid::SessionSettings &) sessionSettings {
  return self.recognitionCore.sessionSettings;
}

- (void) setSessionTimeout:(float)sessionTimeout {
  NSString *str = [[NSNumber numberWithFloat:sessionTimeout] stringValue];
  self.recognitionCore.sessionSettings.SetOption("common.sessionTimeout", str.UTF8String);
}

- (float) sessionTimeout {
  std::string str = self.recognitionCore.sessionSettings.GetOption("common.sessionTimeout");
  float timeout = [[NSString stringWithUTF8String:str.c_str()] floatValue];
  return timeout;
}

- (void) addEnabledDocumentTypesMask:(const std::string &)documentTypesMask {
  self.recognitionCore.sessionSettings.AddEnabledDocumentTypes(documentTypesMask);
}

- (void) removeEnabledDocumentTypesMask:(const std::string &)documentTypesMask {
  self.recognitionCore.sessionSettings.RemoveEnabledDocumentTypes(documentTypesMask);
}

- (void) setEnabledDocumentTypes:(const std::vector<std::string> &)documentTypes {
  self.recognitionCore.sessionSettings.SetEnabledDocumentTypes(documentTypes);
}

- (const std::vector<std::string> &) enabledDocumentTypes {
  return self.recognitionCore.sessionSettings.GetEnabledDocumentTypes();
}

- (const std::vector<std::vector<std::string> > &) supportedDocumentTypes {
  return self.recognitionCore.sessionSettings.GetSupportedDocumentTypes();
}

#pragma mark - Camera and Core interaction
- (void) captureOutput:(AVCaptureOutput *)captureOutput
 didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
        fromConnection:(AVCaptureConnection *)connection {
//  NSLog(@"%s %d", __func__, [self.recognitionCore canProcessFrames]);
  
  if ([self.recognitionCore canProcessFrames]) {
    se::smartid::ImageOrientation orientation = [self currentImageOrientation];
    
    const se::smartid::RecognitionResult result = [self.recognitionCore
                                                   processSampleBuffer:sampleBuffer
                                                           orientation:orientation];
    
    // processing is performed on video queue so forcing main queue
    if ([NSThread isMainThread]) {
      [self.delegate smartIdViewControllerDidRecognizeResult:result];
    } else {
      dispatch_sync(dispatch_get_main_queue(), ^{
        [self.delegate smartIdViewControllerDidRecognizeResult:result];
      });
    }
  }
}

+ (UIImage *) uiImageFromSmartIdImage:(const se::smartid::Image &)image {
  return [SESIDRecognitionCore uiImageFromSmartIdImage:image];
}

- (se::smartid::ImageOrientation) currentImageOrientation {
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  if (orientation == UIInterfaceOrientationPortrait) {
    return se::smartid::Portrait;
  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    return se::smartid::Landscape;
  } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
    return se::smartid::InvertedLandscape;
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    return se::smartid::InvertedPortrait;
  } else {
    return se::smartid::Portrait;
  }
}

- (AVCaptureVideoOrientation) currentVideoOrientation {
  UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
  AVCaptureVideoOrientation videoOrientation = AVCaptureVideoOrientationPortrait;
  if (orientation == UIInterfaceOrientationPortrait) {
    videoOrientation = AVCaptureVideoOrientationPortrait;
  } else if (orientation == UIInterfaceOrientationLandscapeRight) {
    videoOrientation = AVCaptureVideoOrientationLandscapeRight;
  } else if (orientation == UIInterfaceOrientationLandscapeLeft) {
    videoOrientation = AVCaptureVideoOrientationLandscapeLeft;
  } else if (orientation == UIInterfaceOrientationPortraitUpsideDown) {
    videoOrientation = AVCaptureVideoOrientationPortraitUpsideDown;
  }
  return videoOrientation;
}

- (void) orientationChanged {
  AVCaptureVideoOrientation videoOrientation = [self currentVideoOrientation];
  self.previewLayer.connection.videoOrientation = videoOrientation;
  [self viewDidLayoutSubviews];
}

#pragma mark SmartIDResultReporter implementation
void SmartIDResultReporter::SnapshotRejected() {
//  NSLog(@"%s", __FUNCTION__);
}

void SmartIDResultReporter::DocumentMatched(
  const std::vector<se::smartid::MatchResult>& match_results) {
//  NSLog(@"%s", __FUNCTION__);
  
  if (smartIdViewController.displayDocumentQuadrangle) {
    for (size_t i = 0; i < match_results.size(); ++i) {
      dispatch_sync(dispatch_get_main_queue(), ^{
        const se::smartid::MatchResult &result = match_results[i];
        [smartIdViewController.quadrangleView animateQuadrangle:result.GetQuadrangle()
                                                          color:UIColor.greenColor
                                                          width:2.5f
                                                          alpha:0.9f];
      });
    }
  }
}

void SmartIDResultReporter::DocumentSegmented(
  const std::vector<se::smartid::SegmentationResult>& segmentation_results) {
  //  NSLog(@"%s", __FUNCTION__);
  
  if (smartIdViewController.displayDocumentQuadrangle) {
    for (size_t i = 0; i < segmentation_results.size(); ++i) {
      const se::smartid::SegmentationResult &result = segmentation_results[i];
      for (const auto &zone_quad : result.GetZoneQuadrangles()) {
        dispatch_sync(dispatch_get_main_queue(), ^{
          [smartIdViewController.quadrangleView animateQuadrangle:zone_quad.second
                                                            color:UIColor.greenColor
                                                            width:1.3f
                                                            alpha:0.9f];
        });
      }
    }
  }
}

void SmartIDResultReporter::SnapshotProcessed(const se::smartid::RecognitionResult &result) {
//  NSLog(@"%s %d", __FUNCTION__, processedFramesCount);
  ++processedFramesCount;
}

void SmartIDResultReporter::SessionEnded() {
//  NSLog(@"%s", __FUNCTION__);
}

SmartIDResultReporter::~SmartIDResultReporter() {
  smartIdViewController = nil;
}

#pragma mark - Style settings
- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (BOOL) prefersStatusBarHidden {
  return NO;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

- (BOOL) shouldAutorotate {
  return YES;
}

@end
