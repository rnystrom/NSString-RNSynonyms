NSString+RNSynonyms
===

A fast and lightweight solution to finding synonyms for words, built as a category on NSString.

## Installation

Drag and drop the .h/.m files for <code>NSString+RNSynonyms</code> into your project. I'll setup a podspec if someone opens an issue for it.

## API Key

Grab an API key from Big Huge Labs [here](http://words.bighugelabs.com/api.php). Explore the docs, send me some pull requests!

## Usage

To find all possible synonyms for a word.

```objc
NSString *word = @"developer";
[word findSynonymsWithCompletion:^(NSArray *words, NSError *error) {
    // "creator","photographic equipment"
}];
```

To find all possible synonyms for a word based on its usage. Usages can be either

- noun
- verb
- adjective
- adverb

```objc
NSString *word = @"phone";
[word findSynonymsWithUsage:@"verb" completion:^(NSArray *words, NSError *error) {
    // "call","telephone","call up","ring","telecommunicate"
}];
```

To find all possible synonyms for a word.

```objc
NSString *word = @"objective";
NSString *sentence = @"The important thing to remember about WWDC is that it is a developer conference.";
[word findSynonymsInContextSentence:sentence completion:^(NSArray *words, NSError *error) {
    // "of import","significant","crucial","authoritative"
}];
```

## License

Licensed under MIT, see LICENSE.