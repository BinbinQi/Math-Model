classdef solver < util.my_solver & matlab.mixin.Copyable
    properties(Hidden = true)
        data
        best_sol
    end
    
    methods
        function obj = solver(data)
            obj.data = data;
            obj.best_sol = [];
        end
    end
    
    methods
        function display_res(obj)
            G = graph(obj.data.dst,obj.data.node_name_u);
            h = plot(G);
%             path 
%             highlight(h,path,'NodeColor','g','EdgeColor','g')
            
        end
        
        function save_res(obj)
        end
    end

end