classdef loop_method < util.abstract_strategory
    properties
        tree
    end
    methods
        function obj = loop_method(tree)
            obj.tree = tree;
        end
    end
    methods
        function best_sol = actions(obj, solve_obj, road)
            sp = road(1:end-1);
            ep = road(2:end);
            go_day = sum(obj.tree.G(sub2ind(size(obj.tree.G), sp, ep)))+1;
            wd_locals = nnz(ismember(road,obj.tree.ks_idx));
            rest_days = obj.tree.days - go_day;
            cmb = common_tool.solve_help.combine_fun([], rest_days, wd_locals, {});
            money = 0;
            best_sol = [];
            for r = cmb
                e_road = common_tool. solve_help.expand_route(road,...
                    solve_obj.data, r{:});
                [sol.fvl, sol.tbl, sol.bys, sol.byf, sol.isw] = common_tool.Help.compute_best_solution(e_road, solve_obj.data);
                if sol.fvl > money
                    money = sol.fvl;
                    best_sol = sol;
                end
            end
            solve_obj.best_sol = best_sol;
        end
    end
end