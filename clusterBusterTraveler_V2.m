% clc; clear; format compact; %Functional Optimality Upgrades (4/23/2026)
function pathLength = clusterBusterTraveler_V2(nodes)
%This version implements the touchTips() and eater() architectures but has some flaws.
doPlotting = 0; %0 = no plot, 1 = plot, 2 = final plot
plotSpeed = .01;
%oddities
% nodes = [2 1; 3 1; 6 1; 1 2; 2 2; 3 2; 5 2; 1 3; 4 3; 1 4; 3 4; 5 4; 1 5; 2 5; 4 5; 5 5; 2 6; 3 6; 4 6];
% nodes = [1 4; 2 3; 2 2; 3 2; 2 1; 3 1];
% nodes = [3 1; 4 1; 5 1; 6 1; 7 1; 3 2; 4 2; 5 2; 6 2; 7 2; 1 3; 2 3; 3 3; 4 3; 5 3; 6 3; 7 3; 1 4; 2 4; 3 4;
%     4 4; 5 4; 6 4; 7 4; 1 5; 2 5; 3 5; 4 5; 5 5; 6 5; 7 5; 1 6; 2 6; 3 6; 4 6; 5 6; 3 7; 4 7; 5 7;
%     1 7; 2 7; 1 8; 2 8; 3 8; 4 8; 5 8];

%jav cluster
% nodes = [6 4; 6 3; 6 2; 5 2; 5 3; 5 4; 4 4; 4 3; 4 2; 4 1; 3 1; 2 1; 3 2; 3 3; 3 4; 2 4; 2 3; 2 2; 1 2; 1 3; 1 4; 1 5; 2 6; 2 5; 3 5; 3 6; 5 6; 4 6; 4 5; 5 5; 6 6; 6 5; 3 7; 4 7; 5 7; 4 8];
%interior class tester
% nodes = [1 1; 2 1; 3 1; 4 1; 5 1; 1 2; 3 2; 5 2; 1 3; 3 3; 5 3; 1 4; 5 4; 2 5; 3 5; 4 5; 5 5]; %small version %Breaks on loop
%multi-breach test
% nodes = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3; 7 1; 7 2; 7 3];
% nodes = [1 1; 1 2; 1 3; 2 1; 2 2; 2 3; 3 1; 3 2; 3 3; 4 1; 4 2; 4 3; 5 1; 5 2; 5 3; 6 1; 6 2; 6 3; 7 1; 7 2; 7 3; 8 1; 8 2; 8 3]; %Breach imperfect (DnD stat rules needed?)

