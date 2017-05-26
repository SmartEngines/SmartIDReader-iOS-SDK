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

#import "SESIDQuadrangleView.h"

@interface SESIDQuadrangleView()

@end

@implementation SESIDQuadrangleView

- (id) init {
  if (self = [super init]) {
    [self setBackgroundColor:[UIColor clearColor]];
  }
  return self;
}

- (void) animateQuadrangle:(const se::smartid::Quadrangle &)quadrangle
                     color:(UIColor *)color
                     width:(CGFloat)width
                     alpha:(CGFloat)alpha {
  CAShapeLayer *layer = [CAShapeLayer layer];
  layer.path = [self bezierPathForQuadrangle:quadrangle].CGPath;
  layer.backgroundColor = UIColor.redColor.CGColor;
  layer.strokeColor = color.CGColor;
  layer.fillColor = [UIColor clearColor].CGColor;
  layer.lineWidth = width;
  layer.opacity = 0.0f;
  
  [self.layer addSublayer:layer];
  
  __weak CAShapeLayer *weakLayer = layer;
  
  dispatch_async(dispatch_get_main_queue(), ^{
    [CATransaction begin];
    [CATransaction setCompletionBlock:^{
      dispatch_async(dispatch_get_main_queue(), ^{
        [weakLayer removeFromSuperlayer];
      });
    }];
    
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"opacity"];
    animation.fromValue = @(alpha);
    animation.toValue = @(0.0f);
    animation.duration = 0.7f;
    
    [weakLayer addAnimation:animation forKey:animation.keyPath];
    
    [CATransaction commit];
    [self setNeedsDisplay];
  });
}

- (UIBezierPath *) bezierPathForQuadrangle:(const se::smartid::Quadrangle &)smartIdQuadrangle {
  UIBezierPath *path = [UIBezierPath bezierPath];
  const se::smartid::Point first = [self scaledPoint:smartIdQuadrangle[0]];
  [path moveToPoint:CGPointMake(first.x, first.y)];
  
  for (int i = 0; i < 4; ++i) {
    const se::smartid::Point next = [self scaledPoint:smartIdQuadrangle[(i + 1) % 4]];
    [path addLineToPoint:CGPointMake(next.x, next.y)];
  }
  return path;
}

- (se::smartid::Point) scaledPoint:(const se::smartid::Point &)point {
  se::smartid::Point scaled(point.x * self.drawingScale.width, point.y * self.drawingScale.height);
  return scaled;
}

@end
