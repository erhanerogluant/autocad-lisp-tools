# Project history

Decisions and changes, newest first. Read this before starting new work and add a dated
entry after each working session.

---

## 2026-10-14: Scattered LISP files collected and moved to GitHub

- The LISP files were spread over many project folders and USB backups (hospital, housing,
  infrastructure as-built and road projects). They were deduplicated by content (MD5):
  46 files in four folders (`area-length`, `earthwork`, `drawing`, `export`). All copies with
  the same file name had identical content, so no outdated copy was picked.
- Two variants of the same command are kept separately: `drawing/BatchOffset_v2.lsp` and
  `export/MAHALEXPORT_alt.lsp`.
- **Not included** (other authors or unclear authorship): `TADD.LSP` (Andrea Andreetti),
  `AreaM.lsp` and `BOMLengths.lsp` (JTB World), `TLEN POLYLINE.lsp` (Tee Square Graphics),
  two Lee Mac-style library files, `topla.lsp`, `topla_alan_hafo_cad.lsp`,
  `AutoCadtoExcel.lsp` and an older rebar LISP folder. AutoCAD Express Tools files were
  not taken either.
- Rebar take-off LISP commands (`EXPORTREBAR`, `METRAJ`, ...) are in `rebar-takeoff`.
- The commands were not re-run in AutoCAD for this move; they are the versions used on
  projects in 2024–2025.

**Next steps**
- Add a short usage example or screenshot per folder.
- Collect frequently used commands in a single loader file.