% nodes = [0 0;0 1;1 2;1 1;0 -1;0 2;2 1;1 0;2 0;0 3;-1 2;-1 0;-1 -1;2 -1;1 4;1 -1;2 2;-2 -2;1 -2;-2 -3;3 3;-3 -1;-1 3;3 1;0 4;-1 5;-1 1;-2 1;
%     3 0;-4 -2;1 5;-4 0;-1 -2;0 -2;2 4;0 5;1 6;-2 2;2 3;-1 -3;-2 5;2 -2;-3 0;4 3;0 -3;-2 -1;4 4;2 6;-3 2;5 3;-4 -1;2 -3;-2 0;-2 -4;-3 6;-1 6;
%     5 4;0 6;1 7;1 3;4 -1;4 0;-3 -3;-1 4;3 -1;4 1;1 -3;3 -3;4 2;-4 -3;2 5;-5 -3;-2 6;-3 5;3 2;-4 4;0 7;3 -2;3 -4;3 4;-1 7;0 8;2 8;-1 8;-1 -4;
%     -4 -4;3 7;5 0;-2 -5;-3 -6;3 6;5 2;6 4;-3 7;3 8;-1 -5;4 -2;-3 1;6 5;1 9;3 9;-3 -2;-2 -6;-3 -4;4 10;-2 4;1 -4;-4 2;4 5;-3 3;4 8;-4 7;5 5;
%     4 6;4 9;5 1;-4 6;-1 -6;3 11;2 11;1 10;6 3;7 5;2 7;0 10;-5 -2;5 -1;2 10;3 10;-2 7;-2 3;5 -2;2 9;1 11;-5 -1;3 12;-6 -1;-5 0;-3 -5;2 -4;-4 -6;
%     4 -3;5 9;-4 1;-2 -7;6 0;5 10;6 -1;1 8;-6 -2;5 -3;6 -3;-3 4;5 8;0 -5;7 -2;-2 8;6 -2;-1 9;3 5;-5 2;0 9;-6 -3;7 6;6 9;-4 8;-7 -3;6 -4;5 6;7 9;8 6;6 8;
%     -5 1;7 7;4 -4;7 8;-6 0;0 12;7 -3;4 7;1 -6;8 -4;7 4;2 -5;6 6;-3 8;-4 -5;-2 -8;-5 7;-6 2;8 -1;-6 1;-4 -7;5 7;-1 10;2 13;-5 -4;4 -5;-3 9;8 -2];
% nodes = [1 1; 2 1; 3 1; 4 1; 5 1; 6 1; 7 1; 8 1; 9 1; 10 1; 11 1; 12 1; 13 1; 14 1; 15 1; 16 1; 17 1; 
%     1 2; 2 2; 3 2; 4 2; 5 2; 6 2; 7 2; 8 2; 9 2; 10 2; 11 2; 12 2; 13 2; 14 2; 15 2; 16 2; 17 2; 18 2; 19 2; 20 2; 1 3; 2 3; 18 3; 19 3; 20 3;
%     1 4; 2 4; 18 4; 19 4; 20 4; 21 4; 22 4; 23 4; 24 4; 25 4; 1 5; 2 5; 17 5; 18 5; 21 5; 22 5; 23 5; 24 5; 25 5; 1 6; 2 6; 17 6; 18 6; 24 6; 25 6; 
%     1 7; 2 7; 24 7; 25 7; 1 8; 2 8; 24 8; 25 8; 1 9; 2 9; 24 9; 25 9; 1 10; 2 10; 24 10; 25 10; 1 11; 2 11; 24 11; 25 11; 1 12; 2 12; 24 12; 25 12; 1 13; 2 13; 24 13; 25 13; 1 14; 2 14; 24 14; 25 14; 1 15; 2 15; 24 15; 25 15; 1 16; 2 16; 24 16; 25 16; 1 17; 2 17; 24 17; 25 17;
%     11 7; 12 7; 13 7; 14 7; 15 7; 16 7; 17 7; 18 7; 11 8; 12 8; 13 8; 14 8; 15 8; 16 8; 17 8; 18 8; 11 9; 12 9;
%     11 10; 12 10; 13 10; 14 10; 15 10; 16 10; 18 10; 19 10; 20 10; 9 11; 10 11; 11 11; 12 11; 13 11; 14 11; 15 11; 16 11; 18 11; 19 11; 20 11;
%     9 12; 10 12; 13 12; 15 12; 16 12; 17 12; 18 12; 19 12; 20 12; 9 13; 10 13; 15 13; 16 13; 17 13; 20 13; 21 13;
%     9 14; 10 14; 20 14; 21 14; 9 15; 10 15; 17 15; 18 15; 19 15; 20 15; 21 15; 9 16; 10 16; 17 16; 18 16; 19 16; 20 16; 21 16;
%     9 17; 10 17; 13 17; 14 17; 15 17; 17 17; 18 17;
%     1 18; 2 18; 3 18; 4 18; 5 18; 6 18; 7 18; 10 18; 11 18; 12 18; 13 18; 14 18; 15 18; 17 18; 18 18; 19 18; 20 18; 21 18; 22 18; 23 18; 24 18; 25 18;
%     1 19; 2 19; 3 19; 4 19; 5 19; 6 19; 7 19; 10 19; 11 19; 12 19; 14 19; 15 19; 16 19; 17 19; 18 19; 19 19; 20 19; 21 19; 22 19; 23 19; 24 19; 25 19;
%     1 20; 2 20; 3 20; 6 20; 7 20; 8 20; 9 20; 10 20; 12 20; 14 20; 15 20; 16 20; 17 20; 18 20; 19 20;
%     6 21; 7 21; 8 21; 9 21; 
%     11 12; 12 12; 11 20];
%rand
% nodes = king_connected_points(2000);
%load
% nodes = load("nodes2KGood.mat").nodes;

nodesMinX = min(nodes(:,1))-1;
nodesMinY = min(nodes(:,2))-1;
numNodes = size(nodes,1);
nodes = nodes-[ones(numNodes,1)*nodesMinX ones(numNodes,1)*nodesMinY];

% Build global grid lookup once
[maxX,maxY] = deal(max(nodes(:,1)), max(nodes(:,2)));
gridMap = false(maxX+2,maxY+2);
idxGrid = zeros(maxX+2,maxY+2);

for i=1:size(nodes,1)
    gridMap(nodes(i,1),nodes(i,2)) = true;
    idxGrid(nodes(i,1),nodes(i,2)) = i;
end


% Start point
[~, topID] = max(nodes(:,2));
startPoint = nodes(topID,:);

% Initial classification
numNeighbor = countNeighbors_fast(nodes, gridMap);
intNodes = nodes(numNeighbor==8,:);
extNodes = nodes(numNeighbor~=8,:);

if doPlotting == 1
    figure(1); clf; hold on;
    scatter(nodes(:,1), nodes(:,2))
    axis equal
end

