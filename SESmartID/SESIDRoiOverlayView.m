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

#import "SESIDRoiOverlayView.h"

#import <AVFoundation/AVFoundation.h>

@interface SESIDRoiOverlayView()

@property (nonatomic, assign) CGRect roiRect;

@end

@implementation SESIDRoiOverlayView

- (id) init {
  if (self = [super init]) {
    self.widthAspectRatio = 0.0f;
    
    self.backgroundColor = [UIColor clearColor];
    
    self.glowColorLevel = 0.0f;
  }
  return self;
}

- (void) drawRect:(CGRect)rect {
  if (self.widthAspectRatio == 0.0f) {
    return;
  }
  
  CGContextRef context = UIGraphicsGetCurrentContext();
  
  // assuming self.bounds already have video frames aspect ratio (e.g. 16:9)
  CGRect viewRect = self.bounds;
  
  CGContextAddRect(context, viewRect);
  CGContextAddRect(context, self.roiRect);
  CGContextSetGrayFillColor(context, 0.5f, 0.66f);
  CGContextEOFillPath(context);
  
  if (self.glowColorLevel >= 0.0f) {
    const CGRect topRect = CGRectMake(viewRect.origin.x,
                                      viewRect.origin.y,
                                      viewRect.size.width,
                                      self.roiRect.origin.y - viewRect.origin.y);
    [self drawGradientInContext:context rect:topRect start:0.0f end:1.0f];
    
    const CGRect bottomRect = CGRectMake(viewRect.origin.x,
                                         self.roiRect.origin.y + self.roiRect.size.height,
                                         viewRect.size.width,
                                         topRect.size.height);
    [self drawGradientInContext:context rect:bottomRect start:1.0f end:0.0f];
  }
}

- (void) drawGradientInContext:(CGContextRef)context rect:(CGRect)rect
                         start:(CGFloat)start end:(CGFloat)end {
  CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
  CGFloat locations[] = { start, end };
  
  NSArray *colors = @[(__bridge id)[UIColor clearColor].CGColor,
                      (__bridge id)[self glowColor].CGColor];
  
  CGGradientRef gradient = CGGradientCreateWithColors(colorSpace,
                                                      (__bridge CFArrayRef) colors,
                                                      locations);
  
  CGPoint startPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMinY(rect));
  CGPoint endPoint = CGPointMake(CGRectGetMidX(rect), CGRectGetMaxY(rect));
  
  CGContextSaveGState(context);
  CGContextAddRect(context, rect);
  CGContextClip(context);
  CGContextDrawLinearGradient(context, gradient, startPoint, endPoint, 0);
  CGContextRestoreGState(context);
  
  CGGradientRelease(gradient);
  CGColorSpaceRelease(colorSpace);
}

- (void) setWidthAspectRatio:(CGFloat)widthAspectRatio {
  _widthAspectRatio = widthAspectRatio;
  
  [self updateRoiRect];
}

- (void) updateRoiRect {
  const CGFloat roiHeight = self.bounds.size.width / self.widthAspectRatio;
  
  self.roiRect = CGRectMake(0,
                            self.bounds.size.height / 2 - roiHeight / 2,
                            self.bounds.size.width,
                            roiHeight);
  [self setNeedsDisplay];
}

- (void) layoutSubviews {
  [super layoutSubviews];
  
  [self updateRoiRect];
}

- (UIColor *) glowColor {
  self.glowColorLevel = MIN(1.0f, MAX(0.0f, self.glowColorLevel));
  return [UIColor colorWithRed:0.7f * (1.0f - self.glowColorLevel)
                         green:0.7f
                          blue:0.0f
                         alpha:0.5f * self.glowColorLevel];
}

@end
//
