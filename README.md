# JoltC-BindGen
Bindings generator for [JoltC](https://github.com/ostef/JoltC) using libclang, that tries to produce nicer bindings than a dumb 1:1 C translation.

## Supported languages
Currently the following languages are supported:
* Jai: takes advantage of `#as`, `using` and struct namespacing

## Usage
Example usage:
```
$> joltc-bindgen JoltC/JoltC.h -l jai -I JoltC -D JOLTC_DEBUG_RENDERER -o jolt.jai
```

## Notes
This generator does not handle struct alignment for now, so structs that require specific alignment such as the vector structs must be written by hand.