% ===================== STAGE 1 =====================
breakPhase = [startPoint + [1 1]; startPoint; startPoint + [1 -1]];
doTip2Tip = 1;
[path, added] = touchTips(extNodes, breakPhase, 8,doTip2Tip);
doTip2Tip = 0;


intNodes = [intNodes; extNodes(~added,:)];

if doPlotting == 1
    finalPath = plot(path(:,1),path(:,2),'r');
end
% ===================== STAGE 2 =====================
activeMask = []; %skips rechecking path nodes that can no longer connect
% missingPoints = nodes;
while ~isempty(intNodes)

    [path, intNodes, gridMap, activeMask] = eater_fast2(path, intNodes, gridMap, activeMask);


    gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;
    numNeighbor = countNeighbors_fast(intNodes, gridMap);
    extNodes = intNodes(numNeighbor~=8,:);
    intNodes = intNodes(numNeighbor==8,:);


    %Possibly useful items
    % CC8 = bwconncomp(gridMap, 8);
    % CC4 = bwconncomp(gridMap, 4);
    % labels8 = labelmatrix(CC8);
    % labels4 = labelmatrix(CC4);
    %check with same = labels(r1,c1) == labels(r2,c2);

    [numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask); 

    % validBreach = 0;
    % numNeighborPathTemp = numNeighborPath;
    % breachTry = 1;
    % breachTries = 4;
    % while validBreach == 0
    %     if breachTry <= breachTries
    %     [optBreakID,optReturnID] = breacher(numNeighborPath); 
    %     validBreach = labels4(path(optBreakID,1),path(optBreakID,2)) == labels4(path(optReturnID,1),path(optReturnID,2));
    %     numNeighborPathTemp(optBreakID,1) = 0;
    %     breachTry = breachTry +1;
    %     else
    %         [optBreakID,optReturnID] = breacher(numNeighborPath); 
    %         validBreach = labels8(path(optBreakID,1),path(optBreakID,2)) == labels8(path(optReturnID,1),path(optReturnID,2));
    %         numNeighborPathTemp(optBreakID,1) = 0;
    %         breachTry = breachTry +1;
    %     end
    %     if breachTry == breachTries+1
    %         numNeighborPathTemp = numNeighborPath;
    %     end
    % end

    [optBreakID,optReturnID] = breacher(numNeighborPath);
    optBreak = path(optReturnID,:);
    optReturn = path(optBreakID,:);
        
    if optReturnID == 1
        breakPhase = [path(end,:); path(1:optBreakID+1,:)];
    elseif optBreakID == numNodes
        breakPhase = [path(optReturnID-1:end,:); path(1,:)];
    else
        breakPhase = path(optReturnID-1:optBreakID+1,:); 
    end


    % Build path addition
    if optBreakID ~= optReturnID
        extNodesAug = [extNodes; optBreak; optReturn];
    else
        extNodesAug = [extNodes; optBreak];
    end
    [pathAddition, added] = touchTips(extNodesAug, breakPhase, 4,0);

    pathAddition = pathAddition(2:end-1,:);
    [pathAddition, cutNodes, cutNodesTrue] = cutPath_fast(pathAddition,1);

    if isempty(pathAddition) || numNeighborPath(optBreakID)<=1 || numNeighborPath(optReturnID)<=1 %fallback
        [pathAddition, added] = touchTips(extNodesAug, breakPhase, 8,0);
        pathAddition = (pathAddition(2:end-1,:));
        [pathAdditionTemp, cutNodes, cutNodesTrue] = cutPath_fast(pathAddition,0);
        if isempty(pathAdditionTemp)
            cutNodes = [];
        else
            pathAddition = pathAdditionTemp;
        end
        
        intNodes = [intNodes; extNodesAug(~added,:); cutNodes];
    else
        intNodes = [intNodes; extNodesAug(~added,:); cutNodesTrue];
    end

    % Splice
    if optBreakID ~= 1
        % Length of inserted segment
        k = size(pathAddition,1);
    
        % Update path
        path = [path(1:optReturnID,:); pathAddition; path(optBreakID:end,:)];
    
        % Update activeMask
        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [activeMask(1:optReturnID);          % preserved
                true(k,1);                          % NEW nodes → must be active
                activeMask(optBreakID:end)];          % preserved
        end
    
    else
        % Append case
        k = size(pathAddition,1);
        path = [path; pathAddition];
        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [activeMask; true(k,1)]; % NEW nodes 
        end
    end

    if doPlotting == 1
        delete(finalPath)
        finalPath = plot(path(:,1),path(:,2),'r');
        pause(plotSpeed)
    end
end

pathLength = size(path,1);
path = path + [ones(pathLength,1)*nodesMinX ones(pathLength,1)*nodesMinY];

if doPlotting ~= 0
    figure(2); clf; hold on; grid on;
    nodes = nodes+[ones(numNodes,1)*nodesMinX ones(numNodes,1)*nodesMinY];
    scatter(nodes(:,1),nodes(:,2),'b')
    plot(path(:,1),path(:,2),'r')
    axis equal; 
