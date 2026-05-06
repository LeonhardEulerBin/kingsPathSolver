clc; clear all; format compact; %Work ended 3/30/2026 (moved to V2)
%jav cluster
% nodes = [2 13; 3 13; 3 12; 4 12; 5 12; 5 11; 6 11; 7 12; 6 12; 6 13; 5 13; 4 13; 3 14; 4 14; 4 15; 5 15; 5 14; 6 14; 7 14; 7 13; 8 13; 8 14; 9 14; 9 15; 9 16; 8 16; 7 16; 8 15; 7 15; 6 15; 6 16; 5 16; 4 16; 3 16; 2 16; 1 16; 1 15; 2 15; 3 15; 2 14; 1 14; 1 13];
% nodes = [3 4; 3 3; 4 3; 4 4; 4 5; 4 6; 5 5; 5 6; 6 6; 6 5; 7 5; 7 4; 6 4; 5 4; 5 3; 6 3; 7 3; 7 2; 7 1; 6 2; 6 1; 5 1; 5 2; 4 2; 3 2; 4 1; 3 1; 2 1; 1 1; 1 2; 2 2; 2 3; 2 4; 1 3; 1 4; 1 5; 2 5; 3 5]; %2nd breech bug, 2 opt fixes
% nodes = [6 2; 6 1; 5 1; 4 1; 3 2; 4 2; 5 2; 5 3; 5 4; 5 5; 4 5; 4 4; 4 3; 3 3; 3 4; 2 4; 2 3; 1 4; 1 5; 1 6; 1 7; 2 7; 2 6; 2 5; 3 5; 3 6; 3 7; 4 7; 5 7; 4 6; 5 6; 6 7; 7 7; 7 6; 6 6; 6 5; 7 5; 7 4; 6 4; 6 3; 7 3; 7 2]; %Breaches weird, 2 opt fixes
% nodes = [1 6; 2 6; 3 6; 3 7; 4 7; 4 6; 2 5; 3 5; 4 5; 4 4; 3 4; 3 3; 4 3; 4 2; 5 1; 5 2; 5 3; 5 4; 5 5; 5 6; 5 7; 5 8; 5 9; 5 10; 4 9; 3 9; 4 8; 3 8; 2 7; 2 8; 2 9; 1 8; 1 7];
% nodes = [5 2; 5 3; 5 4; 5 5; 4 6; 4 5; 4 4; 4 3; 3 4; 3 5; 3 6; 2 6; 2 7; 1 7; 1 6; 1 5; 2 5; 2 4; 1 4; 1 3; 1 2; 1 1; 2 1; 2 2; 2 3; 3 3; 3 2; 3 1; 4 2]; %Doable in 1
% nodes = [7 4; 6 4; 6 3; 6 2; 5 2; 5 3; 5 4; 4 4; 4 3; 4 2; 4 1; 3 1; 2 1; 3 2; 3 3; 3 4; 2 4; 2 3; 2 2; 1 2; 1 3; 1 4; 1 5; 2 6; 2 5; 3 5; 3 6; 3 7; 4 7; 4 8; 5 7; 5 6; 4 6; 4 5; 5 5; 6 6; 6 5; 7 5]; %able breach wrong (fixed)
% nodes = [2 1; 1 1; 1 2; 1 3; 1 4; 1 5; 2 5; 2 4; 2 3; 2 2; 3 3; 3 4; 3 5; 3 6; 4 6; 4 5; 5 5; 6 4; 5 4; 4 4; 4 3; 5 2; 5 3; 6 3; 6 2; 7 2; 8 1; 7 1; 6 1; 5 1; 4 2; 3 2; 4 1; 3 1];


%carter cluster
% nodes = [1 1;1 2;1 3;1 4;1 5;3 5;4 5;1 6;2 6;3 6;2 7;3 7;2 8;3 8;3 9;4 9];
% nodes = [5 1;4 2;5 2;4 3;4 4;2 5;3 5;4 5;1 6;2 6;3 6;4 6;2 7;3 7;4 7;5 7;5 8;5 9;3 10;4 10;5 10;3 11;4 11;5 11;3 12;4 12; 5 12];

