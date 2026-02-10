#!/usr/bin/env python3
"""
Create a tiny, valid PDF with a single page and a single line of text.

Used by DESKTOP_MODE=sim so developers can open the "printed PDF" in Preview
and confirm the flow without having AutoStacja installed.
"""

from __future__ import annotations

import os
import sys
from pathlib import Path


def _escape_pdf_text(s: str) -> str:
    # Escape backslash and parentheses in PDF literal strings.
    return s.replace("\\", "\\\\").replace("(", "\\(").replace(")", "\\)")


def write_dummy_pdf(path: Path, text: str) -> None:
    text = _escape_pdf_text(text)
    stream = f"BT /F1 18 Tf 72 720 Td ({text}) Tj ET"
    stream_bytes = stream.encode("latin-1")

    objects: list[bytes] = [
        b"<< /Type /Catalog /Pages 2 0 R >>",
        b"<< /Type /Pages /Kids [3 0 R] /Count 1 >>",
        b"<< /Type /Page /Parent 2 0 R /MediaBox [0 0 612 792] "
        b"/Resources << /Font << /F1 4 0 R >> >> /Contents 5 0 R >>",
        b"<< /Type /Font /Subtype /Type1 /BaseFont /Helvetica >>",
        b"<< /Length %d >>\nstream\n%s\nendstream" % (len(stream_bytes), stream_bytes),
    ]

    out = bytearray()
    out += b"%PDF-1.4\n%\xe2\xe3\xcf\xd3\n"

    offsets: list[int] = [0]
    for i, obj in enumerate(objects, start=1):
        offsets.append(len(out))
        out += f"{i} 0 obj\n".encode("ascii")
        out += obj + b"\nendobj\n"

    xref_start = len(out)
    out += f"xref\n0 {len(objects) + 1}\n".encode("ascii")
    out += b"0000000000 65535 f \n"
    for off in offsets[1:]:
        out += f"{off:010d} 00000 n \n".encode("ascii")

    out += b"trailer\n"
    out += f"<< /Size {len(objects) + 1} /Root 1 0 R >>\n".encode("ascii")
    out += b"startxref\n"
    out += f"{xref_start}\n%%EOF\n".encode("ascii")

    path.parent.mkdir(parents=True, exist_ok=True)
    path.write_bytes(out)


def main(argv: list[str]) -> int:
    if len(argv) < 2:
        print("Usage: write_dummy_pdf.py <output.pdf> [text...]", file=sys.stderr)
        return 2
    out_path = Path(argv[1])
    text = " ".join(argv[2:]) if len(argv) > 2 else "SIMULATED PDF"
    write_dummy_pdf(out_path, text)
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))

