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

#import "SESIDRecognitionCore.h"

#import <UIKit/UIImage.h>

#include <memory>

@interface SESIDRecognitionCore() {
  std::unique_ptr<se::smartid::SessionSettings> sessionSettings_;
  std::unique_ptr<se::smartid::RecognitionEngine> engine_;
  std::unique_ptr<se::smartid::RecognitionSession> session_;
}

@end

@implementation SESIDRecognitionCore

- (id) init {
  if (self = [super init]) {
    self.canProcessFrames = NO;
    
    [self initRecognitionCore];
  }
  return self;
}

- (void) initRecognitionCore {
  NSString *dataPath = [self pathForSingleDataArchive];
  
  try {
    // creating recognition engine
    engine_.reset(new se::smartid::RecognitionEngine(dataPath.UTF8String));
    
    // creating default session settings
    sessionSettings_.reset(engine_->CreateSessionSettings());
    
    const std::vector<std::vector<std::string> > &supportedDocumentTypes =
      sessionSettings_->GetSupportedDocumentTypes();
    NSLog(@"Supported document types for configured engine:");
    for (size_t i = 0; i < supportedDocumentTypes.size(); ++i) {
      const std::vector<std::string> &supportedGroup = supportedDocumentTypes[i];
      NSMutableString *supportedGroupString = [NSMutableString string];
      for (size_t j = 0; j < supportedGroup.size(); ++j) {
        [supportedGroupString appendFormat:@"%s", supportedGroup[j].c_str()];
        if (j + 1 != supportedGroup.size()) {
          [supportedGroupString appendString:@", "];
        }
      }
      NSLog(@"[%zu]: [%@]", i, supportedGroupString);
    }
  }
  catch (const std::exception &e) {
    [NSException raise:@"SmartIDException"
                format:@"Exception thrown during initialization: %s", e.what()];
  }
}

- (void) initializeSessionWithReporter:(se::smartid::ResultReporterInterface *)resultReporter {
  try {
    const std::vector<std::string> &documentTypes = sessionSettings_->GetEnabledDocumentTypes();
    NSLog(@"Enabled document types for recognition session to be created:");
    for (size_t i = 0; i < documentTypes.size(); ++i) {
      NSLog(@"%s", documentTypes[i].c_str());
    }
    
    // creating recognition session
    session_.reset(engine_->SpawnSession(*sessionSettings_, resultReporter));
  } catch (const std::exception &e) {
    [NSException raise:@"SmartIDException"
                format:@"Exception thrown during session spawn: %s", e.what()];
  }
  
  self.canProcessFrames = YES;
}

- (se::smartid::SessionSettings &) sessionSettings {
  return *sessionSettings_;
}

- (se::smartid::RecognitionResult) processSampleBuffer:(CMSampleBufferRef)sampleBuffer
                                           orientation:(se::smartid::ImageOrientation)orientation {
  // extracting image data from sample buffer
  CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
  
  CVPixelBufferLockBaseAddress(imageBuffer, 0);
  uint8_t *basePtr = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
  
  const size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
  const size_t width = CVPixelBufferGetWidth(imageBuffer);
  const size_t height = CVPixelBufferGetHeight(imageBuffer);
  const size_t channels = 4; // assuming BGRA
  
  if (basePtr == 0 || bytesPerRow == 0 || width == 0 || height == 0) {
    NSLog(@"%s - sample buffer is bad", __func__);
  }
  
  CVPixelBufferUnlockBaseAddress(imageBuffer, 0);
  
  // processing extracted image data
  return [self processUncompressedImageData:basePtr
                                      width:(int)width
                                     height:(int)height
                                     stride:(int)bytesPerRow
                                   channels:channels
                                orientation:orientation];
}

- (se::smartid::RecognitionResult) processUncompressedImageData:(uint8_t *)imageData
                                                          width:(int)width
                                                         height:(int)height 
                                                         stride:(int)stride
                                                       channels:(int)channels
                                                    orientation:(se::smartid::ImageOrientation)orientation {
  try {
    const size_t dataLength = stride * height;
    return session_->ProcessSnapshot(imageData,
                                     dataLength,
                                     width,
                                     height,
                                     stride,
                                     channels,
                                     orientation);
  } catch (const std::exception &e) {
    NSLog(@"Exception thrown during processing: %s", e.what());
  }
  return se::smartid::RecognitionResult();
}

#pragma mark - Utilities
+ (UIImage *) uiImageFromSmartIdImage:(const se::smartid::Image &)image {
  const bool shouldCopy = true;
  
  NSData *data = nil;
  if (shouldCopy) {
    data = [NSData dataWithBytes:image.data
                          length:image.height * image.stride];
  } else {
    data = [NSData dataWithBytesNoCopy:image.data
                                length:image.height * image.stride
                          freeWhenDone:NO];
  }
  
  CGColorSpaceRef colorSpace;
  if (image.channels == 1) {
    colorSpace = CGColorSpaceCreateDeviceGray();
  } else {
    colorSpace = CGColorSpaceCreateDeviceRGB();
  }
  
  CGDataProviderRef provider = CGDataProviderCreateWithCFData((__bridge CFDataRef)data);
  
  CGImageRef imageRef = CGImageCreate(image.width, // Width
                                      image.height, // Height
                                      8, // Bits per component
                                      8 * image.channels, // Bits per pixel
                                      image.stride, // Bytes per row
                                      colorSpace, // Colorspace
                                      kCGImageAlphaNone | kCGBitmapByteOrderDefault, // Bitmap info flags
                                      provider, // CGDataProviderRef
                                      NULL, // Decode
                                      false, // Should interpolate
                                      kCGRenderingIntentDefault); // Intent
  
  UIImage *ret = [UIImage imageWithCGImage:imageRef
                                     scale:1.0f
                               orientation:UIImageOrientationUp];
  
  CGImageRelease(imageRef);
  CGDataProviderRelease(provider);
  CGColorSpaceRelease(colorSpace);
  
  return ret;
}

- (NSString *) pathForSingleDataArchive {
  NSBundle *bundle = [NSBundle bundleForClass:[self classForCoder]];
  NSString *dataPath = [bundle pathForResource:@"data-zip" ofType:nil];
  NSArray *listdir = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:dataPath error:nil];
  NSPredicate *zipFilter = [NSPredicate predicateWithFormat:@"self ENDSWITH '.zip'"];
  NSArray *zipArchives = [listdir filteredArrayUsingPredicate:zipFilter];
  NSAssert(zipArchives.count == 1, @"data-zip folder must contain single .zip archive");
  NSString *zipName = [zipArchives objectAtIndex:0];
  NSString *zipPath = [dataPath stringByAppendingPathComponent:zipName];
  return zipPath;
}

@end
