# Smart IDReader iOS SDK - Test version

This is a **TEST** version of Smart IDReader iOS SDK which demonstrates the usage of our library/SDK without actually providing any recognition functionality.

If you'd like to obtain a trial or full version of Smart IDReader please contact us via
* support@smartengines.biz 
* http://smartengines.biz/contacts/
* http://smartengines.ru/contacts/

## Smart IDReader

Smart IDReader technology allows you to recognize identity and property rights documents while using video/photo cameras and scanners in mobile, desktop, server and terminal solutions. With this tecnhology you only need to present the document to the camera to let Smart IDReader recognize all required data in 1-3 seconds and then fill them in any file, form or a work sheet.

Key features:
* Recognition on mobile devices
* Recognition in real time
* Recognition of documents in video stream
* Recognition of documents in various lighting conditions
* White label license
* Security: only device RAM is used, no personal data is being copied or sent over the internet (e.g. for processing on servers)

Supported platforms: iOS, Android, Windows, Linux, MacOS, Solaris and others

Supported programming languages: C++, C, C#, Objective-C, Java, Visual Basic and others

Supported architectures: armv7-v8, aarch64, x86, x86_64, SPARC, E2K and others

## Smart IDReader SDK Integration Guide for iOS

### 1. Configuring Xcode project

1. Add `SESmartID` folder containing Objective-C source files to your project, select **Create groups** in the menu
2. Add `SESmartIDCore/lib` folder containing static library to your project, select **Create groups** in the menu
3. Add `SESmartIDCore/data-zip` folder to your project, select **Create folder references** in the menu
4. Add `SESmartIDCore/include` folder to the **Header Search Paths** in project settings

### 2. Sample code tutorial

1. Make your ViewController (```SESIDSampleViewController``` in sample project) conform to ```<SESIDViewControllerDelegate>``` and add an instance of ```SESIDViewController``` (for example, as a property). Note, that every `.m` file that includes `SESIDViewController.h` should be renamed to `.mm` to enable Objective-C++ compilation for this file. 

  ```objectivec
  // SESIDSampleViewController.h
  
  #import "SESIDViewController.h"
  
  @interface SESIDSampleViewController : UIViewController <SESIDViewControllerDelegate>
  
  @property (nonatomic, strong) SESIDViewController *smartIdViewController;
  
  // ...
  @end
  ```
  
  Another way is to use *anonymous category* inside implementation file
  (details: [Apple Developer website](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/ProgrammingWithObjectiveC/CustomizingExistingClasses/CustomizingExistingClasses.html#//apple_ref/doc/uid/TP40011210-CH6-SW3)). The advantage is that you'll need to rename only one file's extension to `.mm`

  ```objectivec++
  // SESIDSampleViewController.h
  
  // left unchanged
  @interface SESIDSampleViewController : UIViewController 
  // ...
  @end
  
  // SESIDSampleViewController.mm
  
  #import "SESIDViewController.h"
  
  @interface SESIDSampleViewController () <SESIDViewControllerDelegate>
  
  @property SESIDViewController *smartIdViewController;
  
  @end
  ```

2. Create and configure ```SESIDViewController``` instance

  ```objectivec++
  // SESIDSampleViewController.mm
  
  // this might be called from viewDidLoad or similar methods, 
  // depends on when do you want recognition core to be initialized.
  // could be done in the background thread
  - (void) initializeSmartIdViewController {
    // core configuration may take a while so it's better to be done
    // before displaying smart id view controller
    self.smartIdViewController = [[SESIDViewController alloc] init];
    
    // assigning self as delegate to get smartIdViewControlerDidRecognizeResult called
    self.smartIdViewController.delegate = self;
    
    // configure optional visualization properties (they are NO by default)
    self.smartIdViewController.displayDocumentQuadrangle = YES;
  }
  ```
    
3. Implement  ```smartIdViewControllerDidRecognizeResult:``` method which will be called when ```SESIDViewController``` has successfully scanned a document and ```smartIdViewControllerDidCancel``` method which will be called when recognition has been cancelled by user

  ```objectivec++
  // SESIDSampleViewController.mm
  
  - (void) smartIdViewControllerDidRecognizeResult:(const se::smartid::RecognitionResult &)result {
    // if result is not terminal we'd probably want to continue recognition until it becomes terminal
    // you can also check individual fields using result.GetStringField("field_name").IsAccepted()
    // in order to conditionally stop recognition when required fields are accepted
    if (!result.IsTerminal()) {
      return;
    }
    
    // dismiss Smart ID OCR view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // use recognition result, see sample code for details
    // ...
  }

  - (void) smartIdViewControllerDidCancel {
    // dismiss Smart ID OCR view controller
    [self dismissViewControllerAnimated:YES completion:nil];
    
    // ...
  }


  ```
   
4. Present ```SESIDViewController``` modally when needed, set enabled document types before presenting

  ```objectivec++
  // SESIDSampleViewController.mm

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
    //  [self.smartIdViewController addEnabledDocumentTypesMask:"mrz.*"];
    //  [self.smartIdViewController addEnabledDocumentTypesMask:"card.*"];
    [self.smartIdViewController addEnabledDocumentTypesMask:"rus.passport.*"];
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
  ```
