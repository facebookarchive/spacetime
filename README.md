# spacetime
spacetime is an experimental library for individually transforming parts of layers in real time. With the right transforms, you can make everything from a text view split in half to a cylindrical web view.

**Warning:** Unlike most Facebook open source, spacetime is an experimental library and hasn't been used in production. Make sure to test extensively if you want to use it, and file issues on anything you see.

## Usage
To use spacetime, create a `STCMeshLayer` or `STCMeshView` and add your content to its `contentLayer` or `contentView`. Then set the `instanceCount`, `instanceBounds`, and `instancePositions` to split the content into a number of pieces and individually position them. For more complex use cases, use `instanceTransforms` to individually transform each piece.

An example that shows an image split with a gap in the center:

```objective-c
UIImage *image = [UIImage imageNamed:@"example"];
UIImageView *imageView = [[UIImageView alloc] initWithImage:image];

CGRect meshFrame = CGRectMake(0, 0, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds) * 1.5);
STCMeshView *meshView = [[STCMeshView alloc] initWithFrame:meshFrame];
meshView.instanceCount = 2;
CGRect instanceBounds[] = {
    CGRectMake(0, 0, CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds) / 2),
    CGRectMake(0, CGRectGetMidY(imageView.bounds), CGRectGetWidth(imageView.bounds), CGRectGetHeight(imageView.bounds) / 2),
};
meshView.instanceBounds = instanceBounds;
CGPoint instancePositions[] = {
    CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetHeight(imageView.bounds) / 4),
    CGPointMake(CGRectGetMidX(imageView.bounds), CGRectGetHeight(imageView.bounds) / 4 * 5),
};
meshView.instancePositions = instancePositions;
[meshView.contentView addSubview:imageView];
```

## How it works
spacetime is a careful combination two little-known features of CoreAnimation (QuartzCore): replicator layers and the time hierarchy. The basics of both are explained here, but Apple's [Core Animation Programming Guide](https://developer.apple.com/library/ios/documentation/Cocoa/Conceptual/CoreAnimation_guide/Introduction/Introduction.html#//apple_ref/doc/uid/TP40004514) has a more complete reference.

Replicator layers (`CAReplicatorLayer`) are a special type of `CALayer` that duplicate their content a configurable number of times. For example, a tiled background could use a replicator layer to avoid creating an image big enough to fill the whole screen. However, replicator layers are limited in how each replicated copy can be different from the others: they always show the same content, and the same transform is applied between each copy. There's no way to show different parts of the same layer or transform more than one duplicate in arbitrary ways.

The time hierarchy is animations' temporal equivalent to the spacial layer hierarchy. That is, just like every layer has a position and size offset from its parent, each animation has a speed and point in time relative to its parent animation. For example, an animation with a speed of `2` (200%) in an animation group with a speed of `0.25` (25%) will run at half speed (`0.5` or 50%). Interesting, layers are also a part of the time hierarchy, by also conforming to the `CAMediaTiming` protocol. So just like setting the `speed` or `timeOffset` of a `CAAnimation`, you can set it on a `CALayer` and it will apply to that layer's sublayers and animations.

One of the more interesting properties on `CAReplicatorLayer` is `instanceDelay`, which lets you adjust the time offset applied to each replicated copy. Usually, this is used to make a wave effect: the first copy is animated back and forth, and the copies behind do the same animation after a delay. spacetime uses this property in a more creative way. First, it creates a replicator layer and sets the `instanceDelay` to a big number, so the replicated content layers' timespace is far in the future. Then, it adds animations to the single content layer that change various animatable properties, but only apply far in the future. Because each replicated instance is offset a different multiple of `instanceDelay` into the future, it's possible to individually modify any animatable properties of each instance by applying an animation targeted at the right block of time in the future.

There's one limitation, though. Because the later copies are shift far into the future, any normal animations attached to the content layer won't start in the copies for a very long time. To fix that, spacetime inserts another replicator layer into the hierarchy just above the content layer with an inverted `instanceDelay` to bring them back to the present.

## Installation
There are two options:

 1. spacetime is available as `spacetime` in [Cocoapods](http://cocoapods.org).
 2. Manually add the files into your Xcode project. Slightly simpler, but updates are also manual.

## License
spacetime is BSD-licensed. We also provide an additional patent grant.

