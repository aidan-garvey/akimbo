```
╔══════╗ ╔═╗  ╔═╗ ╔═════╗  ╔═══════╗  ╔═════╗  ╔══════╗
║ ╔══╗ ║ ║ ║ ╔╝ ║ ╚═╗ ╔═╝  ║ ╔╗ ╔╗ ║  ║ ╔═╗ ║  ║ ╔══╗ ║
║ ╚══╝ ║ ║ ╚═╝ ╔╝   ║ ║   ╔╝ ║║ ║║ ╚╗ ║ ╚═╝ ╚╗ ║ ║  ║ ║
║ ╔══╗ ║ ║ ╔═╗ ╚╗   ║ ║   ║ ╔╝╚═╝╚╗ ║ ║ ╔══╗ ║ ║ ║  ║ ║
║ ║  ║ ║ ║ ║ ╚╗ ║ ╔═╝ ╚═╗ ║ ║     ║ ║ ║ ╚══╝ ║ ║ ╚══╝ ║
╚═╝  ╚═╝ ╚═╝  ╚═╝ ╚═════╝ ╚═╝     ╚═╝ ╚══════╝ ╚══════╝
```
---

# Akimbo

Akimbo is a side-scrolling shooter being developed for the Sega Genesis / Mega Drive. It will have an emphasis on fast-paced action and nice cinematics.

## Project Goals

- At least one fully-polished level, including a boss fight
- Expandable game engine with reusable modules
- Cinematic cutscenes and camera effects
- Weapon power-ups
- At least two different types of enemy, with basic AI
- Custom music and sound effects
- Well-commented code to make it understandable to anyone with basic knowledge of 68000 Assembly

## Running the game

- The game's binary, [akimbo.smd,](akimbo.smd) is included in this repository. You should be able to run it with any Sega Genesis emulator. Or, see the options below for building the game from source.
- [BUILD_SN.BAT](BUILD_SN.BAT) will build the game if you have S.N. Systems' SN 68k assembler and copy it into the same directory as the source files. The output will be a binary file which you can run in an emulator.
- [BUILD_VASM.BAT](BUILD_VASM.BAT) will build the game with the Motorola syntax module for [VASM](http://sun.hasenbraten.de/vasm/) if it is copied into the same directory as the source files. The output will be a binary file which you can run in an emulator.
- If you wish to try building the game with a different assembler, ensure it is built as a pure binary file. You should be able to run this with your emulator of choice.
- The emulator I use is [Gens KMod,](http://gendev.spritesmind.net/page-gensK.html) but any Sega Genesis emulator should run the game once built.
