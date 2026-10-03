# Source consistency checks

These findings come from read-only inspection of the supplied thesis and saved models. They qualify the relationship between the implementation and its theoretical description; they are not a claim that the recorded simulations are unstable. Original binaries and thesis sources are preserved unchanged.

| Finding | Source evidence | Consequence |
|---|---|---|
| Angle/input sign | Chapter 4 derives `theta_ddot=(g/l)sin(theta)+(cos(theta)/l)u`, then uses `-b*cos(theta)u` in its compact model | Use one coordinate convention consistently; the English report adopts the saved reduced model's negative coupling |
| Initial velocity labels | IDA subsystem 642 routes `p1_0` to cart-velocity integrator SID 20 and `p2_0` to angular-velocity integrator SID 503 | The physical saved initial state is `[pi,1,-0.4,0.2]`; the text/plots must not be silently treated as identical |
| Disturbance channel | The three-pulse function enters `d_f`, then cart-acceleration sum SID 562 | Saved disturbances act on cart acceleration; Chapter 5 describes angular acceleration |
| Reduced plant/force | Saturated `u` enters `G*u+S`; force-conversion chart 127 feeds outputs/scopes and uses the earlier, opposite angle convention | Reconstructed force does not drive a force-input plant and its sign convention needs reconciliation; ±10 auxiliary clipping is not a guaranteed ±10 N actuator bound |
| Logarithm and gradient | Chart 26 multiplies MATLAB natural log by `2.302585`; analytic gradient chart 47 omits that multiplier | The gradient used in the controller does not match the coded potential |
| Energy display | Diagnostic matrix block SID 759 uses `Md`, whereas the stated kinetic energy uses `inv(Md)` | The displayed `Hd` is not the stated inverse-inertia Hamiltonian and cannot certify its decrease |
| Switching settings | Active delta is 0.03; original overview image shows 0.07; dwell/power logic is commented out | Describe active angle-only smoothstep; do not claim a velocity gate or dwell controller |
| Potential matching | Printed `Md` and closed-form `z` give nonzero projected potential residual | A strict energy minimum alone does not establish matching or a verified IDA-PBC Lyapunov function |
| Gyroscopic matching | Thesis sets `J2=0`; no gyroscopic term is active in the controller | Complete kinetic matching still requires verification |
| Live Script study settings | Surface study uses `P=10`, controller block uses `P=7`; final plotting reads existing `out` | The Live Script is exploratory and does not reproduce all scenarios in one run |

## Selected algebra checks

The programmed inverse of `Md` agrees with numerical matrix inversion at the checked sample point to approximately `1.1e-15`; the analytic derivative of `Md` agrees with a finite-difference check to approximately `3e-11`. These checks support those particular expressions, rather than the full controller.

At `theta=0.2`, `x=1.2`, `xref=2` and the saved design constants, differentiating the coded potential gives approximately `54.4859`, while the analytic first-component potential derivative used by the controller gives `47.4586`. Their difference is approximately `-7.0273`. With `p=[0.2,-0.4]`, the diagnostic's kinetic term is approximately `0.03607`, whereas the inverse-inertia term is `0.70191`. These are independent algebra checks, not simulation measurements.

For the printed formula, take `L=[1,b*cos(theta)]`. Its projected potential residual is `L*(grad(V)-Md*grad(Vd)) = P*z*k*b*cos(theta)`, generally nonzero. The general integral and printed closed form of `z` also require reconciliation. The printed potential still has a strict local minimum; the failure to establish matching is a separate issue.

The chosen `m22^0=k=0.2` misses the manuscript's stricter sufficient inequality `m22^0>k`, but it does not invalidate positive definiteness inside the upper half-plane: there, `det(Md)=k^2*b^2*cos(theta)^4/12>0`. Its singular boundary remains a practical restriction.

## Recommended verification sequence

Unify angle and physical-state conventions first. Reconcile the energy candidate, gradient, matching conditions, and plotted diagnostic next. Then validate a force-input plant and run stored scenarios with raw logs and explicit tolerances. Recheck saturation, cart travel, and capture behavior after these corrections. A fresh numerical run alone cannot replace the matching checks.

