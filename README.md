# DataWeave Lookup

This repository contains a simple MuleSoft application flow that replicates a simple supplied example.

## Walkthrough

The main flow, fully expanded, is this. Note the logging steps as shown are purely for reference within the demo would not necessarily be included in a production flow. There is a common error handling process to capture errors, returning a simple message to the caller.

![Main flow of the application](docs/img/img1_mainflow.png?raw=true "Main flow")

The request and response mapping elements have been broken out as referenced flows to enable reuse and custom error handling logic to be deployed.

![Request mapping flow of the application](docs/img/img2_requestMappingFlow.png?raw=true "Request mapping flow")

Within the request mapping flow, we execute a Transform Message operation:

![DataWeave code transforming the request payload](docs/img/img3_dataweave.png?raw=true "Request dataWeave")
 
- All fields are transposed as-is, except:
  - **BR_Email** is forced to lowercase.
  - **GC_CreationStatus** uses a static lookup to transpose its value.
  - **GC_DeletionFlag** uses a static lookup to transpose its value; it defaults to "0" if unspecified.
- The output data is formatted as XML. Note that this requires the inclusion of a unary root element ("root") as the root of an XML data structure cannot be an array.

The implementation of the GC_CreationStatus and GC_DeletionFlag lookups is as follows.

The lookup data is stored as a DataWeave map object, and saved as a variable inside a DataWeave module.

![Externalized DataWeave file that implements the lookup](docs/img/img4_lookup.png?raw=true "Lookup implementation")

This snippet defines a map object called `GC_CreationStatusMap`. The file is saved as `GC_CreationStatusMap.dwl` inside the project in a specified directory `maps`. Note the file must be located within the classpath (e.g. `src/main/resources`). The module can now easily be referenced by any transformer, flow or application that needs to perform the lookup.

The Transform Message step imports the DW module (line 2: `import GC_CreationStatusMap from maps::GC_CreationStatusMap`). This imports the map object so it can be used as an inline lookup using the inbound item as a key (line 19: `GC_CreationStatus: GC_CreationStatusMap[$.GC_CreationStatus]`).

Further nodes on creating and using custom DW modules is available in the MuleSoft product docs:
https://docs.mulesoft.com/mule-runtime/4.3/dataweave-create-module

Upon execution, we can inspect the logs and see the transformations at work:

![Log output showing result of the transformation](docs/img/img5_log.png?raw=true "Log output")
