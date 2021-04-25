clear all;clc;close all
% data 1
% data = common_tool.Help.get_data("data_input\data.mat", 1);
% data 2
data = common_tool.Help.get_data("data_input\data.mat", 1);
data = common_tool.solve_help.data_ready(data);
st = advantaged_opti_tree(data);
st.add_strategory("first_village",stratogy.first_village_strategory);
st.add_strategory("routes_length",stratogy.routes_length_strategory);
st.add_strategory("cannot_mine",stratogy.cannot_return_same_mine_strategory);
st.DFS(1);
roads = st.res;
roads_raw = cellfun(@(x)data.node_indx(x),roads, 'uni', 0);
celldisp(roads_raw);
s = solver(data);

tic

s.solve_method = solve_method.loop_method(st);  %
% s.solve_method = solve_method.ga_method(st);         %
% s.solve_method = solve_method.fmincon_method(st);    % 

global_best = [];
global_money = 0;
for road = roads
    s.run(road{:});
    if s.best_sol.fvl > global_money
        global_money = s.best_sol.fvl;
        global_best = s.best_sol;
        global_best.r = data.node_indx(road{:});
    end
end
toc
common_tool.post_process.display_res(global_best, data,st);

