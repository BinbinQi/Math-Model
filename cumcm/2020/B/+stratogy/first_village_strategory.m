classdef first_village_strategory < util.abstract_strategory
    methods
        function tf = actions(~, dfs_obj, current_node)
                 tf = length(dfs_obj.current_path) ~= 1 |...
              dfs_obj.aux_info(current_node) == "村庄";
        end
    end
end