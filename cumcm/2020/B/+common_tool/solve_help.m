classdef solve_help
    
    methods(Static)
        
        function real_road_with_weather = expand_route(road, data, wd)
            %{
                扩充路线，WD表示挖矿天数
            %}
            if any(wd<0)
                aaa = 1;
            end
            assert(all(wd>0));
            lin_idx = sub2ind(size(data.dst), ...
                road(1:end-1), road(2:end));
            rc = data.node_indx(repelem(road, [data.dst(lin_idx),1]));
            rc(rc==circshift(rc,1)) = -1;
            t = ones(size(rc));
            t(ismember(rc,data.ks)) = wd + 1;
            real_road = repelem(rc, t);
            real_road_with_weather(1) = real_road(1);
            [id_1, id_2] = deal(2);
            while id_2<= numel(real_road)
                if data.tq(id_1-1) == "沙暴"
                    real_road_with_weather(id_1) = real_road_with_weather(id_1-1); %#ok<*AGROW>
                else
                    real_road_with_weather(id_1) = real_road(id_2);
                    id_2 = id_2 + 1;
                end
                id_1 = id_1 + 1;
            end
        end
        
        function data = data_ready(data)
            data.nks = length(data.ks);
            data.ncz = length(data.cz);
            data.node_name = ["起点","终点",...
                repelem("矿山" ,data.nks),...
                repelem("村庄" ,data.ncz)];
            data.node_name_u = ["起点","终点",...
                "矿山"  + (1 : data.nks),...
                "村庄"  + (1 : data.ncz)];
            data.node_indx = [1, height(data.G.Nodes), data.ks, data.cz];
            data.aux_info = containers.Map(1:length(data.node_name), data.node_name);
            data.days = data.m - nnz(data.tq(1:data.m-1) == "沙暴");
            data.dst = distances(data.G, data.node_indx, data.node_indx);
        end
        
        function r = combine_fun(p, d, n, r)
            if ~d || length(p) == n
                if length(p) == n
                    r{end+1} = p;
                end
            else
                for i = 1 : d
                    r = common_tool.solve_help.combine_fun([p,i],d-i,n,r);
                end
            end
        end
        
    end
    
end