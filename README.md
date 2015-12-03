
![Screenshot](https://raw.githubusercontent.com/mmackh/IPDFCameraViewController/master/mockup.png)

# IPDFCameraViewController

Welcome to the spiritual successor of [MAImagePickerController](https://github.com/mmackh/MAImagePickerController-of-InstaPDF), that tries to unite a usable & simple camera component class into a single UIView. Initially written as an essential component of InstaPDF 4.0 for [instapdf.com](https://instapdf.com), it seemed too useful to keep closed source. Plus we're celebrating our 100,000 document upload 🎉🎉🎉

Leave all the hard work dealing with AVFoundation, border detection and OpenGL up to IPDFCameraViewController. It includes:

  - Live border detection & perspective correction
  - Flash / Torch
  - Image filters
  - Simple API
 
**WARNING: MINIMUM iOS VERSION REQUIREMENT: 8.0**

Take a look at the sample project to find out how to use it.


## Installation

### Manual

To manually install the framework, drag and drop the `IPDFCameraViewController/IPDFCameraViewController.h` and `IPDFCameraViewController/IPDFCameraViewController.m` files into your project.

### Cocoapods

Add the following to your Podfile:

``` ruby
use_frameworks!
pod "IPDFCameraViewController"
```


## Author
Maximilian Mackh | Twitter: [@mmackh](https://twitter.com/mmackh) | Web: [inoads.com](http://inoads.com)

## Todo's

 - Include more filters
 - Smoother animation between border detection frames
 - Improve confidence