%interior class tester
% nodes = [1 1; 2 1; 3 1; 4 1; 5 1; 1 2; 3 2; 5 2; 1 3; 3 3; 5 3; 1 4; 5 4; 2 5; 3 5; 4 5; 5 5]; %small version %Breaks on loop

%multi-breach test
% nodes = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3; 7 1; 7 2; 7 3];
% nodes = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3; 7 1; 7 2; 7 3; 8 1; 8 2; 8 3]; %Breach imperfect (DnD stat rules needed?)

%worst case
% nodes = [3 1; 4 1; 6 1; 7 1; 2 2; 5 2; 8 2; 1 3; 4 3; 6 3; 9 3; 2 4; 3 4; 5 4; 7 4; 8 4; 1 5; 4 5; 6 5; 9 5; 2 6; 5 6; 8 6; 3 7; 4 7; 6 7; 7 7]; %bipartite
nodes = [1 1; 2 1; 3 1; 4 1; 5 1; 6 1; 7 1; 8 1; 9 1; 10 1; 11 1; 12 1; 13 1; 14 1; 15 1; 16 1; 17 1; 
    1 2; 2 2; 3 2; 4 2; 5 2; 6 2; 7 2; 8 2; 9 2; 10 2; 11 2; 12 2; 13 2; 14 2; 15 2; 16 2; 17 2; 18 2; 19 2; 20 2; 1 3; 2 3; 18 3; 19 3; 20 3;
    1 4; 2 4; 18 4; 19 4; 20 4; 21 4; 22 4; 23 4; 24 4; 25 4; 1 5; 2 5; 17 5; 18 5; 21 5; 22 5; 23 5; 24 5; 25 5; 1 6; 2 6; 17 6; 18 6; 24 6; 25 6; 
    1 7; 2 7; 24 7; 25 7; 1 8; 2 8; 24 8; 25 8; 1 9; 2 9; 24 9; 25 9; 1 10; 2 10; 24 10; 25 10; 1 11; 2 11; 24 11; 25 11; 1 12; 2 12; 24 12; 25 12; 1 13; 2 13; 24 13; 25 13; 1 14; 2 14; 24 14; 25 14; 1 15; 2 15; 24 15; 25 15; 1 16; 2 16; 24 16; 25 16; 1 17; 2 17; 24 17; 25 17;
    11 7; 12 7; 13 7; 14 7; 15 7; 16 7; 17 7; 18 7; 11 8; 12 8; 13 8; 14 8; 15 8; 16 8; 17 8; 18 8; 11 9; 12 9;
    11 10; 12 10; 13 10; 14 10; 15 10; 16 10; 18 10; 19 10; 20 10; 9 11; 10 11; 11 11; 12 11; 13 11; 14 11; 15 11; 16 11; 18 11; 19 11; 20 11;
    9 12; 10 12; 13 12; 13 12; 15 12; 16 12; 17 12; 18 12; 19 12; 20 12; 9 13; 10 13; 15 13; 16 13; 17 13; 20 13; 21 13;
    9 14; 10 14; 20 14; 21 14; 9 15; 10 15; 17 15; 18 15; 19 15; 20 15; 21 15; 9 16; 10 16; 17 16; 18 16; 19 16; 20 16; 21 16;
    9 17; 10 17; 13 17; 14 17; 15 17; 17 17; 18 17;
    1 18; 2 18; 3 18; 4 18; 5 18; 6 18; 7 18; 10 18; 11 18; 12 18; 13 18; 14 18; 15 18; 17 18; 18 18; 19 18; 20 18; 21 18; 22 18; 23 18; 24 18; 25 18;
    1 19; 2 19; 3 19; 4 19; 5 19; 6 19; 7 19; 10 19; 11 19; 12 19; 14 19; 15 19; 16 19; 17 19; 18 19; 19 19; 20 19; 21 19; 22 19; 23 19; 24 19; 25 19;
    1 20; 2 20; 3 20; 6 20; 7 20; 8 20; 9 20; 10 20; 1 20; 12 20; 14 20; 15 20; 16 20; 17 20; 18 20; 19 20;
    6 21; 7 21; 8 21; 9 21; 
    11 12; 12 12];

