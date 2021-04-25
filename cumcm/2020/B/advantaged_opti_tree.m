classdef advantaged_opti_tree < util.advantage_dfs
    properties(Hidden)
        current_path
        G
        np
        ep
        aux_info
        days
        current_leng
        cz_idx
        ks_idx
        node_indx
        res = {}
    end
    
    methods
        function obj = advantaged_opti_tree(data)
%             obj@util.advantage_dfs;
            obj.G = data.dst;
            obj.np = width(data.dst);
            obj.current_path = 1;
            obj.current_leng = 1;
            obj.aux_info = data.aux_info;
            obj.days = data.days;
            obj.ep = find(data.aux_info.values=="终点");
            obj.cz_idx = find(data.aux_info.values == "村庄");
            obj.ks_idx = find(data.aux_info.values == "矿山");
            obj.node_indx = data.node_indx;           

        end
    end
    
    methods
        
        function display_res(obj)
            celldisp(obj.res);
        end
    end
    
    methods
        function  tf = has_successors(obj, current_node)
            tf = current_node ~= obj.ep;
        end
        
        function obj = append_res(obj)
            route = obj.change_route(obj.current_path);
            if ~obj.is_exist_route(route) && ...
                    any(ismember(route,obj.ks_idx))
                obj.res{end+1} = obj.current_path;
            end
        end
        
        function node = successors(obj, ~)
            node = 2 : obj.np;
        end
        
        function  tf = is_right(~, ~)
            tf = true;
        end
        
        function add_node(obj, current_node)
            obj.current_leng = obj.current_leng + ...
                obj.G(obj.current_path(end),current_node);
            if isequal(obj.aux_info(current_node),"矿山")
                obj.current_leng = obj.current_leng + 1;
            end
            obj.current_path(end + 1) = current_node;
        end
        
        function backward(obj)
            obj.current_leng = obj.current_leng - ...
                obj.G(obj.current_path(end-1),...
                obj.current_path(end));
            if isequal(obj.aux_info(obj.current_path(end)),"矿山")
                obj.current_leng = obj.current_leng - 1;
            end
            obj.current_path(end) = [];
        end
    end
    
    methods
        function route = change_route(obj, route)
            % 该策略需要进一步商讨
            % 检查村庄的前后节点的距离和，选择距离和最短的
            % 或者可以加上其他约束
            for i = 1 : length(route)
                if any(obj.cz_idx==route(i))
                    dst = obj.G(route(i-1), obj.cz_idx) + obj.G(route(i+1),obj.cz_idx);
                    [~, min_idx] = min(dst);
                    route(i) = obj.cz_idx(min_idx);
                end
            end
        end
    end
    
    methods
        function tf = is_exist_route(obj, route)
            tf = any(cellfun(@(x)isequal(x, route), obj.res));
        end
    end
end