function open_project()
%OPEN_PROJECT Initialize documented parameters and open the original IDA model.
% Run after adding this repository's scripts directory to the MATLAB path.
% The helper does not simulate or save the model.
repoRoot = fileparts(fileparts(mfilename('fullpath')));
run(fullfile(repoRoot, 'scripts', 'init_parameters.m'));
names = {'M_v','m_v','l_v','g_v','a','b','q2','q2_s','phi_desired'};
values = {M_v,m_v,l_v,g_v,a,b,q2,q2_s,phi_desired};
for index = 1:numel(names)
    assignin('base', names{index}, values{index});
end
open_system(fullfile(repoRoot, 'models', 'IDA_PBC.slx'));
end