%rand points
% nodes = [0 0;0 1;1 2;1 1;0 -1;0 2;2 1;1 0;2 0;0 3;-1 2;-1 0;-1 -1;2 -1;1 4;1 -1;2 2;-2 -2;1 -2;-2 -3;3 3;-3 -1;-1 3;3 1;0 4;-1 5;-1 1;-2 1;
%     3 0;-4 -2;1 5;-4 0;-1 -2;0 -2;2 4;0 5;1 6;-2 2;2 3;-1 -3;-2 5;2 -2;-3 0;4 3;0 -3;-2 -1;4 4;2 6;-3 2;5 3;-4 -1;2 -3;-2 0;-2 -4;-3 6;-1 6;
%     5 4;0 6;1 7;1 3;4 -1;4 0;-3 -3;-1 4;3 -1;4 1;1 -3;3 -3;4 2;-4 -3;2 5;-5 -3;-2 6;-3 5;3 2;-4 4;0 7;3 -2;3 -4;3 4;-1 7;0 8;2 8;-1 8;-1 -4;
%     -4 -4;3 7;5 0;-2 -5;-3 -6;3 6;5 2;6 4;-3 7;3 8;-1 -5;4 -2;-3 1;6 5;1 9;3 9;-3 -2;-2 -6;-3 -4;4 10;-2 4;1 -4;-4 2;4 5;-3 3;4 8;-4 7;5 5;
%     4 6;4 9;5 1;-4 6;-1 -6;3 11;2 11;1 10;6 3;7 5;2 7;0 10;-5 -2;5 -1;2 10;3 10;-2 7;-2 3;5 -2;2 9;1 11;-5 -1;3 12;-6 -1;-5 0;-3 -5;2 -4;-4 -6;
%     4 -3;5 9;-4 1;-2 -7;6 0;5 10;6 -1;1 8;-6 -2;5 -3;6 -3;-3 4;5 8;0 -5;7 -2;-2 8;6 -2;-1 9;3 5;-5 2;0 9;-6 -3;7 6;6 9;-4 8;-7 -3;6 -4;5 6;7 9;8 6;6 8;
%     -5 1;7 7;4 -4;7 8;-6 0;0 12;7 -3;4 7;1 -6;8 -4;7 4;2 -5;6 6;-3 8;-4 -5;-2 -8;-5 7;-6 2;8 -1;-6 1;-4 -7;5 7;-1 10;2 13;-5 -4;4 -5;-3 9;8 -2];
% nodes = [-nodes(:,1), nodes(:,2)];
% nodes = king_connected_points(100);

%Determine arbitrarily valid starting point
[~, topID] = max(nodes(:,2));
startPoint = nodes(topID,:);


%basic maths
% numNodes = size(nodes,1);
numNeighbor = countNeighbors(nodes);
% numInterior = sum(numNeighbor == 8);
intNodes = nodes(numNeighbor==8,:); %Incorrect when there are voids, but fixed by a later step
extNodes = nodes(numNeighbor~=8,:);

%Base nodes
figure(1); clf; hold on;
title("Stage N")
scatter(nodes(:,1), nodes(:,2))
% plot(nodes(:,1), nodes(:,2))
% scatter(intNodes(:,1), intNodes(:,2),'b')
% scatter(extNodes(:,1), extNodes(:,2),'r')
axis equal


%============================================================================================================
%stage 1 Outer wrap
%============================================================================================================
prevDir = [1 0]; %default for round 1. always valid
flipChirality = 0;
% [firstPath, wrappedPath] = orderGridPath_V1(extNodes, startPoint,startPoint);
% [firstPath, path, added] = orderGridPath_V2(extNodes, startPoint,startPoint, prevDir);
[path, added] = orderGridPath_V3(extNodes, startPoint,startPoint, prevDir, flipChirality,8);
% [firstPath, wrappedPath] = orderGridPath_V2(extNodes, [4 12],[4 12], [1 0]);%test

% reclassify remaining nodes
intNodes = [intNodes; extNodes(~added,:)];

%Plotting
% plot(firstPath(:,1),firstPath(:,2),'b')
finalPath = plot(path(:,1),path(:,2),'r');
% legend('int','ext','Wrap 1', 'Shrink Wrap')

