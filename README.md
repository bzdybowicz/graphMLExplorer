# graphMLExplorer
GraphMLExplorer

1. To create graphs, go to Generator/GraphMLGenerator/GraphMLGenerator.xcodeproj <- open project with Xcode. It was created with version 14.3.1, this one is the most reliable. Generator works only on Mac and has no dependencies. Its code is not covered with tests and in general its code was treated as helper tool. Errors may occur.
2. Main project is located in GraphMLExplorer/GraphMLExplorer.xcodeproj.
3. It containts 3 dependencies linked through Swift Package Manager.
	- Fuiz - xml parser - as claimed https://github.com/cezheng/Fuzi they use libxml2 down there
	- swift-snapshot-testing - tool to easily & quickly test screenshots by comparing current version to the recorded one on repository. Allows for good ratio time invested / (issues detected + changes double checked). Here I should expose GraphViewState object, inject it and make couple of screenshots after selectVertex method to integration-test whole app basically. Incoming.
	- SwiftXMLParser - most stared and recently updated swift xml parser. Either it's slow or I did sth incorrectly. Did not bother to deep dive in their problems yet. It was good for quick setup. 
4. Using test icon in xcode tests can be found. All default setup. App main class should be different for units to not bother launching app stuff - potential improvement. GraphMLsParsersPerformanceTests contains simple performance tests that allows to monitor if adding new feature make things slower. GraphViewSnapshotsTests - snapshot tests, for now running on iOS, there is some type issue on MAC OS. Did not dive in -> low gain. Other tests are unit-like. There are 2 parsers - GraphMLFuziParser - uses Fuzi 3rd party and SwiftyXMLGraphMLParser - uses SwiftyXMLParser. 
5. App by default loads "sample.xml" file. Given sets implementation "first" node on launch is random.
6. "Pick new graphML file" allows to select custom file. Graphs/RepoTracked/ contains a few samples.
7. Graph/RepoTracked/PerformanceReport1 contains some of past performance results that led to following choices (xml parsing etc.). 

Next goals: 

1. Double check documentation / verify with other tool / samples for optional values in graphml to make sure there is no issues.
2. Add suport for Ports.
3. Add support for nested graphs.
4. Optimize current algorithm using XMLDocument.
5. Try to asses or quickly POC if going through xml string without any lib could lead to effective time gains.
6. First check direct usage of libxml2.
7. Take advantage of additional parse information to optimize.
