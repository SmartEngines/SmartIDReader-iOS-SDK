# Smart IDReader SDK 

  * [Troubleshooting and help](#troubleshooting-and-help)
  * [General Usage Workflow](#general-usage-workflow)
  * [Smart IDReader C++ SDK Overview](#smart-idreader-c-sdk-overview)
    - [Header files and namespaces](#header-files-and-namespaces)
    - [Code documentation](#code-documentation)
    - [Exceptions](#exceptions)
    - [Factory methods and memory ownership](#factory-methods-and-memory-ownership)
    - [Getters and setters](#getters-and-setters)
  * [Configuration bundles](#configuration-bundles)
  * [Specifying document types for Recognition Session](#specifying-document-types-for-recognition-session)
    - [Supported document types](#supported-document-types)
    - [Enabling document types using wildcard expressions](#enabling-document-types-using-wildcard-expressions)
  * [Session options](#session-options)
    - [Common options](#common-options)
  * [Result Reporter Callbacks](#result-reporter-callbacks)
  * [Java API](#java-api)
    - [Object deallocation](#object-deallocation)
    - [Result Reporter Interface scope](#result-reporter-interface-scope)
  * [C API](#c-api)
    - [C memory management](#c-memory-management)
    - [Return codes and exception messages](#return-codes-and-exception-messages)
  * [Documents reference](./DOCUMENTS_REFERENCE.html)    


## Troubleshooting and help

To resolve issue that you might be facing we recommend to do the following:

* Carefully read in-code documentation in API an samples and documentation in .pdf and .html including this document
* Check out the code details / compilation flags etc in sample code and projects
* Read exception messages if exception is thrown - it might contain usable information

But remember:
* You are always welcome to ask for help at `support@smartengines.biz` (or product manager's email) no matter what

## General Usage Workflow

1. Create `RecognitionEngine` instance:

    ```cpp
    se::smartid::RecognitionEngine engine(configuration_bundle_path);
    ```

    Configuration process might take a while but it only needs to be performed once during the program lifetime. Configured `RecognitionEngine` is used to spawn lightweight Recognition Sessions which have actual recognition methods.

    See more about configuration bundles in [Configuration Bundles](#configuration-bundles).

2. Create `SessionSettings` from configured `RecognitionEngine`:
    
    ```cpp
    std::unique_ptr<se::smartid::SessionSettings> settings(engine.CreateSessionSettings());
    ```

    Note, that `RecognitionEngine::CreateSessionSettings()` is a factory method and returns an allocated pointer. You are responsible for deleting it.

3. Enable desired document types:

    ```cpp
    settings->AddEnabledDocumentTypes("mrz.*");
    ```

    See more about document types in [Specifying document types for Recognition Session](#specifying-document-types-for-recognition-session).

4. Specify session options (not required):

    ```cpp
    settings->SetOption("common.sessionTimeout", "5");
    ```

    See more about options in [Session Options](#session-options).

5. Subclass ResultReporter and implement callbacks (not required):

    ```cpp
    class ConcreteResultReporter : public se::smartid::ResultReporterInterface { /* callbacks */ }

    ConcreteResultReporter optional_reporter; 
    ```

    See more about result reporter callbacks in [Result Reporter Callbacks](#result-reporter-callbacks).

6. Spawn Recognition Session:

    ```cpp
    unique_ptr<RecognitionSession> session(engine.SpawnSession(*settings, &optional_reporter));
    ```

7. Call `ProcessSnapshot(...)`, `ProcessImageFile(...)` or similar methods:

    ```cpp
    se::smartid::RecognitionResult result = session->ProcessImageFile(image_path);
    ```

    When performing recognition in video stream you might want to process frames coming from the stream until `result.IsTerminal()` is `true`.

8. Use `RecognitionResult` fields to extract recognized information:
    
    ```cpp
    for (const std::string &field_name : result.GetStringFieldNames()) {
        const se::smartid::StringField &string_field = result.GetStringField(field_name);

        bool is_accepted = string_field.IsAccepted();
        std::string field_value = string_field.GetUtf8Value();
    }
    ```

    Apart from string fields there also are image fields:

    ```cpp
    for (const std::string &field_name : result.GetImageFieldNames()) {
        const se::smartid::ImageField &image_field = result.GetStringField(field_name);

        const se::smartid::Image &image = image_field.GetValue();
    }
    ```


## Smart IDReader C++ SDK Overview

#### Header files and namespaces

You can either include all-in-one header file or only required ones:

```cpp
#include <smartIdEngine/smartid_engine.h> // all-in-one
#include <smartIdEngine/smartid_common.h> // common classes 
#include <smartIdEngine/smartid_result.h> // result classes
```

Smart IDReader C++ SDK code is located within `se::smartid` namespace.

#### Code documentation

All classes and functions have useful Doxygen comments.  
Other out-of-code documentation is available at `doc` folder of your delivery.  
For complete compilable and runnable sample usage code and build scripts please see `samples` folder.

#### Exceptions

Our C++ API may throw `std::exception` subclasses when user passes invalid input, makes bad state calls or if something else goes wrong. Most exceptions contain useful human-readable information. Please read `e.what()` message if exception is thrown. 

#### Factory methods and memory ownership

Several Smart IDReader SDK classes have factory methods which return pointers to heap-allocated objects.  **Caller is responsible for deleting** such objects _(a caller is probably the one who is reading this right now)_.
We recommend using `std::unique_ptr<T>` for simple memory management and avoiding memory leaks.

#### Getters and setters

We return const references in getters wherever possible, it's better to assign them to const references as well to avoid undesirable copying. If there is only getter without setter for some variable then most probably we did this by purpose because configuration is done somewhere else internally.

## Configuration bundles

Every delivery contains one or several _configuration bundles_ – archives containing everything needed for Smart IDReader Recognition Engine to be created and configured.
Usually they are named as `bundle_something.zip` and located inside `data-zip` folder.

## Specifying document types for Recognition Session

Assuming you already created recognition engine and session settings like this:

```cpp
// create recognition engine with configuration bundle path
se::smartid::RecognitionEngine engine(configuration_bundle_path);

// create session settings with se::smartid::RecognitionEngine factory method
std::unique_ptr<se::smartid::SessionSettings> settings(engine.CreateSessionSettings());
```

In order to call `engine.SpawnSession(settings, optional_reporter)` you need to specify enabled document types for session to be spawned using `se::smartid::SessionSettings` methods.
**By default, all document types are disabled.**

#### Supported document types

A _document type_ is simply a string encoding real world document type you want to recognize, for example, `rus.passport.internal` or `mrz.mrp`. Document types that Smart IDReader SDK delivered to you can potentially recognize can be obtaining using `GetSupportedDocumentTypes()` method:

```cpp
const vector<vector<string> > &supported_document_types = settings->GetSupportedDocumentTypes();
```

This vector is two-dimensional because of the restrictions of current Smart IDReader SDK version: **you can only enable document types that belong to the same `vector<string>`** of supported document types for a single session.

You can find full list of supported document types of Smart IDReader with their fields in [Documents Reference](./DOCUMENTS_REFERENCE.html).

#### Enabling document types using wildcard expressions

Since all documents in settings are disabled by default you need to enable some of them. 
In order to do so you may use `AddEnabledDocumentTypes(string)` and `SetEnabledDocumentTypes(vector<string>)` (removes all and adds each string of the vector) methods of `SessionSettings`:

```cpp
// settings->AddEnabledDocumentTypes("*");
settings->AddEnabledDocumentTypes("mrz.*");
// settings->AddEnabledDocumentTypes("card.*");
// settings->AddEnabledDocumentTypes("idmrz.*");
// settings->AddEnabledDocumentTypes("rus.passport.*");
// settings->AddEnabledDocumentTypes("rus.snils.*");
// settings->AddEnabledDocumentTypes("rus.sts.*");
// settings->AddEnabledDocumentTypes("rus.drvlic.*");
```

You may also use `RemoveEnabledDocumentTypes(string)` method to remove already enabled document types.

For convenience it's possible to use **wildcards** (using asterisk symbol) while enabling or disabling document types. When using document types related methods, each passed document type is matched against all supported document types. All matches in supported document types are added to the enabled document types list. For example, document type `rus.passport.internal` can be matched with `rus.*`, `*passport*` and of course a single asterisk `*`.

In order to get actual enabled document types list after wildcard expression matching you can use:

```cpp
const std::vector<std::string> &enabled_doctypes = settings->GetEnabledDocumentTypes();
```

As it was mentioned earlier, you can only enable document types that belong to the same `vector<string>` of supported document types for a single session.
If you do otherwise then informative exception will be thrown on `engine.SpawnSession(...)` call.

It's always better to enable the minimum number of document types as possible if you know exactly what are you going to recognize because the system will spend less time deciding which document type out of all enabled ones has been presented to it.

## Session options

Some configuration bundle options can be overriden in runtime using `se::smartid::SessionSettings` methods. You can obtain all option names and their values using:

```cpp
const std::map<std::string, std::string> &options = settings->GetOptions();
```

You can change option values using `settings->SetOption(...)` method:

```cpp
settings->SetOption("passport.extractTemplateImages", "true");
settings->SetOption("passport.extractFieldImages", "true");
```

Option values are always `std::string` so if you want to pass an integer or boolean it should be converted to string first. It's done like that to avoid unwanted complexity with 'variant' classes and so on.

#### Common options

There is a special subset of options which have names in form `common.<option_name>` which are general session options, for example:

```cpp
settings->SetOption("common.sessionTimeout", "5.0"); // timeout in seconds
```

## Result Reporter Callbacks

Smart IDReader SDK supports optional callbacks during document analysis and recognition process before the `ProcessSnapshot(...)` or similar functions are finished. 
It allows the user to be more informed about the underlying recognition process and also helps creating more interactive GUI.

To support callbacks you need to subclass `ResultReporterInterface` class and implement desirable callback methods:

```cpp
class ConcreteResultReporter : public se::smartid::ResultReporterInterface {
public:
  virtual void SnapshotRejected() override { }
  virtual void DocumentMatched(vector<MatchResult> &match_results) override { }
  virtual void DocumentSegmented(const vector<SegmentationResult> &segmentation_results) override { }
  virtual void SnapshotProcessed(const RecognitionResult &recog_result) override { }
  virtual void SessionEnded() override { }
};
```

Methods `DocumentMatched(...)` and `DocumentSegmented(...)` are especially useful for displaying document zones and fields bounds in GUI during live video stream recognition.

We recommend using `override` keyword for C++11 because it greatly helps to avoid typos in function signatures.

You also need to create an instance of `ConcreteResultReporter` somewhere in the code and pass it when you spawn the session:

```cpp
ConcreteResultReporter reporter;

unique_ptr<RecognitionSession> session(engine.SpawnSession(*settings, &reporter));
```
**Important!** Your `ResultReporterInterface` subclass instance must not be deleted while `RecognitionSession` is alive. We recommend to place them in the same scope.

## Java API

Smart IDReader SDK has Java API which is automatically generated from C++ interface by SWIG tool. 

Java interface is the same as C++ except minor differences (e.g. STL containers wrappers), please see Java sample.

There are several drawbacks related to Java memory management that you need to consider.

#### Object deallocation

Even though garbage collection is present and works, it's strongly advised to manually call `obj.delete()` functions for our API objects because they are wrappers to the heap-allocated memory and their heap size is unknown to the garbage collector. 

```java
RecognitionEngine engine = new RecognitionEngine(config_path); // or any other object

// ...

engine.delete(); // forces and immediately guarantees wrapped C++ object deallocation
```

This is important because from garbage collector's point of view these objects occupy several bytes of Java memory while their actual heap-allocated size may be up to several dozens of megabytes. GC doesn't know that and decides to keep them in memory – several bytes won't hurt, right?

You don't want such objects to remain in your memory when they are no longer needed so call `obj.delete()` manually.

#### Result Reporter Interface scope

When using optional callbacks by subclassing `ResultReportingInterface` please make sure that its instance have the same scope as `RecognitionSession`. The reason for this is that our API does not own the pointer to the reporter instance which cause premature garbage collection resulting in crash:

```java
// BAD: may cause premature garbage collection of reporter instance
class MyDocumentRecognizer {
    private RecognitionEngine engine;
    private RecognitionSession session;

    private void InitializeSmartIdReader() {
        // ...
        session = engine.SpawnSession(settings, new MyResultReporter());

        // reporter might be garbage collected there because session doesn't own it
    }
}
```

```java
// GOOD: reporter have at least the scope of recognition session
class MyDocumentRecognizer {
    private RecognitionEngine engine;
    private RecognitionSession session;
    private MyResultReporter reporter; // reporter has session's scope

    private void InitializeSmartIdReader() {
        // ...
        reporter = new MyResultReporter();
        session = engine.SpawnSession(settings, reporter);
    }
}
```

## C API

Smart IDReader SDK has C API for use cases where C++ is not possible. Please see C sample for details.

#### C memory management

Since there are no constructors and destructors in C we use Create/Destroy pairs of functions which are used to allocate and deallocate objects. 

#### Return codes and exception messages

C does not have exceptions so every function returns `int` which must be `0` when function call was successful. Also, there is `CSmartIdErrorMessage *` passed to every function with error buffer containing propagated exception message if any exception has been thrown. 
