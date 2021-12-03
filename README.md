# abfi

**Allegro Bitmap Font Importer** plugin for Godot 3.2+.

![Diagram](./.images/diagram.png)

abfi provides an importer for [BitmapFont](https://docs.godotengine.org/en/3.2/classes/class_bitmapfont.html) resources from plain PNG images. It aims to implement [Allegro](https://liballeg.org/)'s [`al_grab_font_from_bitmap`](https://liballeg.org/a5docs/trunk/font.html#al_grab_font_from_bitmap) in Godot.

This allows you to create bitmap fonts in a normal image editor, which is particularly useful for pixel fonts and such. No [BMFont](https://www.angelcode.com/products/bmfont/) required.

## Image format

> This is heavily adapted from [Allegro's documentation](https://liballeg.org/a5docs/trunk/font.html#al_grab_font_from_bitmap).

Let's explain this by example. Here's a valid (albeit tiny) PNG pixel font for the glyphs `123` and `ABC`:

![Example](./.images/example.png)

Now, let's look at how the importer interprets it. Here's that image scaled-up:

![Example at 16x scale](./.images/example-large.png)

* The top-leftmost pixel defines the **delimiter colour**. Every outside pixel in the image must also be this colour.
  * In the PNG above, the delimiter colour is mid-grey (`#7f7f7f`).
  * This **shouldn't be transparent**. Instead - unlike the above - your glyphs should have transparent backgrounds, because the backgrounds will be drawn too! We've just used black so you can see it on the page.
* Glyphs are read in left-to-right, then top-to-bottom.
  * You'll probably want to arrange the glyphs in their Unicode ordering; you'll see why below.
* Glyphs can vary in width, but must be the **same height**.
* Every row of glyphs must be separated by a horizontal line with the delimiter colour.
* It's fine to put as much delimiter colour padding as you like between glyphs on the same row.

Even with all of the above, the importer still doesn't know which glyphs correspond to which characters. This leads us onto...

## Plugin options

Select a PNG image in the 'FileSystem' tab, then select the 'Import' tab.

Then, select 'BitmapFont (Allegro)' from the dropdown:

![UI](./.images/ui.png)

Each pair of strings in 'Ranges' defines an **inclusive** range of Unicode characters to import from the image. So, in the above screenshot, `123` and `ABC` are imported - meaning these settings would correctly import the font we used as an example.

---

'Letter Spacing' is useful for padding out characters or pushing them together (if set to a negative value). The latter is especially useful for reducing the spacing on fonts which have an outline:

![Letter spacing demonstration with outline font](./.images/spacing.png)

---

The other options (from 'Mipmaps' down) correspond to the [texture creation flags](https://docs.godotengine.org/en/3.2/classes/class_texture.html#enum-texture-flags).

Once everything's configured, hit 'Reimport'. Hopefully, that should be it, and you can now use your PNG as a font!

Keep an eye on the console for errors; if the image isn't correctly formatted - or your the number of glyphs specified doesn't match it - you'll be warned about it there.

> Note: apologies, I'm aware the interface here is a bit janky. It doesn't seem possible to provide detailed property hints for importer options at the moment.

## Development

Currently, there are no unit tests. If this plugin gets any bigger, [Gut](https://github.com/bitwes/Gut) may be employed.

### Release procedure

* Manually test:
  * Copy `addons/abfi` into a fresh Godot project, and load [the example font](./.images/example.png).
  * Ensure successful import for the example ranges: `1`-`3`, `A`-`C`.
  * Ensure errors are shown for `2`-`3` and `A`-`B`.
  * Check letter spacing works as expected (both positive and negative).
  * Check each of the flags works as expected.
* Bump the version in `addons/abfi/plugin.cfg`.
  * Commit with message `vX.Y.Z`.
  * Add a tag, also `vX.Y.Z`.
  * Note the commit hash.
* [Edit the asset](https://godotengine.org/asset-library/asset/598/edit), updating the commit hash.

## License

[MIT](./LICENSE)
