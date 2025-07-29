# AutoCAD LISP Tools

AutoLISP commands I wrote between 2024 and 2025 for quantity take-off (metraj), earthwork and
infrastructure as-built work on Turkish public construction projects (hospital, housing,
road and utility works). Each file is loaded with `APPLOAD` and adds one or more commands.

Rebar take-off LISP commands live in the separate `rebar-takeoff` repository.

## Area & length (`area-length/`)

| File | Command |
|---|---|
| `CalculateArea.lsp` | `CalculateArea` |
| `ExportAreasToCSV.lsp` | `ExportAreasToCSV` |
| `ExportAreasToText.lsp` | `ExportAreasToText` |
| `ExportHatchAreas.lsp` | `ExportHatchAreas` |
| `ExportHatchAreasSimple.lsp` | `ExportHatchAreasSimple` |
| `ExportLengthsToText.lsp` | `ExportLengthsToText` |
| `ExportPerimeterAndAreaToCSV.lsp` | `ExportAreaAndPerimeterToCSV` |
| `ExportPerimetersToCSV.lsp` | `ExportPerimetersToCSV` |

## Earthwork: cut/fill, cross sections, volumes (`earthwork/`)

| File | Command |
|---|---|
| `CALCSECTIONAREA.lsp` | `CALCSECTIONAREA` |
| `CalcExcavationAndFill.lsp` | `CALCEXCAVATIONANDFILL` |
| `CalcVolume.lsp` | `CalcVolume` |
| `CalculateExcavationArea.lsp` | `CalculateExcavationArea` |
| `CalculateVolume.lsp` | `CalculateVolume` |
| `KAZIDOLGUHESAPLA.lsp` | `KAZIDOLGUHESAPLA` |
| `ReadLineData.lsp` | `ReadLineData` |
| `enkesit_hacim_hesap.lsp` | `enkesit_hacim_hesap` |
| `hacimhesap.lsp` | `hacimhesap` |
| `kazidolgu.lsp` | `kazidolgu` |

## Drawing helpers: offset, PEDIT, hatch (`drawing/`)

| File | Command |
|---|---|
| `AutoPEDITtoENK_Y3_K.lsp` | `AutoPEDITtoENK_Y3_K` |
| `BatchOffset.lsp` | `BatchOffset` |
| `BatchOffset_v2.lsp` | `BatchOffset` |
| `BatchPEDIT.lsp` | `BatchPEDIT` |
| `BatchPEDIT_Layer.lsp` | `BatchPEDIT_LayerSync` |
| `BatchPEDITtoENK_Y3_K.lsp` | `BatchPEDITtoENK_Y3_K` |
| `CreatePolyHatch.lsp` | `CreatePolyHatch` |
| `ExtendAndHatch.lsp` | `ExtendAndHatch` |
| `LineToHatch.lsp` | `LineToHatch` |
| `LineToPolyline.lsp` | `LineToPolyline` |
| `OffsetByChoice.lsp` | `OffsetByMeasurement` |
| `OffsetWithDirection.lsp` | `OffsetWithDirection` |
| `ScaleBlocksToPolyline.lsp` | `ScaleBlocksToPolyline` |
| `onetopedit.lsp` | `PEDITLINES` |

## Export to text / CSV / Excel / JSON (`export/`)

| File | Command |
|---|---|
| `EXPORT-JSON.lsp` | `EXPORT-JSON` |
| `EXPORTDIMS.lsp` | `EXPORTDIMS` |
| `EXPORTTEXTCONTENTSTOEXCEL.lsp` | `T2E` |
| `EXPORTTEXTCONTENTSTOTEXT.lsp` | `EXPORTTEXTCONTENTSTOTEXT` |
| `EXPORTTEXTTOCSV.lsp` | `EXPORTTEXTTOCSV` |
| `ExportAttribsToText.lsp` | `ExportAttribsToText` |
| `ExportRooms.lsp` | `ExportRooms` |
| `ExportRoomsDebug.lsp` | `ExportRoomsDebug` |
| `ExportTableToExcel.lsp` | `ExportTableToExcel` |
| `FindKeywordToText.lsp` | `FindKeywordInBlocksToText` |
| `MAHALEXPORT.lsp` | `MAHALEXPORT` |
| `MAHALEXPORT_alt.lsp` | `MAHALEXPORT` |
| `ROOM_DATA_OUT.lsp` | `ROOM_DATA_OUT` |
| `dxf-json.lsp` | `EXPORT-FULL-JSON` |

## Notes

- Files were collected from several working copies and deduplicated by content.
- Third-party LISP files found next to these (JTB World, Andrea Andreetti, Tee Square
  Graphics, Lee Mac-style libraries, and a few without a clear author) are not included.
- Some files use Turkish (Windows-1254) text in prompts.
