# FiiO BTR5 DAC/AMP — Audio Bitrate Stuck at 48kHz on Fedora 42

**Date:** 2025-08-06\
**OS:** Fedora 42\
**Environment:** Daily Driver\
**Category:** Linux, Audio, Hardware

---

## Situation
FiiO BTR5 DAC/AMP would not work over USB cable. Fedora uses PipeWire by default which did not support the use case. After installing `pipewire-pulse`, audio worked but the output bitrate was locked at 48kHz. The BTR5 is capable of significantly higher bitrates.
```bash
pactl info | grep "Sample Specification"
# Output: Default Sample Specification: float32le 2ch 48000Hz
```

## Task
Install PipeWire PulseAudio compatibility layer and configure PipeWire to output at the DAC's full capability.

## Action

**1. Install pipewire-pulse**
Follow Method 1 from the PipeWire PulseAudio documentation.

**2. Check Current Sample Rate**
```bash
pactl info | grep "Sample Specification"
```

**3. Copy PipeWire Config to User Directory**
```bash
mkdir -p ~/.config/pipewire
cp /usr/share/pipewire/pipewire.conf ~/.config/pipewire/
```

**4. Edit Config**
```bash
nano ~/.config/pipewire/pipewire.conf
```

Modify the `context.properties` section:
```
context.properties = {
    default.clock.rate = 192000
    default.clock.quantum = 1024
    default.clock.min-quantum = 32
    default.clock.max-quantum = 2048
}
```

**5. Restart PipeWire**
```bash
systemctl --user restart pipewire pipewire-pulse
```

**6. Verify New Sample Rate**
```bash
pactl info | grep "Sample Specification"
```

## Result
Audio output now running at 192kHz. Noticeable improvement in audio quality through the BTR5.

**Note:** If crackling or dropouts occur, step down the bitrate:
- `192000` — very stable
- `96000` — universal compatibility

---

**Tags:** `linux` `fedora` `pipewire` `pulseaudio` `audio` `dac` `fiio` `btr5` `hardware`
