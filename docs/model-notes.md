# Saved model notes

`models/IDA_PBC.slx` combines the energy-regulation branch with a local IDA-PBC-inspired controller. It computes `qdot=p`, `theta_ddot=a*sin(theta)-b*cos(theta)*u+d_t`, and `x_ddot=u+d_f`. The state conventions refer to velocities in a reduced-coordinate model; they are not the physical momenta of the original cart–pendulum.

The active smoothstep uses `epsilon=pi/2-0.9`, `delta=0.03`, and an angle-only distance. The local branch is enabled within `abs(theta)<pi/2-0.1`. A separate dwell/power controller exists in the model but is commented out. It is excluded from descriptions of the active algorithm.

The local controller uses `k=0.2`, `m22^0=0.2`, `P=7`, and `Kv=1`. Its implemented structure is `uS=-Kv*G'*invMd*p - G'*(S+Md*gradHd)/(G'*G)`. It contains no active `J2` term. The swing-up path uses the energy law and cart feedback described in the English report. Auxiliary saturation precedes disturbance addition in the reduced plant. The force branch is a diagnostic.

Both saved models have R2022b metadata, fixed-step auto integration, a step of 0.001 s, and a stop time of 50 s. No referenced external models or initial/loading callbacks were found during static inspection. `Energy_Shaping.slx` includes an exploratory LQR path requiring workspace preparation from the Live Script.

The complete source review is summarized in [source-checks.md](source-checks.md). [Model summary](model-summary.json) and [algebra checks](source-math-checks.json) provide compact machine-readable evidence. The JSON checks describe static inspection, not successful execution or validated simulation results.

