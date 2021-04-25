classdef routes_length_strategory < util.abstract_strategory
    methods
        function tf = actions(~, dfs_obj, current_node)
            ds = dfs_obj.current_leng +  ...
                dfs_obj.G(dfs_obj.current_path(end),current_node) + ...
                dfs_obj.G(current_node,dfs_obj.ep);
            tf = ~isequal(dfs_obj.aux_info(current_node), dfs_obj.aux_info(dfs_obj.current_path(end))) &...
                ds <= dfs_obj.days;
            assert(isscalar(tf));
        end
    end
end