%============================================================================================================
%Stage 2: recurse this eventually
%============================================================================================================
% %Define new int and ext
% numNeighbor = countNeighbors(intNodes);
% extNodes = intNodes(numNeighbor~=8,:);
% intNodes = intNodes(numNeighbor==8,:);
% 
% % scatter(extNodes(:,1), extNodes(:,2),'r')%plot check
% 
% %numNeighboring
% numNeighbor = numNeighboring(wrappedPath,extNodes);
% 
% %find entry point
% [optBreakID,optReturnID] = breacher(numNeighbor);
% optBreak = wrappedPath(optBreakID,:);
% optReturn = wrappedPath(optReturnID,:);
% 
% % scatter(optBreak(1), optBreak(2),'g')%plot check
% % scatter(optReturn(1), optReturn(2),'k')%plot check
% 
% extNodes = [extNodes; optBreak; optReturn];
% 
% 
% %build new loop
% [~, pathAddition, added] = orderGridPath_V2(extNodes, optBreak,optReturn, optBreak-optReturn);
% intNodes = [intNodes; extNodes(~added,:)];
% pathAddition = flipud(pathAddition(2:end-1,:)); %path order is counterclockwise, chop off break points
% % plot(pathAddition(:,1),pathAddition(:,2),'m')
% % scatter(intNodes(:,1), intNodes(:,2),'b')%plot check
% 
% %splice in
% if optBreakID ~= 1
%     path=[wrappedPath(1:optReturnID,:); pathAddition; wrappedPath(optBreakID:end,:)];
% else
%     path=[wrappedPath; pathAddition];
% end
% % plot(path(:,1),path(:,2))

%============================================================================================================
%Stage 3: refined loop
%============================================================================================================
while size(intNodes,1) > 0
includeCut = 1;
%Define new int and ext
numNeighbor = countNeighbors(intNodes);
extNodes = intNodes(numNeighbor~=8,:);
intNodes = intNodes(numNeighbor==8,:);

%numNeighboring
numNeighbor = numNeighboring(path,extNodes);

%find entry point
[optBreakID,optReturnID] = breacher(numNeighbor); %CHANGE TO CHOOSE MAX PAIR WITH MAX STD? OR MAYBE JUST EVEN PRIO?
optBreak = path(optReturnID,:);
optReturn = path(optBreakID,:);

if optBreakID ~= optReturnID
    breachDir = optBreak-optReturn;
elseif optBreakID ~=1
    breachDir = path(optBreakID-1,:)-path(optBreakID,:);
else
    breachDir = path(end,:)-path(optBreakID,:);
end
breachDir = -breachDir;

%chirality check here %HAS SOME SORT OF ERROR ON 3RD STAGE
flipChirality = 1;
if ismember(optBreak + (breachDir)*[0 -1; 1 0],extNodes,"rows") || ismember(optReturn + (breachDir)*[0 -1; 1 0],extNodes,"rows")
    flipChirality = 0;
end

%build new path
cutNodes = [];
extNodes = [extNodes; optBreak; optReturn]; %define nodes viable for the path
[pathAddition, added] = orderGridPath_V3(extNodes, optBreak,optReturn, breachDir, flipChirality,4); %main math  
pathAddition = pathAddition(2:end-1,:); %path order is counterclockwise, chop off break points
[pathAddition, cutNodes, cutNodesTrue] = cutPath(pathAddition, 1);

if isempty(pathAddition) || numNeighbor(optBreakID,1) <= 1 || numNeighbor(optReturnID,1) <= 1
    [pathAddition, added] = orderGridPath_V3(extNodes, optBreak,optReturn, breachDir, flipChirality,8);
    pathAddition = flipud(pathAddition(2:end-1,:)); %path order is counterclockwise, chop off break points
    [pathAddition, cutNodes, cutNodesTrue] = cutPath(pathAddition, 0);
    intNodes = [intNodes; extNodes(~added,:); cutNodes]; %redefine remaining
else
    intNodes = [intNodes; extNodes(~added,:); cutNodesTrue]; %redefine remaining
end







%splice in
if optBreakID ~= 1
    path=[path(1:optReturnID,:); pathAddition; path(optBreakID:end,:)];
else
    path=[path; pathAddition];
end
% set(finalPath,'Xdata',path(:,1),'Ydata',path(:,2)) %PLOT CHECK TEMP==============================================================
delete(finalPath)
finalPath = plot(path(:,1),path(:,2),'r');
end %end while

plot(path(:,1),path(:,2),'r')

