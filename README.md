# Wallet
repo for testing IncrementalUI a Elm architecture in Swift

## Why Wallet?
For lack of a better idea, I was gonna implement a "bitcoin wallet", or at least the UI. I wanna get inspired by Bread wallet for iOS. Subject to change. Especially subject to me leaving this unfinished as all of my other side projects.

I have since changed the sample app Im implementing several times and am currently starting work on "a smart home app that provides an automated airbnb renting experience with cryptocurrency payments". I wont move to my new flat until fall 2018 and I want the whole app to be ready by 2020 :D, i.e. dont put any significance on this. This code is likely to be thrown away shortly.

## Timetravel
Run the app on iPhone X simulator. On other devices, you can see an imageView with the notch :) This is because theres a timetravel feature in progress. It worked before with a slider but now doesnt. I think theres a minor bug with TimeTravelState.selectedIndex, but I got bored and have since focused my attention elsewhere.

## TodosApp
Since the "smart home" app doesnt feature almost any code yet, also look at the "Todos" app.

## Architecture
In comparison to Chris Eidhof's repo https://github.com/chriseidhof/laufpark-stechlin, I tried to stay as close as possible to the native features of CocoaTouch (storyboards, viewcontroller heavy design). I got rid of IBoxes, giving up some of the composability of pure functions. This architecture feels more like "MVVM without the VM objects", with business logic in a redux store but the rest being very iOS native. Theres no ownership between the Driver (Store) and the View layer. They sort of run in parallel. The Driver a is a way to inject logic into ViewControllers, https://github.com/symentis/Corridor is used for DI. It is way too early to form any sort of opinion on this architecture. Feedback is very much appreciated.
