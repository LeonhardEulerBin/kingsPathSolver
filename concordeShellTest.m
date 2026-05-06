clc; clear all; format compact;
%test setup
n = 5000;
% nodes = rand(n,2);
% nodes = king_connected_points(n);
% nodes = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3; 7 1; 7 2; 7 3];
nodes = load("nodes10K.mat").nodes;
 %To look into these functions

%call wrapper
tour = concordeWrapper(nodes);
pathInit = [[nodes(tour,1); nodes(tour(1),1)], [nodes(tour,2); nodes(tour(1),2)]];
path = [spliceIntermediateNodes(pathInit(1:end-1,:)); pathInit(end,:)];
% path = pathInit;
%plot result
figure(1); clf;
plot(path(:,1), path(:,2),'-o');
% plot3([nodes(tour,1); nodes(tour(1),1)], [nodes(tour,2); nodes(tour(1),2)],[nodes(tour,3); nodes(tour(1),3)],'-o');
grid on; axis equal;


P = path;
dP = diff(P, 1, 1);   % (n-1)-by-2
% Euclidean distances between consecutive points
segment_lengths = sqrt(sum(dP.^2, 2));
% Total path length
total_length = sum(segment_lengths);
title(sprintf("Nodes %d, length %.2f", n, total_length))


function newPath = spliceIntermediateNodes(path)
% path: Nx2 matrix of [x y] coordinates
% newPath: densified path with intermediate nodes inserted

    newPath = [];

    for i = 1:size(path,1)-1
        p1 = path(i,:);
        p2 = path(i+1,:);
        
        % Always add current node
        newPath = [newPath; p1];
        
        dx = p2(1) - p1(1);
        dy = p2(2) - p1(2);
        
        % Check if this is a 2-step jump
        if max(abs(dx), abs(dy)) > 1
            % Compute intermediate step direction
            step = [sign(dx), sign(dy)];
            
            % Insert intermediate node
            intermediate = p1 + step;
            newPath = [newPath; intermediate];
        end
    end
    
    % Add the final node
    newPath = [newPath; path(end,:)];
end