% %VS Concorde
% tour = concordeWrapper(nodes);
% figure(2); clf;
% plot([nodes(tour,1); nodes(tour(1),1)], [nodes(tour,2); nodes(tour(1),2)],'-o');
% title("Stage N Concorde")
% grid on; axis equal;

% %2 opt approach, fixes some sins
% figure(2); clf; axis equal; hold on;
% title("Base 2 Opt")
% scatter(nodes(:,1),nodes(:,2))
% % nodes2Opt = twoOptCycle([nodes;nodes(1,:)]);
% % nodes2Opt = twoOptCycle([path;path(1,:)]);
% % plot(nodes2Opt(:,1),nodes2Opt(:,2))
% plot(path(:,1),path(:,2),'r')



















function [firstPath, wrappedPath] = orderGridPath_V1(pts, startPt, endPt) %the base algorithm written out
% Orders unordered grid points along a path using directional CCW search
%
% INPUT
%   pts     : n x 2 matrix of [x y] grid coordinates (unordered)
%   startPt : [x y] start coordinate
%   endPt   : [x y] end coordinate
%
% OUTPUT
%   firstPath   : ordered path from start to end
%   wrappedPath : final path after inserting diagonal connectors

n = size(pts,1);
added = false(n,1);

% 8-neighborhood directions (CCW)
dirs = [ ...
     0  1;
    -1  1;
    -1  0;
    -1 -1;
     0 -1;
     1 -1;
     1  0;
     1  1];

% --- find start and end indices ---
startIdx = find(pts(:,1)==startPt(1) & pts(:,2)==startPt(2),1,'first');
endIdx   = find(pts(:,1)==endPt(1)   & pts(:,2)==endPt(2),1,'first');

if isempty(startIdx) || isempty(endIdx)
    error('Start or end point not found in pts.')
end

pathIdx = startIdx;
added(startIdx) = true;

currentIdx = startIdx;
currentPt = pts(currentIdx,:);

% initial previous direction (pretend we came from below)
prevDir = [0 -1];

while true

    % find index of previous direction
    prevIdx = find(dirs(:,1)==prevDir(1) & dirs(:,2)==prevDir(2),1);

    % start searching CCW from next direction
    for step = 1:8
        dirIdx = mod(prevIdx + step - 1, 8) + 1;
        d = dirs(dirIdx,:);

        candidate = currentPt + d;

        % find matching point (ignore added status)
        idx = find(pts(:,1)==candidate(1) & pts(:,2)==candidate(2),1,'first');

        if ~isempty(idx)

            pathIdx(end+1,1) = idx; %#ok<AGROW>
            added(idx) = true;

            % stop if end point reached
            if idx == endIdx
                firstPath = pts(pathIdx,:);

                % ================= Shrink wrap stage =================
                unusedIdx = find(~added);

                for u = 1:length(unusedIdx)
                    pIdx = unusedIdx(u);
                    p = pts(pIdx,:);

                    for k = 1:length(pathIdx)

                        aIdx = pathIdx(k);

                        if k == length(pathIdx)
                            break % do not wrap end->start anymore
                        else
                            bIdx = pathIdx(k+1);
                        end

                        a = pts(aIdx,:);
                        b = pts(bIdx,:);

                        % check if a and b are diagonal neighbors
                        if abs(b(1)-a(1)) == 1 && abs(b(2)-a(2)) == 1

                            % check if p is orthogonal neighbor of both
                            if sum(abs(p-a)) == 1 && sum(abs(p-b)) == 1

                                % insert p between a and b
                                pathIdx = [pathIdx(1:k); pIdx; pathIdx(k+1:end)];
                                added(pIdx) = true;
                                break
                            end
                        end
                    end
                end

                wrappedPath = pts(pathIdx,:);
                return
            end

            % update direction information
            prevDir = -d;
            currentIdx = idx;
            currentPt = pts(idx,:);

            break
        end
    end
end

end

function [firstPath, wrappedPath, added] = orderGridPath_V2(pts, startPt, endPt, prevDir)%done fast

n = size(pts,1);
if ~all(startPt == endPt)
    added = false(n,1);
else
    added = false(n-1,1);
end
% 8-neighborhood directions (CCW)
dirs = [0  1;
    -1  1;
    -1  0;
    -1 -1;
     0 -1;
     1 -1;
     1  0;
     1  1];
