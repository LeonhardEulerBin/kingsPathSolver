clc; clear; format compact; format long g;
doPlotting = 1; %0 = no plot, 1 = plot, 2 = final plot
plotSpeed = .01;
% load nodes
nodes = load("nodes2KGood.mat").nodes; % nodesJavCluster nodes2KGood
% nodes= [nodes(:,2), nodes(:,1)];

%Shift to 1st quadrant
nodesMinX = min(nodes(:,1))-1;
nodesMinY = min(nodes(:,2))-1;
numNodes = size(nodes,1);
nodes = nodes-[ones(numNodes,1)*nodesMinX ones(numNodes,1)*nodesMinY];

%plot
if doPlotting == 1
    figure(1); clf; hold on;
    scatter(nodes(:,1), nodes(:,2))
    axis equal
end

% Build global grid lookup once, gridMap = unused node map
[maxX,maxY] = deal(max(nodes(:,1)), max(nodes(:,2)));
gridMap = false(maxX+2,maxY+2);
idxGrid = zeros(maxX+2,maxY+2);
for i=1:size(nodes,1)
    gridMap(nodes(i,1),nodes(i,2)) = true;
    % idxGrid(nodes(i,1),nodes(i,2)) = i;
end
for i=1:size(nodes,1) %NOT IMPLEMENTED YER
    % gridMap(nodes(i,1),nodes(i,2)) = true;
    idxGrid(nodes(i,1),nodes(i,2)) = ((nodes(i,2)-1)*(maxX+2))+nodes(i,1);
end

% Pick easy arbitrary Start point
[~, topID] = max(nodes(:,2));
startPoint = nodes(topID,:);

% Initial classification
% numNeighbor = countNeighbors_fast(nodes, gridMap, 8);
% intNodes = nodes(numNeighbor==8,:); %change to int nodes being unadded nodes
% extNodes = nodes(numNeighbor~=8,:); %move calculation into touchTIps()

% ====================================================================================
% Stage 1: 8 connectivity full wrap (Necessisarily least efficient pathing)
% ====================================================================================
breakPhase = [startPoint + [1 1]; startPoint; startPoint + [1 -1]]; %entry parameters
[path, addedMap]= touchTips(gridMap, breakPhase, 8, 1, 0); %entry, 8con, tip2tip, noReversal
gridMap = gridMap-addedMap; %put extra nodes back into intNodes
%plot
if doPlotting == 1
    finalPath = plot(path(:,1),path(:,2),'r');
end


% ====================================================================================
% Stage 2: Loopable 4-connectivity Space filling
% ====================================================================================

%! Try 4 Eater Loop (Geometry Based)
    %Better eater follows 4-connectivity, looks at connected perps, and reverses chirality.
    % Maybe calculates all separately and culls overlapping potential additions to maximize nodes added?
    %Eat if entry points are 1-connected in 4con (check candidates, not whole graph)
    % maybe better to prioritize minimizing captive singles (culls of 1 from cutter) (maybe problematic but worth a try)
        % nah, minimize left over 1-connected entry points (ex: 3 options: 1 big overlaps, 1 small, 1 medium. Select medium)
    %!splicer()

%!Neighbor runs (useful for breacher)

%! breachLister()
    %Prioritize corners (2-2+ in 8con) (1-1+ in 4con, less telling), 
        %challenge with double clusters, runLength<numNeigh
    %flag loners? (1-1 in 8con) (0-1 in 4con), may be easier to look at size 1 connectivity groups
    %less than 2 can be ignored for 4add, but important for 8add

