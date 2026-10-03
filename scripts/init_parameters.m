% Documented base-workspace parameters for opening the original IDA model.
% Values follow the supplied Live Script and thesis. No controller blocks,
% initial-value wiring, solver settings, or binary models are modified.
M_v = 1;       % cart mass, kg
m_v = 0.1;     % pendulum point mass, kg
l_v = 0.5;     % rod length, m
g_v = 9.81;    % gravity, m/s^2
a = g_v/l_v;
b = 1/l_v;
q2 = 1;        % original cart initial-position variable, m
q2_s = 2;      % original cart reference variable, m
phi_desired = 0;
% P is deliberately not set here: the original Live Script surface study
% uses P=10, whereas the saved IDA controller has a hardcoded P=7.