%stutter stepping may preserve O(n) if done right
%That way there is no need to go back through the remaining points.
%current implementation may be ok though since it does map stuff
% dirs = [0  1;
%      1  1;
%     -1  0;
%     -1  1;
%      0 -1;
%     -1 -1;
%      1  0;
%      1 -1];

% Build fast coordinate lookup
coordMap = containers.Map('KeyType','char','ValueType','any');

for i = 1:n
    key = sprintf('%d_%d',pts(i,1),pts(i,2));
    
    if isKey(coordMap,key)
        coordMap(key) = [coordMap(key) i];
    else
        coordMap(key) = i;
    end
end

% Find start/end indices
startKey = sprintf('%d_%d',startPt(1),startPt(2));
endKey   = sprintf('%d_%d',endPt(1),endPt(2));

if ~isKey(coordMap,startKey) || ~isKey(coordMap,endKey)
    error('Start or end point not found in pts');
end

startIdx = coordMap(startKey);
startIdx = startIdx(1);

endIdx = coordMap(endKey);
endIdx = endIdx(1);

% Initialize path trace
pathIdx = startIdx;
added(startIdx) = true;

currentIdx = startIdx;
currentPt = pts(currentIdx,:);

% prevIdx = find(dirs(:,1)==startDir(1) & dirs(:,2)==startDir(2),1); %was good when choosing start direction was easier
% dirIdx = mod(prevIdx - 1 - 1,8) + 1;
% prevDir = dirs(dirIdx,:);

% Path tracing
while true

    prevIdx = find(dirs(:,1)==prevDir(1) & dirs(:,2)==prevDir(2),1);

    for step = 1:8

        dirIdx = mod(prevIdx + step - 1,8) + 1;
        d = dirs(dirIdx,:);

        candidate = currentPt + d;
        key = sprintf('%d_%d',candidate(1),candidate(2));

        if isKey(coordMap,key)

            idxList = coordMap(key);
            idx = idxList(1);

            pathIdx(end+1,1) = idx; %#ok<AGROW>
            added(idx) = true;

            if idx == endIdx
                firstPath = pts(pathIdx,:);
                break
            end

            prevDir = -d;
            currentIdx = idx;
            currentPt = pts(idx,:);

            %TEST PLOT==================================================================================================================================
            % plot(pts(pathIdx(end-1:end),1),pts(pathIdx(end-1:end),2),'b')
            % pause(.02)
            break

        end
    end

    if pathIdx(end) == endIdx
        break
    end

end

% Shrink wrap stage (insert orthogonal connectors)

unusedIdx = find(~added);

for u = 1:length(unusedIdx)

    pIdx = unusedIdx(u);
    p = pts(pIdx,:);

    for k = 1:length(pathIdx)-1

        aIdx = pathIdx(k);
        bIdx = pathIdx(k+1);

        a = pts(aIdx,:);
        b = pts(bIdx,:);

        if abs(b(1)-a(1))==1 && abs(b(2)-a(2))==1

            if sum(abs(p-a))==1 && sum(abs(p-b))==1

                pathIdx = [pathIdx(1:k); pIdx; pathIdx(k+1:end)];
                added(pIdx) = true;
                break

            end
        end
    end

end

wrappedPath = pts(pathIdx,:);

end


function [path, added] = orderGridPath_V3(pts, startPt, endPt, prevDir,flipChirality, connectivity)%done fast

n = size(pts,1);
if ~all(startPt == endPt)
    added = false(n,1);
else
    added = false(n-1,1);
end
% 8-neighborhood directions (CCW)
if connectivity == 8
dirs = [0  1;
    -1  1;
    -1  0;
    -1 -1;
     0 -1;
     1 -1;
     1  0;
     1  1];
else
    dirs = [0  1;
    -1  0;
     0 -1;
     1  0];
end

if flipChirality == 1
    dirs = flipud(dirs);
end

% Build fast coordinate lookup
coordMap = containers.Map('KeyType','char','ValueType','any');
for i = 1:n
    key = sprintf('%d_%d',pts(i,1),pts(i,2));
    if isKey(coordMap,key)
        coordMap(key) = [coordMap(key) i];
    else
        coordMap(key) = i;
    end
