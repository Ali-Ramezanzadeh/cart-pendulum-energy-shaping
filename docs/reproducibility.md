# Reproduction guide

## Environment

The model metadata records MATLAB/Simulink R2022b. A compatible MATLAB installation with Simulink is required. The original IDA angle-conversion block calls `wrapToPi`, which is provided by Mapping Toolbox ([MathWorks documentation](https://www.mathworks.com/help/map/ref/wraptopi.html)). Check availability with `which wrapToPi -all` before simulation. The symbolic modeling and LQR sections in the original Live Script also require Symbolic Math Toolbox and Control System Toolbox. Newer-release compatibility has not been tested.

Both saved models contain fixed-step auto integration settings, a 0.001 s step, and a 50 s stop time. These are saved settings, rather than confirmed settings for every historical PNG. The original results display different time windows.

## Open the combined model

From MATLAB, select your extracted repository folder as the current directory, then run:

```matlab
addpath(fullfile(pwd, 'scripts'));
open_project;
```

The helper sets the documented external parameter values and opens `models/IDA_PBC.slx`. It does not simulate, save, or repair the model. Its `q2=1` and `q2_s=2` values correspond to the saved disturbance-recovery setup. The declared initial labels are `[q1,q2,p1,p2]=[pi,q2,0.2,-0.4]`; routing makes the physical initial state `[theta,x,theta_dot,x_dot]=[pi,1,-0.4,0.2]`.

Before any quantitative reproduction, review [source-checks.md](source-checks.md). In particular, use physical state names when specifying initial values. The two velocity labels are reversed relative to the thesis's coordinate ordering. Do not merely paste the manuscript's p values into integrators while assuming they denote the same state components.

## Exploratory model and Live Script

`models/Energy_Shaping.mlx` contains five code paragraphs: physical symbolic modeling, an LQR computation, two desired-potential surface studies, and plotting from existing `out.E`/`out.Trig` signals. It does not call `sim` or save a complete three-scenario result package. The separate `Energy_Shaping.slx` prototype uses `theta_desired` and `K_LQR` from the first two Live Script sections, in addition to the documented physical parameters.

The text companion `scripts/Energy_Shaping.m` preserves the code paragraphs, converts narrative to comments, and omits embedded output/figures. It is intended for reading and version control. Do not assume that Run All recreates the thesis: the last section requires suitable prior simulation output, and exploratory `P=10` differs from the combined model's hardcoded `P=7`.

## Historical scenario definitions

| Scenario | Written q(0) = [theta,x] | Written p(0) | Cart reference | Display window |
|---|---|---|---:|---|
| Local | `[pi/2-1,-0.5]` | `[0.2,-0.2]` | 0 | 0–10 s |
| Swing-up | `[pi,1]` | `[1,-1.5]` | 2 | 0–20 s |
| Pulse recovery | `[pi,1]` | `[0.2,-0.4]` | 2 | 0–50 s |

This table transcribes Chapter 5. It is not a tested replay recipe. Original plots consistently display angular/cart initial velocities in the reverse order to those written p pairs. The pulse function in the saved combined model adds `+3` over 10–10.5 s, `+5` over 15–16 s, and `-12` over 20–20.5 s to cart acceleration after command saturation.

## Build the English report

Keep the `figures` folder beside the LaTeX file. From a terminal in `reports/english`, compile twice:

```powershell
pdflatex -interaction=nonstopmode -halt-on-error thesis-summary.tex
pdflatex -interaction=nonstopmode -halt-on-error thesis-summary.tex
```

The supplied PDF was compiled with existing TeX Live 2026. Standard packages include geometry, Latin Modern, AMS mathematics, TikZ, graphicx, caption, fancyhdr, and hyperref. Bibliography entries are embedded in the main source, so BibTeX is not required. No custom fonts are required for the English report.

The original Persian sources use XeLaTeX, the AUT thesis class, Persian typography, and fonts referenced through `Fonts/`. Third-party font binaries are not included in this repository draft. Obtain and configure those fonts locally if rebuilding the original; the original PDF is already included unchanged. Its bibliography and template are retained as source evidence, including the original compiled `.bbl`.

## Validation status

Repository preparation checked archive integrity, model XML/scripts and wiring, selected algebra, preserved-file hashes, report compilation, ten-page count, and rendered layouts. No MATLAB simulations or helper executions were performed. There is no hardware test, automated scenario reproduction, or raw trajectory dataset in the supplied archive. See [verification.md](verification.md) for the recorded checks.

