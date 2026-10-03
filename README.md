# octabam2elemod

[sambanks/octabam](https://github.com/sambanks/octabam)'s Octatrack modules as
[elekloader](https://github.com/irpina/elekloader) mods (`.elemod`), for the
Octatrack MKI and MKII on **OS 1.40C**.

- **What they are.** 34 mods, converted from octabam commit `363861e` (30 Sep
  2026) by elekloader's converter.
- **Where they are.** The files are in this repository's
  [releases](https://github.com/irpina/octabam2elemod/releases). They are also in
  the mod shop on elekloader's [web page](https://irpina.github.io/elekloader/).
- **Who wrote them.** The code is octabam's and its contributors': Sam Banks,
  Tim Hastie, Mark Roberts (octemu), Bryan T, repeat98 and bkkbrls-del. This
  repository only converts it, and makes no claim on it. Problems with a mod's
  behaviour that also happen in octabam's own build belong upstream.

> **None of these mods has been run on an Octatrack yet.** They pass the
> checks below, in octabam's own emulator, but that is not a unit. Keep your
> stock OS file, and read [Recovery](#recovery) before you flash.

## Use them

1. Get your stock OS from Elektron: `OCTATRACK_OS1.40C.syx` (or the `.zip` it
   comes in).
2. Open elekloader, either the [web page](https://irpina.github.io/elekloader/)
   or the desktop app (0.4.0 or later). Add the stock file, then add mods from
   the shop or from the `.elemod` files here. Then build.
3. Flash the `.syx` it gives you as any OS update, or put the `.bin` on the
   card.

Every mod here needs the Octatrack core (`core-ot-0.1.elemod`). elekloader
includes it and ticks it for you.

### Which USB mod

Take at most **one** of these. Each carries what it needs, so elekloader
refuses two together.

| you want | take |
|---|---|
| USB MIDI only | `octabam-usb-midi` |
| the Octatrack as a USB audio **input** to the computer (it records the OT), with USB MIDI | one `octabam-usb-audio-out-*`, and add `octabam-usb-crossbar` beside it |
| a USB audio **interface** both ways (the computer also plays into the OT's inputs), with USB MIDI | one `octabam-usb-io-*`: it includes USB CROSSBAR |

The `usb-io` mods take **SPATIALIZER** off both FX menus. Its DSP code space
holds the code that brings the computer's audio in, as in octabam's own
`usb-io` builds. A part that had SPATIALIZER shows NONE there, and that slot
passes its audio through unprocessed.

USB audio is class compliant (UAC2, 44.1 kHz, 24-bit). octabam has measured it
on macOS. It has not been measured with Windows or Linux hosts.

### Other combinations

Everything else combines freely, with one exception: MIDI SCENES and SCENES
P2 keep data in the same bytes of every Part, so they are refused together
(octabam refuses the same pair).

## The mods

| file | what it does | from |
|---|---|---|
| `octabam-cc-feedback` | every knob change goes out as its MIDI CC, so a controller's encoders follow the unit | sambanks |
| `octabam-cc-map` | MIDI CC 62-67 drive FX2's page-2 knobs, 68-73 FX1's | sambanks |
| `octabam-direct-jump` | CHAIN AFTER: DIRECT. A pattern change lands at the next step, the step count continuing (Analog Four / Rytm direct jump) | Tim Hastie |
| `octabam-flex-seekbind` | a FLEX re-bind of the same sample seeks in place instead of starting a new note | sambanks |
| `octabam-flex-seekbind-ctr` | pairs with FLEX SEEK BIND: such a re-bind keeps the voice's bind counter | sambanks |
| `octabam-lofi-amf-fix` | fixes the stock LO-FI effect's AMF knob | Bryan T |
| `octabam-midi-scenes` | scene locks from MIDI: hold, morph, save, reload, clear, copy, paste | bkkbrls-del (midisc) |
| `octabam-quantizer` | PROJECT > CONTROL > SEQUENCER > SCALE: PTCH and the CHROMATIC keys follow one of 24 scales, with a root and a synth glide | Tim Hastie |
| `octabam-recorder-hold` | a FLEX voice reading past the end of a recording holds the last sample instead of dropping to zero | sambanks |
| `octabam-recorder-spacing` | a fixed-RLEN recording lasts exactly until the next arm | sambanks |
| `octabam-repitch` | TSTR REPITCH: follow the project tempo by playback speed, without grains | repeat98 |
| `octabam-rlen-plen` | RLEN PLEN: one loop of the track's pattern, so TRIG ONE + QREC PLEN records the next pass and stops | sambanks |
| `octabam-scenes-p2` | scene locks and the crossfader reach FX1/FX2 page 2 | sambanks |
| `octabam-synth` | a FLEX track whose sample is named SYNTH* plays a two-operator FM voice | Tim Hastie |
| `octabam-tuner` | UP + TEMPO opens a tuner for the current audio track | Tim Hastie |
| `octabam-usb-midi` | class-compliant USB MIDI in and out, mirroring the DIN ports | Mark Roberts (octemu) |
| `octabam-usb-crossbar` | gives the USB controller first claim on memory, which cures lost USB audio packet tails | Bryan T |
| `octabam-usb-audio-out-tracks-main-cue` | 20 channels to the computer: the eight tracks in stereo (post-FX, pre-fader), MAIN and CUE | Mark Roberts, Bryan T |
| `octabam-usb-audio-out-tracks` | 16 channels: the eight tracks in stereo | Mark Roberts |
| `octabam-usb-audio-out-main-cue` | 4 channels: MAIN and CUE | Mark Roberts, Bryan T |
| `octabam-usb-audio-out-main` | 2 channels: MAIN | Mark Roberts |
| `octabam-usb-audio-out-master` | 2 channels: track 8, the master track | Mark Roberts, Sam Banks |
| `octabam-usb-io-<out>-<in>` (12) | a USB audio out layout above (`tracks-main-cue`, `tracks`, `main-cue` or `main`), plus the computer's audio into inputs A/B (`ab`), C/D (`cd`) or A to D (`abcd`, 4 channels). While the computer's stream is closed, the inputs are the jacks again. | Mark Roberts, Bryan T |

Each file is named `octabam-<module>-363861e.elemod`. The audio-out mods each
include USB MIDI.

## How they were made, and what was checked

elekloader's converter (`python -m elekloader.sdk.octabam`) reads octabam's
module manifests. It turns each module into a linkable mod for the
Octatrack's core, and checks the result against octabam's own account of the
bytes: every cave and unit equals its source linked by GNU ld at the same
address, and every patch site holds what octabam's build would write there.

- **USB AUDIO OUT.** octabam writes the USB device descriptor's class in
  place, inside the bootloader copy that elekloader never lets a mod change.
  These mods serve a copy of the 18-byte descriptor from their own memory
  instead, so the computer reads the same bytes and the bootloader copy stays
  stock.
- **USB IO.** These are octabam's `usb-io-*` remixes, each converted as one mod.
  The bytes octabam's build writes beyond its modules (the DSP code in
  SPATIALIZER's space, its hook, the FX menus) are taken from octabam's own
  build of that remix. Linked with the core, each one's OS image equals that
  build in every byte except six: the pointer to the descriptor copy, and the
  three bytes it serves.
- **The USB gates.** octabam's own USB gates pass on elekloader builds of all
  17 USB audio mods, in octabam's ColdFire emulator:
  - `verify_usb`: enumeration, every channel carries its own source, counters,
    full speed, MIDI both ways;
  - `verify_usb_in` (the 12 `usb-io`): the computer's samples reach the inputs
    bit-exact, and the jacks return when the stream closes.

What this cannot show is anything a real unit adds: timing, a real host,
long sessions. That is what a first flash will tell.

To make them yourself, see [`convert.sh`](convert.sh).

## Recovery

If a build misbehaves, go back to stock:

1. Hold **FUNC** while powering on, for the startup menu.
2. Press **TRIG 3** (MIDI UPGRADE).
3. Send the stock `OCTATRACK_OS1.40C.syx` over 5-pin MIDI (not USB).

elekloader never changes the bootloader.

## Licence

MIT, from the code it is built from: octabam (Sam Banks), octatrick-modules
(Tim Hastie) and octemu (Mark Roberts). Every notice is in [LICENSE](LICENSE).
No file here contains Elektron firmware. Octatrack and Elektron are
trademarks of Elektron Music Machines MAV AB. Nothing here is made or
endorsed by Elektron.
