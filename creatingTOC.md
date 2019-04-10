# How to create TOC entries in Mark Down

- [The format](#the-format)
- [Existing Title](#existing-title)
- [Issues](#issues)

The MD code for the previous TOC is the following:

``` md
- [The format](#the-format)
- [Existing Title](#existing-title)
- [Issues](#issues)
```

## The format

Each TOC entry must have the following format:

``` md
[Text for that entry](#existing-title)
```

- The `Text for that entry` can be anything whereas the `existing-title` must
  be an exiting title.
- The `#id selector` text must be in *lowercase*.
- In the `#id selector` text you must replace space characters with `-`.

## Existing Title

This will be included in the TOC

## Issues

- It is unknown how to create TOC entries for titles with the same text.
