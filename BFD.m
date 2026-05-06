function D = BFD(points)
% BFD - Weighted shortest-path distances on implicit 8-connected graph
%
% points: n x 2 integer coordinates
% D: n x n shortest-path distances

    n = size(points,1);
    D = inf(n);

    % Normalize coordinates to positive grid indices
    minX = min(points(:,1));
    minY = min(points(:,2));
    
    x = points(:,1) - minX + 1;
    y = points(:,2) - minY + 1;

    maxX = max(x);
    maxY = max(y);

    % Grid lookup
    grid = zeros(maxX, maxY);
    for i = 1:n
        grid(x(i), y(i)) = i;
    end

    % 8-connected moves
    moves = [-1 -1; -1 0; -1 1;
              0 -1;        0 1;
              1 -1;  1 0;  1 1];

    % Corresponding costs
    costs = [sqrt(2); 1; sqrt(2);
             1;       1;
             sqrt(2); 1; sqrt(2)];

    for i = 1:n
        dist = inf(n,1);
        visited = false(n,1);

        dist(i) = 0;

        while true
            % Pick unvisited node with smallest distance
            unvisited = find(~visited);
            if isempty(unvisited)
                break;
            end

            [~, idx] = min(dist(unvisited));
            u = unvisited(idx);

            if isinf(dist(u))
                break;
            end

            visited(u) = true;

            cx = x(u);
            cy = y(u);

            for m = 1:8
                nx = cx + moves(m,1);
                ny = cy + moves(m,2);

                % bounds check
                if nx < 1 || nx > maxX || ny < 1 || ny > maxY
                    continue;
                end

                v = grid(nx, ny);
                if v == 0 || visited(v)
                    continue;
                end

                alt = dist(u) + costs(m);
                if alt < dist(v)
                    dist(v) = alt;
                end
            end
        end

        D(i,:) = dist;
    end
end