end

% Find start/end indices
startKey = sprintf('%d_%d',startPt(1),startPt(2));
endKey   = sprintf('%d_%d',endPt(1),endPt(2));
if ~isKey(coordMap,startKey) || ~isKey(coordMap,endKey)
    error('Start or end point not found in pts');
end

startIdx = coordMap(startKey);
startIdx = startIdx(1);
endIdx = coordMap(endKey);
endIdx = endIdx(1);

% Initialize path trace
pathIdx = startIdx;
added(startIdx) = true;
currentIdx = startIdx;
currentPt = pts(currentIdx,:);

% Path tracing
while true
    prevIdx = find(dirs(:,1)==prevDir(1) & dirs(:,2)==prevDir(2),1);
    for step = 1:connectivity
        dirIdx = mod(prevIdx + step - 1,connectivity) + 1;
        d = dirs(dirIdx,:);

        candidate = currentPt + d;
        key = sprintf('%d_%d',candidate(1),candidate(2));

        if isKey(coordMap,key)
            idxList = coordMap(key);
            idx = idxList(1);
            pathIdx(end+1,1) = idx; %#ok<AGROW>
            added(idx) = true;
            if idx == endIdx
                firstPath = pts(pathIdx,:);
                break
            end
            prevDir = -d;
            currentIdx = idx;
            currentPt = pts(idx,:);

            %TEST PLOT==================================================================================================================================
            plot(pts(pathIdx(end-1:end),1),pts(pathIdx(end-1:end),2),'b')
            pause(.02)
            break
        end
    end

    if pathIdx(end) == endIdx
        break
    end
end

% Shrink wrap stage (insert orthogonal connectors)====================================================
if connectivity == 8
    unusedIdx = find(~added);
    for u = 1:length(unusedIdx)
        pIdx = unusedIdx(u);
        p = pts(pIdx,:);
    
        for k = 1:length(pathIdx)-1
            aIdx = pathIdx(k);
            bIdx = pathIdx(k+1);
            a = pts(aIdx,:);
            b = pts(bIdx,:);
            if abs(b(1)-a(1))==1 && abs(b(2)-a(2))==1
                if sum(abs(p-a))==1 && sum(abs(p-b))==1
                    pathIdx = [pathIdx(1:k); pIdx; pathIdx(k+1:end)];
                    added(pIdx) = true;
                    break
                end
            end
        end
    end
end
path = pts(pathIdx,:);
end



% function numNeighbor = numNeighboring(path,extNodes)
% numPoints = size(path,1);
% 
% % 8 adjacent
% offsets = [-1 -1
%     -1  0
%     -1  1
%      0 -1
%      0  1
%      1 -1
%      1  0
%      1  1];
% 
% % For each offset check membership
% numNeighbor = zeros(numPoints,1);
% for k = 1:size(offsets,1)
%     neighbors = path + offsets(k,:);
%     numNeighbor = numNeighbor + ismember(neighbors,extNodes,'rows');
% end
% end

function numNeighbor = numNeighboring(path, extNodes)

numPoints = size(path,1);

% Clockwise order (important!)
offsets = [ -1 -1
            -1  0
            -1  1
             0  1
             1  1
             1  0
             1 -1
             0 -1 ];

numNeighbor = zeros(numPoints,1);

for i = 1:numPoints
    
    % Get the 8 neighboring positions
    neighbors = path(i,:) + offsets;
    
    % Check which neighbors exist
    isNbr = ismember(neighbors, extNodes, 'rows');
    
    % Make it circular by duplicating
    isNbrCirc = [isNbr; isNbr];
    
    % Find longest run of consecutive 1s
    maxRun = 0;
    currentRun = 0;
    
    for j = 1:length(isNbrCirc)
        if isNbrCirc(j)
            currentRun = currentRun + 1;
            maxRun = max(maxRun, currentRun);
        else
            currentRun = 0;
        end
    end
    
    % Cap at 8 (since only 8 directions exist)
    numNeighbor(i) = min(maxRun, 8);
end

end


function P = twoOptCycle(P)
% twoOptCycle - Applies 2-opt improvement to a cyclic path
%
% Input:
%   P : n×2 matrix of points in current cycle order
%
% Output:
%   P : reordered n×2 matrix after 2-opt optimization

