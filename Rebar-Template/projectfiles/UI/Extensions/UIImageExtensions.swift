/// The MIT License (MIT)
///
/// Copyright (c) 2016 Monkton, Inc
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in all
/// copies or substantial portions of the Software.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
/// SOFTWARE.
///

import UIKit
import Rebar
import CoreGraphics

extension UIImage {
	func changeColor(_ color: UIColor!) -> UIImage {
		
		let source = self;
		
		// begin a new image context, to draw our colored image onto with the right scale
		UIGraphicsBeginImageContextWithOptions(source.size, false, UIScreen.main.scale);
		
		// get a reference to that context we created
		let context: CGContext? = UIGraphicsGetCurrentContext();
		
		// set the fill color
		color.setFill();
		
		// translate/flip the graphics context (for transforming from CG* coords to UI* coords
		context!.translateBy(x: 0, y: source.size.height);
		context!.scaleBy(x: 1.0, y: -1.0);
		
		
		context!.setBlendMode(CGBlendMode.colorBurn);
		let rect: CGRect! = CGRect(x: 0, y: 0, width: source.size.width, height: source.size.height);
		context!.draw(source.cgImage!, in: rect);
		
		context!.setBlendMode(CGBlendMode.sourceIn);
		context!.addRect(rect);
		
		
		context!.drawPath(using: CGPathDrawingMode.fill);
		
		// generate a new UIImage from the graphics context we drew onto
		let coloredImg: UIImage! = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
		
		//return the color-burned image
		return coloredImg;
	}
	
}
