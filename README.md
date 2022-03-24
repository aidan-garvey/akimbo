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

Akimbo is a side-scrolling shooter being developed for the Sega Genesis/Mega Drive. It will have an emphasis on fast-paced action and nice setpieces and cutscenes.

## Project Goals

- At least one fully-polished level, including a boss fight
- Expandable game engine with reusable modules
- Cinematic cutscenes and camera effects
- Weapon power-ups
- At least two different types of enemy, with basic AI
- Custom music and sound effects
- Well-commented code to make it understandable to anyone with basic knowledge of 68000 Assembly

## Running the game

- I have built the game with S.N. Systems Software's SN 68k (asm68k.exe, patched by Nemesis). To my knowledge, I cannot legally include a link to that assembler in this repository. In the near future, I would like to add instructions for building the game with a different, free assembler.
- The included build.bat file is what I use to assemble the game. It will only work for you if you have the same assembler as me, in the same directory as the project.
- The emulator I use is [Gens KMod,](http://gendev.spritesmind.net/page-gensK.html) but any Sega Genesis emulator should run the game once built.