%!4add
    % check breach connectivity to consider valid (outside this function when pair chosen)
    %if entry points on opposite clusters try next breach 
    %! Try 4 touchingTips (no shrink wrap so int vs ext doesn't matter, all non-path can be useable int)
    %cut leaves as usual (empty result shouldn't be possible here)
%!splicer()


%! 8add
    % calculate extNodes
    % 8 touchingTips, once no 4adds can be done
    %cut leaves and check if empty. if empty, progress 1 cut in and try again. maybe rewrite cutter to be smarter
        %cutter: if cutting == empty && all repeats inside, include all. if cutting == empty && non repeats exist inside, move in 1 cut.
    %return unadded to intNodes
    % followed by checking the added segment for possible 4adds
    %if 4adds possible, go to beginning of stage 2, else continue 8adds
%!splicer()





%Stage 2 Loop starts with int nodes correct, grid map needs updating
% activeMask = []; %skips rechecking path nodes that can no longer connect
activeMask = ones(size(path,1),1);%addedMap; %checkable points
intNodesLeft = sum(sum(gridMap));
while intNodesLeft>0
    % gridMap = gridMap-addedMap; %put extra nodes back into intNodes, MOVE TO AFTER ADDITIONS
    
    % CC4 = bwconncomp(gridMap, 4);
    % labels4 = labelmatrix(CC4);
    % ===================================
    %Eater (room for improvement in segCuller)
    % ===================================
    while 1
        [numNeighborPath, activeMask] = neighborRunLengths(path, gridMap, activeMask);
        eatSegs = eatable(path,gridMap,activeMask, numNeighborPath);
        if isempty(eatSegs)
            break
        end
        pathLeng = size(path,1);
        [path, gridMap, activeMask] = eater(path, gridMap, activeMask, eatSegs);
    
        % if doPlotting == 1
        %     delete(finalPath)
        %     finalPath = plot(path(:,1),path(:,2),'r');
        % end
        if pathLeng == size(path,1) %break if none added
            break
        end
    end
    if doPlotting == 1
        delete(finalPath)
        finalPath = plot(path(:,1),path(:,2),'r');
    end
    % ===================================
    %breachLister()
    % ===================================
    [cand4con, cand8con] = breachLister(path, activeMask, numNeighborPath, gridMap); % 100% can be improved/vectorized


    % ===================================
    %4add
    % ===================================
    if ~isempty(cand4con)
        for i=1:size(cand4con,1)
            if cand4con(i,1) == cand4con(i,2)
                breakPhase = path(cand4con(i,1)-1:cand4con(i,1)+1,:); %needs wrap protection
            else
                breakPhase = path(cand4con(i,1)-1:cand4con(i,1)+2,:); %needs wrap protection
            end
            [newSeg, addedMap]= touchTips(gridMap, breakPhase, 4, 0, 0);
            newSeg = cutter(newSeg, 1);
            if ~isempty(newSeg)
                newSeg=newSeg(2:end-1,:);
                [path, activeMask, gridMap] = pathAdder(path,newSeg, activeMask, cand4con(i,:), gridMap);
                % gridMap = gridMap-addedMap;
                break
            end
        end
        if doPlotting == 1
            delete(finalPath)
            finalPath = plot(path(:,1),path(:,2),'r');
        end
    elseif ~isempty(cand8con)
        for i=1:size(cand8con,1)
            if cand8con(i,1) == cand8con(i,2)
                breakPhase = path(cand8con(i,1)-1:cand8con(i,1)+1,:); %needs wrap protection
            else
                breakPhase = path(cand8con(i,1)-1:cand8con(i,1)+2,:); %needs wrap protection
            end
            [newSeg, addedMap]= touchTips(gridMap, breakPhase, 8, 0, 0);
            newSeg = cutter(newSeg, 1);
            if ~isempty(newSeg)
                newSeg=newSeg(2:end-1,:);
                [path, activeMask, gridMap] = pathAdder(path,newSeg, activeMask, cand8con(i,:), gridMap);
                % gridMap = gridMap-addedMap;
                break
            end
        end
        if doPlotting == 1
            delete(finalPath)
            finalPath = plot(path(:,1),path(:,2),'r');
        end
    end
end
bees = 2



















% ====================================================================================
% Functions
% ====================================================================================


function numNeighbor = countNeighbors_fast(nodes, gridMap, connectivity)
% nodes = input set
% gridMap = look-up map of input set
% connectivity = 4 vs 8 connectivity
% numNeighbor = numNeighbor in given connectivity space
if connectivity == 8
    offsets = [-1 -1;-1 0;-1 1;0 -1;0 1;1 -1;1 0;1 1];
elseif connectivity == 4
    offsets = [-1 0;0 -1;0 1;1 0;];
end
numNeighbor = zeros(size(nodes,1),1);

[rows, cols] = size(gridMap);

for k = 1:connectivity
    nbr = nodes + offsets(k,:);

    % Valid index mask
    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & nbr(:,2) >= 1 & nbr(:,2) <= cols;

    % Only compute indices for valid entries
    idx = sub2ind([rows, cols], nbr(valid,1), nbr(valid,2));

    % Accumulate only valid contributions
    numNeighbor(valid) = numNeighbor(valid) + gridMap(idx);
end
end

function [path, addedMap] = touchTips(gridMap, breakPhase, connectivity, doTip2Tip, reverseChirality)
debugPlotting = 0;
debugPlotPause = .001;
% nodes = input set
% gridMap = look-up map of input set
% breakPhase = starting seed
% connectivity = 8 or 4 (for dirs)
% doTip2Tip (if 1, then only moves from 1 sided. if 0, then 2 sided. Only useful on first round)
% reverseChirality = 1 for hugging against the path (used for the eater)
% path = added segment (including leaves)
% addedMap = map of added points

%function plan
    %Determine chirality (possible in always 8con)
        %Map previous direction to connectivity space
        %Check if a given direction works, else flip chirality
        %if reverseChirality, flip result
    %if 8 con
        % determine extNodes

    %set path parameters
        %!(it'd be good to know if connected here)
    %wrap through available nodes
        %folloiwng chiralaity
            % find next A
            %add to pathA if valid
            % check if in B or a terminus
                %if true, terminate
            %find next B
            %add to pathB if valid
            %check if in A or a terminus
                %if true, terminate
            %if 8con
                %set extNodes as added
    %Stitch together
    %if 8 con
        % shrinkwrap to unadded extNodes
    %manage path and added


%setup
%Handle single entries
if size(breakPhase,1) == 3 
    startPt = breakPhase(2,:);
    endPt = startPt;
    prevDir{1} = endPt-breakPhase(1,:);
else
    startPt = breakPhase(2,:);
    endPt = breakPhase(3,:);
    prevDir{1} = endPt-startPt;
end
% Directions
dirs8 = [0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
dirs4 = [0 1;-1 0;0 -1;1 0];
if connectivity==8
    dirs = dirs8;
else
    dirs = dirs4;
end

%Chirality check (always in 8con)
prevDirIdx = dir2idx(prevDir{1});
chiralityFound = 0;
while chiralityFound == 0
    for i=1:8
        checkPoint = startPt+dirs8(mod(prevDirIdx+i-1,8)+1,:);
        if gridMap(checkPoint(1),checkPoint(2)) ~= 0
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
% %reverse finding as instructed
% if reverseChirality == 1 %maybe move after 1st step
%     flipChirality = ~flipChirality;
% end
%flip chirality as determined
if flipChirality
    dirs = flipud(dirs);
end

%8con prep
if connectivity == 8
    [mapR, mapC] = find(gridMap);
    nodes = [mapR mapC];
    numNeighbor = countNeighbors_fast(nodes, gridMap, 8); %PROBALY A BIG INEFFICINECY TO CHECK ALL NODES ONCE TO AVOID CHECKING ALL NODES ONCE
    % intNodes = nodes(numNeighbor==8,:); %change to int nodes being unadded nodes
    nodes = nodes(numNeighbor~=8,:); %set useable nodes as ext only

    %CREATE EXTMAP
    extMap = false(size(gridMap,1),size(gridMap,2));
    for i=1:size(nodes,1)
        extMap(nodes(i,1),nodes(i,2)) = true;
    end
end

if connectivity == 4 && ~any(prevDir{1} == 0) %remap 8space to 4space
    % Map 8-direction index → 4-direction index
    % Groups: (1,2)->1, (3,4)->2, (5,6)->3, (7,8)->4
    idx4 = ceil(dir2idx(prevDir{1})/2);

    % Wrap just in case
    idx4 = mod(idx4-1,4)+1;

    prevDir{1} = dirs(idx4,:);
end

gridSize = size(gridMap);
n=sum(sum(gridMap));


% Preallocate
subPath{1} = zeros(n,2); subPath{2} = zeros(n,2); 
ptr(1) = 1; ptr(2) = 1;
addedMap{1} = zeros(gridSize(1),gridSize(2)); addedMap{2} = addedMap{1};
subPath{1}(1,:) = startPt; subPath{2}(1,:) = endPt;
addedMap{1}(startPt(1),startPt(2)) = 1; addedMap{2}(endPt(1),endPt(2)) = 1;


% Initialize walkers
currentPt{1} = startPt;
currentPt{2} = endPt;

prevDir{1} = prevDir{1};
prevDir{2} = -prevDir{1};

subDirs{1} = dirs;
subDirs{2} = flipud(dirs);

connectingPt = [];

%POTENTIALLY USEFUL
CC = bwconncomp(gridMap, connectivity);
labels = labelmatrix(CC);
disconnected=0;

if doTip2Tip == 1
    branches = 1;
else 
    branches = 2;
end
moved = false(branches);

while true
    % ==========
    % WALKER
    % ==========
    for branNum = 1:branches
        if ptr(branNum) == 2 && reverseChirality == 1
            subDirs{branNum} = flipud(subDirs{branNum});
        end
        prevDirIdx = find(subDirs{branNum}(:,1)==prevDir{branNum}(1) & subDirs{branNum}(:,2)==prevDir{branNum}(2),1);
    
        moved(branNum) = false;
    
        for step = 1:connectivity
            dirIdx = mod(prevDirIdx + step - 1, connectivity) + 1;
            d = subDirs{branNum}(dirIdx,:);
            cand = currentPt{branNum} + d;
            if cand(1) < 1 || cand(1) > gridSize(1) || cand(2) < 1 || cand(2) > gridSize(2) %Check if outside map
                continue
            end    
            if gridMap(cand(1),cand(2)) ~= 0
                ptr(branNum) = ptr(branNum) + 1;
                subPath{branNum}(ptr(branNum),:) = cand;
                if debugPlotting == 1
                    plot([subPath{branNum}(ptr(branNum)-1,1);subPath{branNum}(ptr(branNum),1)],[subPath{branNum}(ptr(branNum)-1,2);subPath{branNum}(ptr(branNum),2)],'b') %Temp plot check 1
                    pause(debugPlotPause)
                end
                % CHECK FOR MEETING (against opposite branch or start point)
                if addedMap{mod(branNum+2,2)+1}(cand(1),cand(2)) ~= 0 || all(cand==subPath{branNum}(1,:))
                    connectingPt = cand;
                    connectedOn = branNum;
                    break
                end
                if addedMap{branNum}(cand(1),cand(2)) == 0
                    addedMap{branNum}(cand(1),cand(2)) = ptr(branNum);
                end
                prevDir{branNum} = -d;
                currentPt{branNum} = cand;
                moved(branNum) = true;
                break
            end
            if ~moved(branNum) && step == connectivity % break if unable to move
                disconnected =1;
                break
            end
        end
    
        if ~isempty(connectingPt) || (~moved(branNum) && step == connectivity) %end on found connection OR unable to move
            break
        end
    end

    % Safety
    if branches == 2
        if ~moved(1) && ~moved(2)
            break
        end
    
        %Connectivity check
        if ptr(1) == 2 && labels(subPath{1}(2,1),subPath{1}(2,2)) ~= labels(subPath{2}(2,1),subPath{2}(2,2))
            disconnected =1;
            break
        end
    end
    if ~isempty(connectingPt)
        break
    end

end

if disconnected == 1
    path = [];
else
    % BUILD FINAL PATH
    if ~all(connectingPt == startPt)
        if connectedOn == 1
            subPath{1} = subPath{1}(1:ptr(1),:);
            ptr(2) = addedMap{2}(connectingPt(1,1),connectingPt(1,2));
            subPath{2} = subPath{2}(1:ptr(2),:);
            path = [subPath{1}; flipud(subPath{2}(1:end-1,:))];
        elseif connectedOn == 2
            ptr(1) = addedMap{1}(connectingPt(1,1),connectingPt(1,2));
            subPath{1} = subPath{1}(1:ptr(1),:);
            subPath{2} = subPath{2}(1:ptr(2),:);
            path = [subPath{1}; flipud(subPath{2}(1:end-1,:))];
        end
        addedMap = (addedMap{1}>0 & addedMap{1}<=ptr(1)) | (addedMap{2}>0 & addedMap{2}<=ptr(2));
    else
        % Fallback
        subPath{1} = subPath{1}(1:ptr(1),:);
        path = subPath{1};
        addedMap = (addedMap{1}>0);
    end
    
    
    % SHRINK WRAP
    if connectivity==8
        compMap = extMap - addedMap;
        compMap(startPt(1),startPt(2)) = false;
        compMap(endPt(1),endPt(2)) = false;
        unusedIdx = find(compMap); %DOESN"T FACTOR IN START AND END PTS PROPERLY, do this up higher somewhere
        
        [row, col] = ind2sub(size(extMap), unusedIdx);
    
        for u=1:length(unusedIdx)
            p = [row(u), col(u)]; 
    
            for k=1:length(path)-1
                a = path(k,:);
                b = path(k+1,:);
    
                if abs(b(1)-a(1))==1 && abs(b(2)-a(2))==1
                    if sum(abs(p-a))==1 && sum(abs(p-b))==1
                        path = [path(1:k,:); [row(u), col(u)]; path(k+1:end,:)];
                        addedMap(row(u), col(u))=true;
                        break
                    end
                end
            end
        end
    end
end
end

function idx = dir2idx(d)
dirs = [0 1;-1 1;-1 0;-1 -1;0 -1;1 -1;1 0;1 1];
[~,idx] = ismember(d,dirs,'rows');
if idx==0, idx=1; end
end

function [runs, activeMask] = neighborRunLengths(path, gridMap, activeMask)
%Path = checkable indices
%gridMap = valid neighbor map
%activeMask = valid checkable index map (probably don't need to use path), if 0 neighbors found: set as 0.
%numNeighborPath = num of continuous neighbors

dirs = [-1 -1;-1 0;-1 1;0 1;1 1;1 0;1 -1;0 -1];
nPath = size(path,1);
runs = zeros(nPath,1);
[rows, cols] = size(gridMap);
for i = find(activeMask)'   % ONLY iterate active points
    nbr = path(i,:) + dirs;
    valid = nbr(:,1) >= 1 & nbr(:,1) <= rows & nbr(:,2) >= 1 & nbr(:,2) <= cols;
    isNbr = false(8,1);
    idx = sub2ind([rows, cols], nbr(valid,1), nbr(valid,2));
    isNbr(valid) = gridMap(idx);

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

function eatSegs = eatable(path,gridMap,activeMask, numNeighborPath) %Begging for a ChatGPT efficiency overhaul
n = size(path,1);
augPath = [path; path(1:2,:)];
straightSegs = [];
diagSegs = [];
R = [0 -1 ; 1 0];
R3 = -R;
for i = find(activeMask)'
    % if numNeighborPath(mod(i,n)+1) ~= 5 && numNeighborPath(mod(i-2,n)+1) ~= 5
    homePt = path(i,:);
    a = path(i,:); %NEEDS CHECK FOR EDGES
    b = augPath(i+2,:); %check around corner
    c= min(abs(b-a));
    if c == 1 %ideal case
        for conPt = -1:2:1
            % look forward
            candInd = i+conPt;
            dir = path(candInd,:) - path(i,:);
            checkPt(1,:) = homePt + 2*dir;
            checkPt(2,:) = homePt + dir*R;
            checkPt(3,:) = homePt + dir*R3;
    
            for j=1:3
                try
                    check(j) = gridMap(checkPt(j,1), checkPt(j,2));
                catch
                    check(j) = 0;
                end
            end
            if check(1) && (check(2) || check(3))
                if (conPt == 1 && numNeighborPath(mod(i,n)+1) ~= 5) || (conPt == -1 && numNeighborPath(mod(i-2,n)+1) ~= 5)
                straightSegs = [straightSegs; i, i+conPt];
                end
            end
        end
    elseif c == 2 %can do something
        %To Design Later
        % diagSegs = [diagSegs; i, candInd];
    end
    % end
end
eatSegs = [straightSegs; diagSegs];
end


function [path, gridMap, activeMask] = eater(path, gridMap, activeMask, eatSegs) %SEG CHOSER INCOMPLETE
%path = current path
%gridMap = map of useable nodes
%activeMask = mask of path denoting what can be used
%eatSegs = indicies for potential addition points

%Better eater follows 4-connectivity, looks at connected perps, and reverses chirality.
    % Maybe calculates all separately and culls overlapping potential additions to maximize nodes added?
    %Eat if entry points are 1-connected in 4con (check candidates, not whole graph)
    % maybe better to prioritize minimizing captive singles (culls of 1 from cutter) (maybe problematic but worth a try)
        % nah, minimize left over 1-connected entry points (ex: 3 options: 1 big overlaps, 1 small, 1 medium. Select medium)

numSegs = size(eatSegs,1);
%generate segs for all eatSegs
for i= 1:numSegs
    breakInd = min(eatSegs(i,:));
    % returnInd = max(eatSegs(i,:));
    breakPhase = [path(breakInd-1:breakInd+2,:)]; %MISSING WRAP PROTECTION

    [seg{i}, addedMap{i}] = touchTips(gridMap, breakPhase, 4, 0, 1);
end
emptySegs=find(cellfun(@isempty,seg))';
seg(emptySegs) = [];
addedMap(emptySegs) = [];
eatSegs(emptySegs,:) = [];


% choose segs THIS IS GOING TO BE THE SLOWEST PART OF THE FUNCTION FOR NOW, ADDED MAPS WILL HELP
keepMask = segCuller(seg, addedMap, gridMap); 
valSeg = seg(keepMask);
eatSegs(~keepMask,:) = [];

%splice in segs
breakIDs = [0,0];
numPtsAdded=0;
for i=1:size(valSeg,2)
    breakIDs(1,1) = min(eatSegs(i,:));
    breakIDs(1,2) = breakIDs(1,1)+1;
    [path, activeMask, gridMap] = pathAdder(path,valSeg{i}, activeMask, breakIDs+numPtsAdded, gridMap);
    numPtsAdded = numPtsAdded + size(valSeg{i},1);
    % plot(path(:,1),path(:,2),'r');
end
end


function keepMask = segCuller(seg, addedMap, gridMap)
numSegs = numel(seg);
% Build overlap lookup
cellToSegs = containers.Map('KeyType','uint64','ValueType','any');

for i = 1:numSegs
    inds = uint64(find(addedMap{i}));
    for k = 1:numel(inds)
        idx = inds(k);
        if isKey(cellToSegs, idx)
            cellToSegs(idx) = [cellToSegs(idx), i];
        else
            cellToSegs(idx) = i;
        end
    end
end
% Build neighbor/conflict lists
neighbors = cell(numSegs,1);
allKeys = keys(cellToSegs);
for k = 1:numel(allKeys)
    touchingSegs = cellToSegs(allKeys{k});
    if numel(touchingSegs) > 1
        for a = 1:numel(touchingSegs)
            s = touchingSegs(a);
            neighbors{s} = [neighbors{s}, touchingSegs];
        end
    end
end

% Remove duplicates/self
for i = 1:numSegs
    neighbors{i} = unique(neighbors{i});
    neighbors{i}(neighbors{i} == i) = [];
end

% Lazy goodness evaluation
scoresKnown = false(numSegs,1);
scores      = zeros(numSegs,1);
alive    = true(numSegs,1);
keepMask = false(numSegs,1);

% ==================================
% Main loop
% ==================================
for i = 1:numSegs
    if ~alive(i)
        continue;
    end
    nbrs = neighbors{i};
    % No conflicts -> automatically keep
    activeNbrs = nbrs(alive(nbrs));
    if isempty(activeNbrs)
        keepMask(i) = true;
        alive(i) = false;
        continue;
    end

    % Conflict exists -> compute scores lazily
    candidates = [i activeNbrs];
    for c = candidates
        if ~scoresKnown(c)
            scores(c) = sum(countNeighbors_fast(seg{c},gridMap,4) == 1);
            scoresKnown(c) = true;
        end
    end

    % Keep best candidate
    [~, bestIdx] = max(scores(candidates));
    bestSeg = candidates(bestIdx);
    if bestSeg == i
        keepMask(i) = true;
        alive(activeNbrs) = false;
    end
    alive(i) = false;
end
% segCulled = seg(keepMask);
end



function [path, activeMask, gridMap] = pathAdder(path,newSeg, activeMask, breakIDs, gridMap)
newSegLeng = size(newSeg,1);
if breakIDs(2) == 1
    path(end+1:end+newSegLeng,:) = newSeg;
    activeMask(end+1:end+newSegLeng,1) = ones(newSegLeng,1);
else
    path = [path(1:breakIDs(1),:); newSeg; path(breakIDs(2):end,:)];
    activeMask = [activeMask(1:breakIDs(1),1); ones(newSegLeng,1); activeMask(breakIDs(2):end,1)];
end
% gridMap(newSeg(:,1),newSeg(:,2)) = false;
idx = sub2ind(size(gridMap), newSeg(:,1), newSeg(:,2)); %CHECK LATER TO SEE IF THESE INDICES ARE RETREIVABLE WITHOUT SUB2IND
gridMap(idx) = false;
end

function [cand4con, cand8con] = breachLister(path, activeMask, numNeighborPath, gridMap) %INCOMPLETE
%path = full path
%activeMask = list of possible path points
%numNeighborPath = number of continuous neighbors in 8-con
%gridMap = available nodes
%Prioritize corners (2-2+ in 8con) (1-1+ in 4con, less telling), 
    %challenge with double clusters, runLength<numNeigh
%flag loners? (1-1 in 8con) (0-1 in 4con), may be easier to look at size 1 connectivity groups
%less than 2 can be ignored for 4add, but important for 8add
pathLeng = size(path,1);
cand4con = [];
cand8con = [];
for i = find(activeMask)'
    nextInd = mod(i,pathLeng)+1;
    if activeMask(nextInd) %if next neigh is also valid
        candNeigh = numNeighborPath(i);
        nextNeigh = numNeighborPath(nextInd);
        if min(candNeigh,nextNeigh) == 2 %&& (candNeigh == 2 || nextNeigh == 2) %corner
            cand4con = [cand4con;i, nextInd];
        elseif candNeigh == 1 || nextNeigh == 1
            cand8con = [cand8con;i, nextInd];
        end
    elseif ~activeMask(mod(i-2,pathLeng)+1) % previous invalid (1 pt entry)
        cand8con = [cand8con;i, i];
    end
end
% breachList = [cand4con; cand8con];
end





function [pathCut, cutNodes, cutNodesTrue] = cutter(path, includePt)

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







