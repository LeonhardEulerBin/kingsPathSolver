function path = clusterBusterTraveler(nodes) %Based on clusterBuster_V1_2 (The ChatGPT efficiency boosted version) Last adjusted 4/1/2026


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

% ===================== STAGE 1 =====================
prevDirIdx = 7; % corresponds to [1 0]
flipChirality = 0;

[path, added] = orderGridPath_fast(extNodes, startPoint, startPoint, prevDirIdx, flipChirality, 8);

intNodes = [intNodes; extNodes(~added,:)];

% ===================== STAGE 2 =====================
activeMask = []; %skips rechecking path nodes that can no longer connect
missingPoints = nodes;
while ~isempty(intNodes)

    gridMap(sub2ind(size(gridMap), path(:,1), path(:,2))) = false;
    numNeighbor = countNeighbors_fast(intNodes, gridMap);
    extNodes = intNodes(numNeighbor~=8,:);
    intNodes = intNodes(numNeighbor==8,:);

    [numNeighborPath, activeMask] = neighborRunLengths(path, extNodes, gridMap, activeMask);

    [optBreakID,optReturnID] = breacher(numNeighborPath);

    optBreak = path(optReturnID,:);
    optReturn = path(optBreakID,:);

    % Direction
    if optBreakID ~= optReturnID
        breachDir = optBreak-optReturn;
    elseif optBreakID ~=1
        breachDir = path(optBreakID-1,:)-path(optBreakID,:);
    else
        breachDir = path(end,:)-path(optBreakID,:);
    end
    breachDir = -breachDir;

    % Chirality
    rot = [0 -1; 1 0];
    flipChirality = ~(ismember(optBreak + breachDir*rot, extNodes,'rows') || ismember(optReturn + breachDir*rot, extNodes,'rows'));

    % Build path addition
    extNodesAug = [extNodes; optBreak; optReturn];

    [pathAddition, added] = orderGridPath_fast(extNodesAug, optBreak, optReturn, dir2idx(breachDir), flipChirality, 4);

    pathAddition = pathAddition(2:end-1,:);
    [pathAddition, cutNodes, cutNodesTrue] = cutPath_fast(pathAddition,1);

    if isempty(pathAddition) || numNeighborPath(optBreakID)<=1 || numNeighborPath(optReturnID)<=1
        [pathAddition, added] = orderGridPath_fast(extNodesAug, optBreak, optReturn, dir2idx(breachDir), flipChirality, 8);
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
            activeMask = [
                activeMask(1:optReturnID);          % preserved
                true(k,1);                          % NEW nodes → must be active
                activeMask(optBreakID:end)          % preserved
            ];
        end
    
    else
        % Append case
        k = size(pathAddition,1);
    
        path = [path; pathAddition];
    
        if isempty(activeMask)
            activeMask = true(size(path,1),1);
        else
            activeMask = [
                activeMask;
                true(k,1)   % NEW nodes
            ];
        end
    end



    %Final checks
    pathSize = size(path,1);
    pathPercent = (pathSize/numNodes)*100;
    if pathPercent<=100
        % fprintf("Progress: %d of %d | %.2f%%\n", pathSize, numNodes, pathPercent);
    else
        [tf, ~] = ismember(missingPoints, path, 'rows');
        allPointsIncluded = all(tf);
        if allPointsIncluded
            % disp('All points included.');
            break
        else
            % Optional: display missing points
            missingPoints = missingPoints(~tf, :);
            % fprintf("Points Remaining %d \n",size(missingPoints,1));
        end
    end
end

pathLength = size(path,1);
path = path + [ones(pathLength,1)*nodesMinX ones(pathLength,1)*nodesMinY];

end

% ==========================================================
% Support Functions
% ==========================================================

function numNeighbor = countNeighbors_fast(points, grid)

offsets = [-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];
numNeighbor = zeros(size(points,1),1);

[rows, cols] = size(grid);

for k = 1:8
    nbr = points + offsets(k,:);

    % Valid index mask
    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & ...
            nbr(:,2) >= 1 & nbr(:,2) <= cols;

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

    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & ...
            nbr(:,2) >= 1 & nbr(:,2) <= cols;

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


function [path, added] = orderGridPath_fast(pts, startPt, endPt, prevDir, flipChirality, connectivity)

n = size(pts,1);

% Preserve original behavior
if ~all(startPt == endPt)
    added = false(n,1);
else
    added = false(n-1,1);
end

% Directions
if connectivity==8
    dirs = [0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
else
    dirs = [0 1;-1 0;0 -1;1 0];
end



% ===== NORMALIZE prevDir INPUT =====
if isscalar(prevDir)
    % Ensure index is in 1–8
    prevDir = mod(prevDir-1,8)+1;

    if connectivity == 8
        % Direct mapping
        prevDir = dirs(prevDir,:);
    else
        % Map 8-direction index → 4-direction index
        % Groups: (1,2)->1, (3,4)->2, (5,6)->3, (7,8)->4
        idx4 = ceil(prevDir/2);

        % Wrap just in case
        idx4 = mod(idx4-1,4)+1;

        prevDir = dirs(idx4,:);
    end
end

if flipChirality
    dirs = flipud(dirs);
end

% Build local grid
maxX = max(pts(:,1)); maxY = max(pts(:,2));
localGrid = zeros(maxX+2,maxY+2);

for i=1:n
    localGrid(pts(i,1),pts(i,2)) = i;
end

startIdx = localGrid(startPt(1),startPt(2));
endIdx   = localGrid(endPt(1),endPt(2));

% Preallocate
pathIdx = zeros(n,1);
ptr = 1;

pathIdx(ptr) = startIdx;
added(startIdx) = true;

currentIdx = startIdx;
currentPt = pts(currentIdx,:);

while true

    % Recompute prevIdx EXACTLY like original
    prevIdx = find(dirs(:,1)==prevDir(1) & dirs(:,2)==prevDir(2),1);

    moved = false; % <-- important fix

    for step = 1:connectivity
        dirIdx = mod(prevIdx + step - 1, connectivity) + 1;
        d = dirs(dirIdx,:);

        cand = currentPt + d;

        % Bounds check
        if cand(1) < 1 || cand(1) > size(localGrid,1) || ...
           cand(2) < 1 || cand(2) > size(localGrid,2)
            continue
        end

        idx = localGrid(cand(1),cand(2));

        if idx ~= 0
            ptr = ptr + 1;
            pathIdx(ptr) = idx;
            added(idx) = true;

            if idx == endIdx
                break
            end

            prevDir = -d; % EXACT match to original
            % currentIdx = idx;
            currentPt = pts(idx,:);

            moved = true;
            break
        end
    end

    % Safety: if no move found, break (prevents infinite loop)
    if ~moved
        break
    end

    if pathIdx(ptr) == endIdx
        break
    end
end

pathIdx = pathIdx(1:ptr);

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