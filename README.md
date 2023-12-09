# nes-hello-world
Hello world examples in NES 6502 assembler for ca65/ld65

The NES (Nintendo Entertainment System), known as famicom in Japan, cannot handle text.
Instead, it is made to handle graphics.

Because showing the text "hello, world!" requires complex handling of grapchis, a different approach is usually used as "NES hello world".

## hello-background-color
The most common approach is to just change the background color of the screen.
![hello-background-color.nes in the emulator FCEUX](screenshots/hello-background-color-FCEUX.png)
For that, the background color is set to index 0x29 and tiles (pattern tables) are filled with index 0.
![hello-background-color.nes in FCEUX's PPU viewer](screenshots/hello-background-color-FCEUX-PPU-viewer.png)
- See the source code [hello-background-color.asm](hello-background-color/src/hello-background-color.asm)

## hello-background-tiles
Then, we can start placing background tiles.
![hello-background-tiles.nes in the emulator mesen](screenshots/hello-background-tiles-mesen.png)
- Background color: black (0x0F)
- Palette 0, color 1: white (0x30)
- Pattern table 0
  - tile 0: filled with zeroes
  - tile 1: filled with ones
  - rest tiles: filled with zeroes

![hello-background-tiles.nes in mesen's tile viewer](screenshots/hello-background-tiles-mesen-tile-viewer.png)
![hello-background-tiles.nes in mesen's tilemap viewer](screenshots/hello-background-tiles-mesen-tilemap-viewer.png)
- See the source code [hello-background-tiles](hello-background-tiles/src/hello-background-tiles.asm)

# Special thanks to
- https://www.youtube.com/@NesHacker
- https://www.youtube.com/@DisplacedGamers
- https://famicom.party
- https://www.nesdev.org/wiki/Nesdev_Wiki
  - https://discord.gg/JSG4kuF8EK (including people in the discord channel)
