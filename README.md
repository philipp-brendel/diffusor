<h1><img src="Assets/icon_32x32@2x.png" alt="Diffusor logo"> Diffusor</h1>

Explore various image processing filters with this simple macOS app.

## What's it about?

Image processing is the process of filtering images using algorithms to
improve their quality, determine their features, or create art.

Diffusor provides a few filters that employ algorithms based on the work
of [Joachim Weickert](https://www.mia.uni-saarland.de/weickert/index.shtml),
specifically *edge enhancing diffusion* and *coherence enhancing diffusion*.

## Usage

Compile the application using Xcode. 

Run the application, choose a filter from the dropdown and drop some image files
onto the application's window.

Warning: The image processing code is not particularly optimized for
performance and may take a while to process larger images. Best stick to images
with lower resolutions to get quick results.

## For developers

The parts of the application that perform the actual image processing are
written in pure C, operating on grayscale floating point image buffers whose
values range from 0 to 255. The Swift portion of the code provides functions
to convert this data structure to and from `NSImage`. To add your own filter,
write code that follows this convention, wrap it into an implementation of 
the `Filter` protocol and add that to the list of filters in the function
`standardFilters()`.

## Contribute

Some ideas for evolving this project:

- Most filters have a number of parameters. Allow the user to set these
parameters through the user interface.
- Sessions are currently lost when the application is closed; images are
stored in temporary storage. Implement persistent sessions/documents.
- Come up with a plugin architecture allowing users to add new filters
dynamically instead of having to compile them with the application.
