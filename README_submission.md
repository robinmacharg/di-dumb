#  Dependency Injection Coding Task - Submission Notes

## Examplar app

An example app that makes use of the framework is included.  I've eschewed dependency management (e.g. Coooapods) and simply included the framework project directly in the examplar app.

Tests are on a per-project basis: DI framework tests lie within that project and likewise app tests lie within the app project.

To run the app:
- Open the `.xcodeproj` project
- Select the framework build scheme and build that
- Select the app build scheme and run that.

To run the DI tests:
- Open the `.xcodeproj` project
- Select the framework build scheme
- Run all tests (CMD-U)

## Design

There are several definitions of DI, increasing in complexity:

1. Initializer-based Dependency Injection
2. Property-based Dependency Injection
3. Service-Locator based Dependency Injection
4. Property Wrapper-based Dependency Injection

Options 1 & 2 don't really require a framework to implement: simply provide arguments to `init()` or make dependency properties `public`.  I opted for option 3. My experience with DI has been at the level of options 1 & 2 until now, so I reached for Google.  The provided solution is based, with modification, on discussion found (here)[https://quickbirdstudios.com/blog/swift-dependency-injection-service-locators/].  This provided a Container-based solution that supported instance and factory-based dependency injection via configurable dependency containers.

Option 4 uses new Swift features that I've not had time to play with as yet, but look to provide - with caveats - a clear way to declare injectable properties.

The simplest, most likely correct solution to this problem is to use a predefined library such as (Swinject)[https://github.com/Swinject/Swinject] or (Resolver)[https://github.com/hmlongco/Resolver].  That's not what was asked for so I took the middle ground - embrace and extend.

## Architecture

The DI framework is based on discussion and associated playground


## Using the framework in your own project

### Include the framework in your project

### Incorporate the framework in your code



## References

* https://betterprogramming.pub/taking-swift-dependency-injection-to-the-next-level-b71114c6a9c6
* 

## TODO

- Change Result<> to ServiceType?
- Explore circular dependencies
- Explore property decorators
- Docs
