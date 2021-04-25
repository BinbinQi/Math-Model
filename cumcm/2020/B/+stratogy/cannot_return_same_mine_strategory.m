classdef cannot_return_same_mine_strategory < util.abstract_strategory
    methods
        function tf = actions(~, dfs_obj, current_node)
                       tf = ~isequal(dfs_obj.aux_info(current_node),"矿山") |...
                            all(~(dfs_obj.current_path == current_node));

        end
    end
end