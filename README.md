# DIKit [![CI](https://github.com/andrewscwei/swift-dikit/workflows/CI/badge.svg)](https://github.com/andrewscwei/swift-dikit/actions/workflows/ci.yml) [![CD](https://github.com/andrewscwei/swift-dikit/workflows/CD/badge.svg)](https://github.com/andrewscwei/swift-dikit/actions/workflows/cd.yml)

DIKit is a dependency injection library for iOS/iPadOS/macOS apps offering a simple interface using the service locator pattern.

## Setup

```sh
# Prepare Ruby environment
$ brew install rbenv ruby-build
$ rbenv install
$ rbenv rehash
$ gem install bundler

# Install fastlane
$ bundle install
```

## Usage

### Adding DIKit to an Existing Xcode App Project

From Xcode, go to **File** > **Swift Packages** > **Add Package Dependency...**, then enter the Git repo url for DIKit: https://github.com/andrewscwei/swift-dikit.

### Adding DIKit to an Existing Xcode App Project as a Local Dependency

Adding DIKit as a local Swift package allows you to modify its source code as you develop your app, having changes take effect immediately during development without the need to commit changes to Git. You are responsible for documenting any API changes you have made to ensure other projects dependent on DIKit can migrate easily.

1. Add DIKit as a submodule to your Xcode project repo (it is recommended to add it to a directory called `Submodules` in the project root):
   ```sh
   $ git submodule add https://github.com/andrewscwei/swift-dikit Submodules/DIKit
   ```
2. In the Xcode project, drag DIKit (the directory containing its `Package.swift` file) to the project navigator (the left panel). If you've previously created a `Submodules` directory to store DIKit (and possibly other submodules your project may depend on), drag DIKit to the `Submodules` group in the navigator.
   > Once dragged, the icon of the DIKit directory should turn into one resembling a package. If you are unable to expand the DIKit directory from the navigator, it is possible you have DIKit open as a project on Xcode in a separate window. In any case, restarting Xcode should resolve the problem.
3. Add DIKit as a library to your app target:
   1. From project settings, select your target, then go to **Build Phases** > **Link Binary With Libraries**. Click on the `+` button and add the DIKit library.

### Adding DIKit to Another Swift Package as a Dependency

In `Package.swift`, add the following to `dependencies` (for all available versions, see [releases](https://github.com/andrewscwei/swift-dikit/releases)):

```swift
dependencies: [
  .package(url: "https://github.com/andrewscwei/swift-dikit.git", from: "<version>")
]
```

## Testing

> Ensure that you have installed all destinations listed in the `Fastfile`. For example, a destination such as `platform=iOS Simulator,OS=18.0,name=iPhone 16 Pro` will require that you have installed the iPhone 16 Pro simulator with iOS 18 in Xcode. In the CI environment, all common simulators should be preinstalled (see [About GitHub Hosted Runners](https://docs.github.com/en/actions/using-github-hosted-runners/using-github-hosted-runners/about-github-hosted-runners)).

```sh
$ bundle exec fastlane test
```