end

P = path;
dP = diff(P, 1, 1);   % (n-1)-by-2
% Euclidean distances between consecutive points
segment_lengths = sqrt(sum(dP.^2, 2));
% Total path length
pathLength = sum(segment_lengths);


end


% ==========================================================
% ===================== FUNCTIONS ===========================
% ==========================================================

function numNeighbor = countNeighbors_fast(points, grid)

offsets = [-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];
numNeighbor = zeros(size(points,1),1);

[rows, cols] = size(grid);

for k = 1:8
    nbr = points + offsets(k,:);

    % Valid index mask
    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & nbr(:,2) >= 1 & nbr(:,2) <= cols;

    % Only compute indices for valid entries
    idx = sub2ind([rows, cols], nbr(valid,1), nbr(valid,2));

    % Accumulate only valid contributions
    numNeighbor(valid) = numNeighbor(valid) + grid(idx);
end
end


function [runs, activeMask] = neighborRunLengths(path, extNodes, grid, activeMask)


offsets = [-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
nPath = size(path,1);

% Initialize mask if first call
if isempty(activeMask)
    activeMask = true(nPath,1);
end

runs = zeros(nPath,1);

% Build ext grid (same as before)
extGrid = false(size(grid));
extGrid(sub2ind(size(grid), extNodes(:,1), extNodes(:,2))) = true;

[rows, cols] = size(grid);



for i = find(activeMask)'   % ONLY iterate active points
    nbr = path(i,:) + offsets;

    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & nbr(:,2) >= 1 & nbr(:,2) <= cols;

    isNbr = false(8,1);

    idx = sub2ind([rows, cols], nbr(valid,1), nbr(valid,2));
    isNbr(valid) = extGrid(idx);

    % If no neighbors → permanently deactivate
    if ~any(isNbr)
        activeMask(i) = false;
        continue
    end

    % Circular run computation
    isNbrCirc = [isNbr; isNbr];

    maxRun = 0; cur = 0;
    for j = 1:16
        if isNbrCirc(j)
            cur = cur + 1;
            if cur > maxRun
                maxRun = cur;
            end
        else
            cur = 0;
        end
    end

    runs(i) = min(maxRun,8);
end
end



function [path, added] = touchTips(pts, breakPhase, connectivity,doTip2Tip)
debugPlotting = 0;
debugPlotPause = .001;
n = size(pts,1);
if size(breakPhase,1) == 3
    startPt = breakPhase(2,:);
    endPt = startPt;
    prevDir = endPt-breakPhase(1,:);
    addedLength = n-1;
else
    startPt = breakPhase(2,:);
    endPt = breakPhase(3,:);
    prevDir = endPt-startPt;
    addedLength = n;
end
% Directions
dirs8 = [0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
dirs4 = [0 1;-1 0;0 -1;1 0];
if connectivity==8
    dirs = dirs8;
else
    dirs = dirs4;
end



if connectivity == 4 && ~any(prevDir == 0)

    % Map 8-direction index → 4-direction index
    % Groups: (1,2)->1, (3,4)->2, (5,6)->3, (7,8)->4
    idx4 = ceil(dir2idx(prevDir)/2);

    % Wrap just in case
    idx4 = mod(idx4-1,4)+1;

    prevDir = dirs(idx4,:);
end


% Build local grid
maxX = max(pts(:,1)); maxY = max(pts(:,2));
localGrid = zeros(maxX+2,maxY+2);

for i=1:n
    if localGrid(pts(i,1),pts(i,2)) ==0
        localGrid(pts(i,1),pts(i,2)) = i;
    end
end

startIdx = localGrid(startPt(1),startPt(2));
endIdx   = localGrid(endPt(1),endPt(2));


%Determine Chirality ==== to do===
prevIdx = dir2idx(prevDir);
chiralityFound = 0;
while chiralityFound == 0
    for i=1:8
        checkPoint = startPt+dirs8(mod(prevIdx+i-1,8)+1,:);
        if localGrid(checkPoint(1),checkPoint(2)) ~= 0
            flipChirality = 1;
            chiralityFound = 1;
            break
        elseif all(breakPhase(1,:)==checkPoint)
            flipChirality = 0;
            chiralityFound = 1;
            break
        end
    end
end

if flipChirality
    dirs = flipud(dirs);
end


% Preallocate
pathA = zeros(n,1); ptrA = 1;
pathB = zeros(n,1); ptrB = 1;

addedA = false(n,1);
addedB = false(n,1);

pathA(ptrA) = startIdx;
pathB(ptrB) = endIdx;

addedA(startIdx) = true;
addedB(endIdx)   = true;

% Initialize walkers
currentPtA = startPt;
currentPtB = endPt;

prevDirA = prevDir;
prevDirB = -prevDir;

dirsA = dirs;
dirsB = flipud(dirs);

connectingIdx = -1;

while true

    % WALKER A ==========
    prevIdxA = find(dirsA(:,1)==prevDirA(1) & dirsA(:,2)==prevDirA(2),1);

    movedA = false;

    for step = 1:connectivity
        dirIdx = mod(prevIdxA + step - 1, connectivity) + 1;
        d = dirsA(dirIdx,:);

        cand = currentPtA + d;

        if cand(1) < 1 || cand(1) > size(localGrid,1) || cand(2) < 1 || cand(2) > size(localGrid,2)
            continue
        end

        idx = localGrid(cand(1),cand(2));

        if idx ~= 0
            ptrA = ptrA + 1;
            pathA(ptrA) = idx;
            if debugPlotting == 1
                plot([pts(pathA(ptrA-1),1);pts(pathA(ptrA),1)],[pts(pathA(ptrA-1),2);pts(pathA(ptrA),2)],'b') %Temp plot check 1
                pause(debugPlotPause)
            end

            % CHECK FOR MEETING (against B only)
            if addedB(idx) || idx == startIdx
                connectingIdx = idx;
                break
            end

            addedA(idx) = true;

            prevDirA = -d;
            currentPtA = pts(idx,:);
            

            movedA = true;
            break
        end
    end

    if connectingIdx ~= -1
        break
    end


    % WALKER B ==========
    if ~doTip2Tip
        prevIdxB = find(dirsB(:,1)==prevDirB(1) & dirsB(:,2)==prevDirB(2),1);
    
        movedB = false;
    
        for step = 1:connectivity
            dirIdx = mod(prevIdxB + step - 1, connectivity) + 1;
            d = dirsB(dirIdx,:);
    
            cand = currentPtB + d;
    
            if cand(1) < 1 || cand(1) > size(localGrid,1) || cand(2) < 1 || cand(2) > size(localGrid,2)
                continue
            end
    
            idx = localGrid(cand(1),cand(2));
    
            if idx ~= 0
                ptrB = ptrB + 1;
                pathB(ptrB) = idx;
                if debugPlotting == 1
                    plot([pts(pathB(ptrB-1),1);pts(pathB(ptrB),1)],[pts(pathB(ptrB-1),2);pts(pathB(ptrB),2)],'k') %Temp plot check 2
                    pause(debugPlotPause)
                end
    
                % CHECK FOR MEETING (against A only)
                if addedA(idx) || idx == endIdx
                    connectingIdx = idx;
                    break
                end
    
                addedB(idx) = true;
    
                prevDirB = -d;
                currentPtB = pts(idx,:);
                
    
                movedB = true;
                break
            end
        end
    
        if connectingIdx ~= -1
            break
        end
    
        % Safety
        if ~movedA && ~movedB
            break
        end
    end
end

% Trim paths
pathA = pathA(1:ptrA);
pathB = pathB(1:ptrB);

% ===== BUILD FINAL PATH =====
if connectingIdx ~= -1 && connectingIdx ~= startIdx

    % Trim A to connecting point
    idxA = find(pathA == connectingIdx,1);
    pathA = pathA(1:idxA);

    % Trim B to connecting point
    idxB = find(pathB == connectingIdx,1);
    pathB = pathB(1:idxB);

    % Combine (avoid duplicate connecting point)
    pathIdx = [pathA; flipud(pathB(1:end-1))];

    % Rebuild unified added mask
    added = false(n,1);
    added(pathIdx) = true;

else
    % Fallback
    pathIdx = pathA;

    added = false(n,1);
    added(pathIdx) = true;
end

% ===== SHRINK WRAP (UNCHANGED) =====
if connectivity==8
    unusedIdx = find(~added);

    for u=1:length(unusedIdx)
        pIdx = unusedIdx(u);
        p = pts(pIdx,:);

        for k=1:length(pathIdx)-1
            a = pts(pathIdx(k),:);
            b = pts(pathIdx(k+1),:);

            if abs(b(1)-a(1))==1 && abs(b(2)-a(2))==1
                if sum(abs(p-a))==1 && sum(abs(p-b))==1
                    pathIdx = [pathIdx(1:k); pIdx; pathIdx(k+1:end)];
                    added(pIdx)=true;
                    break
                end
            end
        end
    end
end
% if addedLength == n-1
%     added = added(1:end-1);
% end
path = pts(pathIdx,:);
end


function idx = dir2idx(d)
dirs = [0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
[~,idx] = ismember(d,dirs,'rows');
if idx==0, idx=1; end
end


function [optBreakID,optReturnID] = breacher(numNeighbor)

n = length(numNeighbor);

% Step 1: Copy and suppress high-degree nodes
nn = numNeighbor;
nn(nn >= 5) = 0;   % dis-incentivize ≥5

% Step 2: Circular pairing
nextVals = nn([2:end 1]);

% Step 3: Base score (prefer higher connectivity)
score = nn + nextVals;

% Step 4: Discard useless pairs (both zero)
invalid = (nn == 0) & (nextVals == 0);
score(invalid) = -inf;

% Step 5: Penalize equal pairs (unless ≤2)
equalMask = (nn == nextVals);
% lowEqual  = equalMask & (nn <= 2);   % allowed
highEqual = equalMask & (nn > 2);    % penalized

score(highEqual) = score(highEqual) - (max(score)+1);

% Step 6: Optional: slight penalty for single zero (encourage real connections)
singleZero = xor(nn==0, nextVals==0);
score(singleZero) = score(singleZero) - 0.5;

% Step 7: Pick best
[~, idx] = max(score);

optReturnID = idx;
optBreakID  = mod(idx, n) + 1;

% Step 8: Single-entry correction
if nn(optReturnID) == 0 && nn(optBreakID) ~= 0
    optReturnID = optBreakID;
elseif nn(optBreakID) == 0 && nn(optReturnID) ~= 0
    optBreakID = optReturnID;
end
end

function [optBreakID,optReturnID] = breacherMulti(numNeighbor,options) %options scales bad, best values are 2-5
%picking options is definitely a band-aid solution for what should be a bfs connectivity check
n = length(numNeighbor);

% Step 1: Copy and suppress high-degree nodes
nn = numNeighbor;
nn(nn >= 5) = 0;   % dis-incentivize ≥5

% Step 2: Circular pairing
nextVals = nn([2:end 1]);

% Step 3: Base score (prefer higher connectivity)
score = nn + nextVals;

% Step 4: Discard useless pairs (both zero)
invalid = (nn == 0) & (nextVals == 0);
score(invalid) = -inf;

% Step 5: Penalize equal pairs (unless ≤2)
equalMask = (nn == nextVals);
% lowEqual  = equalMask & (nn <= 2);   % allowed
highEqual = equalMask & (nn > 2);    % penalized

score(highEqual) = score(highEqual) - (max(score)+1);

% Step 6: Optional: slight penalty for single zero (encourage real connections)
singleZero = xor(nn==0, nextVals==0);
score(singleZero) = score(singleZero) - 0.5;

% Step 7: Pick best "options" options
for i=1:options
    [~, idx] = max(score);
    
    optReturnID(i) = idx;
    optBreakID(i)  = mod(idx, n) + 1;
    
    % Step 8: Single-entry correction
    if nn(optReturnID(i)) == 0 && nn(optBreakID(i)) ~= 0
        optReturnID(i) = optBreakID(i);
    elseif nn(optBreakID(i)) == 0 && nn(optReturnID(i)) ~= 0
        optBreakID(i) = optReturnID(i);
    end
end
end


function [pathCut, cutNodes, cutNodesTrue] = cutPath_fast(path, includePt)

[pathUnique, ia, ic] = unique(path,'rows','stable');

if numel(ia)==size(path,1)
    pathCut = path;
    cutNodes=[]; cutNodesTrue=[];
    return
end

pathCut = path;
cutNodes=[]; cutNodesTrue=[];

while true
    [~,ia,ic] = unique(pathCut,'rows','stable');

    if numel(ia)==size(pathCut,1)
        break
    end

    dup = find(histcounts(ic,1:max(ic)+1)>1,1);
    idx = find(ic==dup);

    firstID = idx(1);
    lastID  = idx(end);

    if includePt
        removeIdx = firstID:(lastID-1);
        retainingIdx = (firstID+1):(lastID-1);
    else
        removeIdx = firstID:lastID;
        retainingIdx = [];
    end

    cutNodes = unique([cutNodes; pathCut(removeIdx,:)],'rows','stable');
    cutNodesTrue = unique([cutNodesTrue; pathCut(retainingIdx,:)],'rows','stable');

    pathCut(removeIdx,:)=[];
end
end




function [path, intNodes, gridMap, activeMask] = eater(path, intNodes, gridMap, activeMask)
gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;
numNeighbor = countNeighbors_fast(intNodes, gridMap);
extNodes = intNodes(numNeighbor~=8,:);
intNodes = intNodes(numNeighbor==8,:);
[numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);


while any(numNeighborPath == 4) %while 4 continuous connections exist
    id4 = find(numNeighborPath == 4, 1);
    [~,idNextFlag] = max([numNeighborPath(id4-1),numNeighborPath(id4+1)]);
    if idNextFlag == 1
        breakPhase = path(id4-2:id4+1,:);
        optReturnID = id4-1;
    else
        breakPhase = path(id4-1:id4+2,:);
        optReturnID = id4;
    end
    optBreakID = optReturnID+1;


    % Build path addition
    dirs=[-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
    miniGroupCandidates = path(id4,:)+dirs;
    [tf, ~] = ismember(extNodes, miniGroupCandidates, 'rows'); 
    miniGroup = extNodes(tf, :);

    extNodesAug = [miniGroup; breakPhase(2,:); breakPhase(3,:)];
    [pathAddition, ~] = touchTips(extNodesAug, breakPhase, 4,0);
    pathAddition = pathAddition(2:end-1,:);
    intNodes = [intNodes; extNodes(~tf,:)];

    % Splice
    if optBreakID ~= 1
        % Length of inserted segment
        k = size(pathAddition,1);
        % Update path
        path = [path(1:optReturnID,:); pathAddition; path(optBreakID:end,:)];
    
        % Update activeMask
        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [activeMask(1:optReturnID);          % preserved
                true(k,1);                          % NEW nodes → must be active
                activeMask(optBreakID:end)];          % preserved
        end
    else %Basically Never Happens
        % Append case
        k = size(pathAddition,1);
        path = [path; pathAddition];
        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [activeMask; true(k,1)]; % NEW nodes 
        end
    end
    
    %Prep next itteration
    gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;
    numNeighbor = countNeighbors_fast(intNodes, gridMap);
    extNodes = intNodes(numNeighbor~=8,:);
    intNodes = intNodes(numNeighbor==8,:);
    [numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);
end
intNodes = [intNodes; extNodes];
end


function [path, intNodes, gridMap, activeMask] = eater_fast(path, intNodes, gridMap, activeMask)

% Initial grid update (only once)
gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;

% Initial classification
numNeighbor = countNeighbors_fast(intNodes, gridMap);
extNodes = intNodes(numNeighbor~=8,:);
intNodes = intNodes(numNeighbor==8,:);

% Build extGrid ONCE per outer state
extGrid = false(size(gridMap));
extGrid(sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2))) = true;

[numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);

dirs = [-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
[rows, cols] = size(gridMap);

while any(numNeighborPath == 4)

    id4 = find(numNeighborPath == 4, 1, 'first');

    % Choose direction
    [~,idNextFlag] = max([numNeighborPath(id4-1), numNeighborPath(id4+1)]);
    if idNextFlag == 1
        breakPhase = path(id4-2:id4+1,:);
        optReturnID = id4-1;
    else
        breakPhase = path(id4-1:id4+2,:);
        optReturnID = id4;
    end
    optBreakID = optReturnID+1;

    % ============================================================
    % FAST miniGroup extraction (NO ismember)
    % ============================================================
    miniGroupCandidates = path(id4,:) + dirs;

    valid = miniGroupCandidates(:,1)>=1 & miniGroupCandidates(:,1)<=rows & ...
            miniGroupCandidates(:,2)>=1 & miniGroupCandidates(:,2)<=cols;

    miniGroupCandidates = miniGroupCandidates(valid,:);

    idx = sub2ind(size(gridMap), miniGroupCandidates(:,1), miniGroupCandidates(:,2));
    miniGroup = miniGroupCandidates(extGrid(idx),:);

    % ============================================================
    % Build path addition
    % ============================================================
    extNodesAug = [miniGroup; breakPhase(2,:); breakPhase(3,:)];
    [pathAddition, ~] = touchTips(extNodesAug, breakPhase, 4,0);
    pathAddition = pathAddition(2:end-1,:);

    % Remove used extNodes via grid instead of ismember
    usedMask = false(size(extNodes,1),1);
    if ~isempty(miniGroup)
        tempGrid = false(size(gridMap));
        tempGrid(sub2ind(size(gridMap), miniGroup(:,1), miniGroup(:,2))) = true;

        idxExt = sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2));
        usedMask = tempGrid(idxExt);
    end

    intNodes = [intNodes; extNodes(~usedMask,:)];

    % ============================================================
    % Splice path + update activeMask
    % ============================================================
    if optBreakID ~= 1
        k = size(pathAddition,1);

        path = [path(1:optReturnID,:); pathAddition; path(optBreakID:end,:)];

        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [
                activeMask(1:optReturnID);
                true(k,1);
                activeMask(optBreakID:end)
            ];
        end
    else
        k = size(pathAddition,1);

        path = [path; pathAddition];

        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [activeMask; true(k,1)];
        end
    end

    % ============================================================
    % Incremental grid update (ONLY new nodes)
    % ============================================================
    if ~isempty(pathAddition)
        idxNew = sub2ind(size(gridMap), pathAddition(:,1), pathAddition(:,2));
        gridMap(idxNew) = false;
    end

    % ============================================================
    % Recompute sets (could be further optimized if needed)
    % ============================================================
    numNeighbor = countNeighbors_fast(intNodes, gridMap);
    extNodes = intNodes(numNeighbor~=8,:);
    intNodes = intNodes(numNeighbor==8,:);

    % Rebuild extGrid (cheap, linear)
    extGrid(:) = false;
    if ~isempty(extNodes)
        extGrid(sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2))) = true;
    end

    [numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);%Running this each loop makes things way slower