n = size(P,1);
improved = true;

while improved
    improved = false;

    for i = 1:n-2
        for j = i+2:n

            % Avoid breaking the cyclic adjacency between first and last
            if i == 1 && j == n
                continue
            end

            % Current edges: (i,i+1) and (j,j+1)
            i2 = i + 1;
            j2 = mod(j,n) + 1;  % wrap around

            % Current edge lengths
            d1 = norm(P(i,:) - P(i2,:));
            d2 = norm(P(j,:) - P(j2,:));

            % Proposed edge lengths
            d3 = norm(P(i,:) - P(j,:));
            d4 = norm(P(i2,:) - P(j2,:));

            % Check if swap improves
            if (d3 + d4) < (d1 + d2)

                % Reverse segment between i2 and j
                P(i2:j,:) = flipud(P(i2:j,:));

                improved = true;
            end
        end
    end
end
end


function numNeighbor = countNeighbors(points) %rewrite for num-connected neighbors
numPoints = size(points,1);

% 8 adjacent
offsets = [-1 -1
    -1  0
    -1  1
     0 -1
     0  1
     1 -1
     1  0
     1  1];

% For each offset check membership
numNeighbor = zeros(numPoints,1);
for k = 1:size(offsets,1)
    neighbors = points + offsets(k,:);
    numNeighbor = numNeighbor + ismember(neighbors,points,'rows');
end
end

function [optBreakID,optReturnID] = breacher(numNeighbor) %has an error when only 1 point can be broken in from
numNeighbor = numNeighbor.*(numNeighbor <5); %THIS IS A TEMPORARY LINE. THERE IS A BETTER WAY

% pairSums = numNeighbor + numNeighbor([2:end 1]);
nextVals = numNeighbor([2:end 1]); %THIS IS A TEMPORARY LINE. THERE IS A BETTER WAY
% pairSums = (numNeighbor == nextVals)*2 + (numNeighbor ~= nextVals).*(numNeighbor + nextVals);%THIS IS A TEMPORARY LINE. THERE IS A BETTER WAY
pairSums = (numNeighbor <= 2).*(numNeighbor ~= 0).*(numNeighbor == nextVals).*numNeighbor*2 + (numNeighbor ~= nextVals).*(numNeighbor + nextVals);%THIS IS A TEMPORARY LINE. THERE IS A BETTER WAY

[~, idx] = max(pairSums);
optReturnID = idx;
optBreakID = mod(idx,length(numNeighbor)) + 1;

%single entry point case
if numNeighbor(optReturnID) == 0
    optReturnID = optBreakID;
elseif numNeighbor(optBreakID) == 0
    optBreakID = optReturnID;
end

end

function [pathCut, cutNodes, cutNodesTrue] = cutPath(path, includePt)
%cuts repeat nodes, if includePt = 1, the first point in a overlapping segment is preserved
% Special case: first point repeats later
% idxFirst = find(ismember(path, path(1,:), 'rows'));
% 
% if numel(idxFirst) > 1
%     pathCut = path(1,:);
%     cutNodes = unique(path(2:end,:), 'rows', 'stable');
%     return
% end

pathCut = path;
cutNodes = [];
cutNodesTrue = [];

while true
    
    % Stop if all points are unique
    if size(unique(pathCut,'rows','stable'),1) == size(pathCut,1)
        break
    end
    
    % Find first repeated node in order
    for i = 1:size(pathCut,1)
        idx = find(ismember(pathCut, pathCut(i,:), 'rows'));
        if numel(idx) > 1
            firstID = idx(1);
            lastID  = idx(end);
            break
        end
    end
    
    % Remove the repeated segment (inclusive)
    if includePt == 1
        removeIdx = (firstID):(lastID-1); %leaves one copy of the repeat entry node.
        retainingIdx = (firstID+1):(lastID-1);
    else
        removeIdx = firstID:lastID;
    end
    
    removedNodes = pathCut(removeIdx,:);
    cutNodes = unique([cutNodes; removedNodes], 'rows', 'stable');

    removedNodesTrue = pathCut(retainingIdx,:);
    cutNodesTrue = unique([cutNodesTrue; removedNodesTrue], 'rows', 'stable');
    
    pathCut(removeIdx,:) = [];
    
end
end






