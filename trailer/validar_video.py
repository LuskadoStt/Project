"""Validate the final MP4 container and decode every video/audio packet."""
import json
import subprocess
from fractions import Fraction
from pathlib import Path

folder = Path(__file__).resolve().parent
video = folder / "Museu-Entre-na-Arte-Trailer.mp4"
probe = subprocess.run(
    ["ffprobe", "-v", "error", "-show_format", "-show_streams", "-of", "json", str(video)],
    check=True, capture_output=True, text=True,
)
metadata = json.loads(probe.stdout)
picture = next(s for s in metadata["streams"] if s["codec_type"] == "video")
audio = next(s for s in metadata["streams"] if s["codec_type"] == "audio")
duration = float(metadata["format"]["duration"])
assert abs(duration - 49) < .05, duration
assert (picture["width"], picture["height"]) == (1280, 720)
assert picture["codec_name"] == "h264"
assert picture["pix_fmt"] == "yuv420p"
assert Fraction(picture["avg_frame_rate"]) == 60
assert int(picture["nb_frames"]) == 2940
assert audio["codec_name"] == "aac" and audio["channels"] == 2
assert abs(float(audio["duration"]) - duration) < .05
subprocess.run(
    ["ffmpeg", "-hide_banner", "-v", "error", "-xerror", "-i", str(video),
     "-map", "0:v:0", "-map", "0:a:0", "-f", "null", "-"],
    check=True,
)
report = {
    "arquivo": video.name,
    "aprovado": True,
    "duracao_segundos": duration,
    "resolucao": [picture["width"], picture["height"]],
    "fps": float(Fraction(picture["avg_frame_rate"])),
    "frames": int(picture["nb_frames"]),
    "video_codec": picture["codec_name"],
    "pixel_format": picture["pix_fmt"],
    "audio_codec": audio["codec_name"],
    "audio_canais": audio["channels"],
    "audio_sample_rate": int(audio["sample_rate"]),
    "bytes": video.stat().st_size,
    "decodificacao_completa_sem_erros": True,
    "captura_de_gameplay": False,
}
(folder / "validacao-video.json").write_text(json.dumps(report, ensure_ascii=False, indent=2) + "\n", encoding="utf-8")
print(json.dumps(report, ensure_ascii=False, indent=2))
