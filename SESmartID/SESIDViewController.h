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

#import <UIKit/UIKit.h>

#include <smartIdEngine/smartid_engine.h>

/*****************************************************************************
 SESIDViewController is a convenience Objective-C++ wrapper class
 for Smart ID C++ recognition library by Smart Engines.
 
 Please see Smart ID documentation for details and C++ classes usage.
 
 Feel free to modify the source code to meet your needs or contact Smart Engines.
*****************************************************************************/


@protocol SESIDViewControllerDelegate <NSObject>

- (void) smartIdViewControllerDidRecognizeResult:(const se::smartid::RecognitionResult &)smartIdResult;

- (void) smartIdViewControllerDidCancel;

@end


@interface SESIDViewController : UIViewController

@property (weak) id<SESIDViewControllerDelegate> delegate; // receives recognition callbacks

@property (nonatomic, assign) BOOL displayDocumentQuadrangle; // NO by default
@property (nonatomic, assign) BOOL displayZonesQuadrangles; // NO by default

@property (nonatomic) float sessionTimeout; // sets result to terminal after timeout, 0 means no timeout

@property (nonatomic) UIButton *cancelButton; // cancels scanning, user is able to modify it

- (id) init;

// getter for mutable recognition session settings reference, change them if needed
- (se::smartid::SessionSettings &) sessionSettings;

// important methods for enabling document types for recognition session
// wildcard expressions can be used
// by default no document types are enabled
// see se::smartid::SessionSettings for details
- (void) addEnabledDocumentTypesMask:(const std::string &)documentTypesMask;
- (void) removeEnabledDocumentTypesMask:(const std::string &)documentTypesMask;

// actual document types without wildcard expressions
- (void) setEnabledDocumentTypes:(const std::vector<std::string> &)documentTypes;
- (const std::vector<std::string> &) enabledDocumentTypes;

// list of supported document groups that can be enabled together
- (const std::vector<std::vector<std::string> > &) supportedDocumentTypes;

// convert se::smartid::Image to UIImage e.g. for display purposes
+ (UIImage *) uiImageFromSmartIdImage:(const se::smartid::Image &)image;

@end
