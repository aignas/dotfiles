#!/usr/bin/env python
"""Move photos from the SD card to the date-tagged destination directory.
"""

from dataclasses import dataclass
import shutil
import pathlib
import sys
import argparse

@dataclass
class Args:
    src: pathlib.Path
    dst: pathlib.Path
    dry_run: bool = True

def _parse_args(args: list | None = None) -> Args:
    parser = argparse.ArgumentParser(
        description=__doc__,
    )
    parser.add_argument(
        "src",
        type=pathlib.Path,
    )
    parser.add_argument(
        "dst",
        type=pathlib.Path,
    )
    parser.add_argument(
        "--copy",
        action=argparse.BooleanOptionalAction,
    )
    args = parser.parse_args(args or sys.argv[1:])

    assert args.src.exists()

    return Args(
        src=args.src.expanduser().resolve(),
        dst=args.dst.expanduser().resolve(),
        dry_run=not args.copy,
    )

def _info(msg: str) -> None:
    print(f"[INFO]: {msg}")

def _copy(src: pathlib.Path, dst: pathlib.Path, *, dry_run: bool=True) -> None:
    if dry_run:
        _info(f"DR {src} -> {dst}")
        return

    _info(f"{src} -> {dst}")

    dst.parent.mkdir(mode=0o755, parents=True, exist_ok=True)
    shutil.copy2(src, dst)

def copy_photos(*, src: pathlib.Path, dst: pathlib.Path, dry_run: bool=True) -> None:
    _info("Copying photos...")
    dcim = src / "DCIM"

    for src_dir in dcim.glob("*"):
        _info(f"Processing {src_dir}...")

        name = src_dir.name
        # The name is like
        # 10030326, which is: xxxYMMDD, where:
        # * xxx is just a counter that gets incremented
        # * Y is the year last digit
        # * MM is the month
        # * DD is the day

        # TODO @aignas 2023-05-07: maybe I can have a better naming in the camera itself?
        xxx, y, mm, dd = name[0:3], name[3], name[4:6], name[6:]
        assert len(dd) == 2, "The day format should be no more than 2 days"

        for file in src_dir.glob("*.ARW"):
            _copy(file, dst / f"202{y}-{mm}-{dd}-TODO" / file.name, dry_run = dry_run)

def main():
    args = _parse_args()
    copy_photos(src=args.src, dst=args.dst, dry_run=args.dry_run)

if __name__ == "__main__":
    main()