end

intNodes = [intNodes; extNodes];

end





function [path, intNodes, gridMap, activeMask] = eater_fast2(path, intNodes, gridMap, activeMask)

% Initial grid update (only once)
gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;

% Initial classification
numNeighbor = countNeighbors_fast(intNodes, gridMap);
extNodes = intNodes(numNeighbor~=8,:);
intNodes = intNodes(numNeighbor==8,:);

% Build extGrid ONCE per outer state
extGrid = false(size(gridMap));
extGrid(sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2))) = true;

[numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);

dirs = [-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
[rows, cols] = size(gridMap);

while any(numNeighborPath == 4)
    candidates = find(numNeighborPath == 4);
    candidateOffset = 0;
    for i = 1:size(candidates,1)
        id4 = candidates(i,1) + candidateOffset;
        %check if valid
        if neighborRunLengths(path(id4,:),extNodes,gridMap,1) == 4 %can probably do numNeighbors>=4


            % id4 = find(numNeighborPath == 4, 1, 'first');
        
            % Choose direction
            [~,idNextFlag] = max([numNeighborPath(id4-candidateOffset-1), numNeighborPath(id4-candidateOffset+1)]);
            if idNextFlag == 1
                breakPhase = path(id4-2:id4+1,:);
                optReturnID = id4-1;
            else
                breakPhase = path(id4-1:id4+2,:);
                optReturnID = id4;
            end
            optBreakID = optReturnID+1;
        
            % ============================================================
            % FAST miniGroup extraction (NO ismember)
            % ============================================================
            miniGroupCandidates = path(id4,:) + dirs;
        
            valid = miniGroupCandidates(:,1)>=1 & miniGroupCandidates(:,1)<=rows & ...
                    miniGroupCandidates(:,2)>=1 & miniGroupCandidates(:,2)<=cols;
        
            miniGroupCandidates = miniGroupCandidates(valid,:);
        
            idx = sub2ind(size(gridMap), miniGroupCandidates(:,1), miniGroupCandidates(:,2));
            miniGroup = miniGroupCandidates(extGrid(idx),:);
        
            % ============================================================
            % Build path addition
            % ============================================================
            extNodesAug = [miniGroup; breakPhase(2,:); breakPhase(3,:)];
            [pathAddition, ~] = touchTips(extNodesAug, breakPhase, 4,0);
            pathAddition = pathAddition(2:end-1,:);
        
            % Remove used extNodes via grid instead of ismember
            usedMask = false(size(extNodes,1),1);
            if ~isempty(miniGroup)
                tempGrid = false(size(gridMap));
                tempGrid(sub2ind(size(gridMap), miniGroup(:,1), miniGroup(:,2))) = true;
        
                idxExt = sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2));
                usedMask = tempGrid(idxExt);
            end
        
            intNodes = [intNodes; extNodes(~usedMask,:)];
        
            % ============================================================
            % Splice path + update activeMask
            % ============================================================
            if optBreakID ~= 1
                k = size(pathAddition,1);
        
                path = [path(1:optReturnID,:); pathAddition; path(optBreakID:end,:)];
        
                if isempty(activeMask)
                    activeMask = true(size(path,1),1);
                else
                    activeMask = [
                        activeMask(1:optReturnID);
                        true(k,1);
                        activeMask(optBreakID:end)
                    ];
                end
            else
                k = size(pathAddition,1);
        
                path = [path; pathAddition];
        
                if isempty(activeMask)
                    activeMask = true(size(path,1),1);
                else
                    activeMask = [activeMask; true(k,1)];
                end
            end
        
            % ============================================================
            % Incremental grid update (ONLY new nodes)
            % ============================================================
            if ~isempty(pathAddition)
                idxNew = sub2ind(size(gridMap), pathAddition(:,1), pathAddition(:,2));
                gridMap(idxNew) = false;
                candidateOffset = candidateOffset+4;
            end
        
            % ============================================================
            % Recompute sets (could be further optimized if needed)
            % ============================================================
            numNeighbor = countNeighbors_fast(intNodes, gridMap);
            extNodes = intNodes(numNeighbor~=8,:);
            intNodes = intNodes(numNeighbor==8,:);
        
            % Rebuild extGrid (cheap, linear)
            extGrid(:) = false;
            if ~isempty(extNodes)
                extGrid(sub2ind(size(gridMap), extNodes(:,1), extNodes(:,2))) = true;
            end
            
        end

    end
    [numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);%Running this each loop makes things way slower
end

intNodes = [intNodes; extNodes];

end



