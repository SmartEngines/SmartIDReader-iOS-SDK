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

#import "SESIDSampleViewController.h"

#import "SESIDViewController.h"

@interface SESIDSampleViewController () <SESIDViewControllerDelegate>

@property (strong, nonatomic) SESIDViewController *smartIdViewController;

@end

@implementation SESIDSampleViewController

- (void) viewDidLoad {
  [super viewDidLoad];
  
  [self addScanButton];
  [self addResultTextView];
  [self addResultImageView];
  
  [self initializeSmartIdViewController];
}

- (void) initializeSmartIdViewController {
  // core configuration may take a while so it's better to be done
  // before displaying smart id view controller
  self.smartIdViewController = [[SESIDViewController alloc] init];
  
  // assigning self as delegate to get smartIdViewControlerDidRecognizeResult called
  self.smartIdViewController.delegate = self;
  
  // configure optional visualization properties (they are NO by default)
  self.smartIdViewController.displayDocumentQuadrangle = YES;
  self.smartIdViewController.displayZonesQuadrangles = YES;
}

- (void) showSmartIdViewController {
  if (!self.smartIdViewController) {
    [self initializeSmartIdViewController];
  }
  
  // important!
  // setting enabled document types for this view controller
  // according to available document types for your delivery
  // these types will be passed to se::smartid::SessionSettings
  // with which se::smartid::RecognitionEngine::SpawnSession(...) is called
  // internally when Smart ID view controller is presented
  // you can specify a concrete document type or a wildcard expression (for convenience)
  // to enable or disable multiple types
  // by default no document types are enabled
  // if exception is thrown please read the exception message
  // see self.smartidViewController.supportedDocumentTypes,
  // se::smartid::SessionSettings and Smart IDReader documentation for further information
  [self.smartIdViewController removeEnabledDocumentTypesMask:"*"];

//  [self.smartIdViewController addEnabledDocumentTypesMask:"*"];
  [self.smartIdViewController addEnabledDocumentTypesMask:"mrz.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"idmrz.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"card.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"rus.passport.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"rus.snils.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"rus.sts.*"];
//  [self.smartIdViewController addEnabledDocumentTypesMask:"rus.drvlic.*"];
  
  // if needed, set a timeout in seconds
  self.smartIdViewController.sessionTimeout = 5.0f;
  
  // presenting OCR view controller
  [self presentViewController:self.smartIdViewController
                     animated:YES
                   completion:nil];
  
  // if you want to deinitialize view controller to save the memory, do this:
  // self.smartIdViewController = nil;
}

#pragma mark - SESIDViewControllerDelegate
- (void) smartIdViewControllerDidRecognizeResult:(const se::smartid::RecognitionResult &)result {
  // if result is not terminal we'd probably want to continue recognition until it becomes terminal
  // you can also check individual fields using result.GetStringField("field_name").IsAccepted()
  // in order to conditionally stop recognition when required fields are accepted
  if (!result.IsTerminal()) {
    return;
  }
  
  // dismiss Smart ID OCR view controller
  [self dismissViewControllerAnimated:YES completion:nil];
  
  // use recognition result
  NSMutableString *resultString = [[NSMutableString alloc] init];
  
  // use string fields
  const std::vector<std::string> &stringFieldNames = result.GetStringFieldNames();
  [resultString appendString:[NSString stringWithFormat:@"\nFound %zu string fields:\n",
                              stringFieldNames.size()]];
  
  for (size_t i = 0; i < stringFieldNames.size(); ++i) {
    const se::smartid::StringField &field = result.GetStringField(stringFieldNames[i]);
    NSString *fieldValue = [NSString stringWithUTF8String:field.GetUtf8Value().c_str()];
    NSString *fieldAccepted = (field.IsAccepted() ? @"[+]" : @"[-]");
    NSString *fieldString = [NSString stringWithFormat:@"%@ %s: %@\n",
                             fieldAccepted, field.GetName().c_str(), fieldValue];
    [resultString appendString:fieldString];
  }
  
  // use image fields
  const std::vector<std::string> &imageFieldNames = result.GetImageFieldNames();
  [resultString appendString:[NSString stringWithFormat:@"\nFound %zu image fields:\n",
                              imageFieldNames.size()]];
  for (size_t i = 0; i < imageFieldNames.size(); ++i) {
    const se::smartid::ImageField &field = result.GetImageField(imageFieldNames[i]);
    NSString *fieldAccepted = (field.IsAccepted() ? @"[+]" : @"[-]");
    const se::smartid::Image &image = field.GetValue();
    
    NSString *fieldString = [NSString stringWithFormat:@"%@ %s (%dx%d)\n",
                             fieldAccepted, field.GetName().c_str(), image.width, image.height];
    [resultString appendString:fieldString];
  }
  
  const std::string photoName = "photo";
  if (result.HasImageField(photoName)) {
    const se::smartid::Image &image = result.GetImageField(photoName).GetValue();
    self.resultImageView.image = [SESIDViewController uiImageFromSmartIdImage:image];
  } else {
    self.resultImageView.image = nil;
  }
  
  [self.resultTextView setText:resultString];
}

- (void) smartIdViewControllerDidCancel {
  // dismiss Smart ID OCR view controller
  [self dismissViewControllerAnimated:YES completion:nil];
  
  [self.resultTextView setText:@"Recognition cancelled by user"];
  [self.resultImageView setImage:nil];
}

#pragma mark - Misc
- (void) viewDidLayoutSubviews {
  self.scanButton.frame = CGRectMake(0, 20, self.view.bounds.size.width, 50);
  
  const CGFloat imageWidth = 120;
  const CGFloat imageHeight = imageWidth * 3.0 / 2.0;
  
  self.resultTextView.frame = CGRectMake(0,
                                         CGRectGetMaxY(self.scanButton.frame) + 15,
                                         self.view.bounds.size.width,
                                         self.view.bounds.size.height
                                           - CGRectGetMaxY(self.scanButton.frame) - 15);
  
  const CGRect imageFrame = CGRectMake(self.resultTextView.bounds.size.width - imageWidth - 10,
                                       10,
                                       imageWidth, imageHeight);
  self.resultImageView.frame = imageFrame;
  
  CGRect exclusionRect = imageFrame;
  exclusionRect.size.width = self.resultTextView.bounds.size.width;
  
  UIBezierPath *exclusionPath = [UIBezierPath bezierPathWithRect:exclusionRect];
  self.resultTextView.textContainer.exclusionPaths = @[exclusionPath];
}

- (void) addScanButton {
  self.scanButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
  [self.scanButton setBackgroundColor:UIColor.whiteColor];
  [self.scanButton setAutoresizingMask:UIViewAutoresizingFlexibleWidth];
  [self.scanButton setTitle:@"Press to Scan ID!" forState:UIControlStateNormal];
  [self.scanButton addTarget:self
                      action:@selector(showSmartIdViewController)
            forControlEvents:UIControlEventTouchUpInside];
  [self.view addSubview:self.scanButton];
}

- (void) addResultTextView {
  self.resultTextView = [[UITextView alloc] init];
  self.resultTextView.autoresizingMask = UIViewAutoresizingFlexibleHeight
                                       | UIViewAutoresizingFlexibleWidth;
  self.resultTextView.editable = NO;
  self.resultTextView.font = [UIFont fontWithName:@"Menlo-Regular" size:12.0f];
  
  [self.view addSubview:self.resultTextView];
}

- (void) addResultImageView {
  self.resultImageView = [[UIImageView alloc] init];
  self.resultImageView.contentMode = UIViewContentModeScaleAspectFit;
  self.resultImageView.backgroundColor = [UIColor colorWithWhite:0.9f alpha:0.5f];
  
  [self.resultTextView addSubview:self.resultImageView];
}

- (BOOL) prefersStatusBarHidden {
  return NO;
}

- (UIStatusBarStyle) preferredStatusBarStyle {
  return UIStatusBarStyleLightContent;
}

- (UIInterfaceOrientationMask) supportedInterfaceOrientations {
  return UIInterfaceOrientationMaskAll;
}

@end
