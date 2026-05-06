function tour = concordeWrapper(points)
% D = nxn dist mat
% tour = concorde result

%For windows users who have no clue how to gunfigure ====================
% First, download the 2003 version of concorde from https://math.uwaterloo.ca/tsp/concorde/downloads/downloads.htm
% In cmd, run the following line:
% wsl --install
% Then reboot the computer.
% When rebooted, press the windows key and open up Ubuntu. This will open a
% terminal. Set a username and password I guess.
% In Ubuntu's terminal, run the following one line at a time:
% sudo apt update
% sudo apt install build-essential
% cd /mnt/c/Users/(YOUR USERNAME HERE)/Downloads (THIS LINE COULD POINT TO ANOTHER FOLDER WHERE YOU PUT THE FILE)
% gunzip co031219.tgz
% tar xvf co031219.tar
% cd concorde
% ./configure
% make
% You may also need to run:
% cd /mnt/c/Users/(YOUR USERNAME HERE)/Downloads/concorde
% ./configure
% make
% ======================================================================
% D = squareform(pdist(points));
% D = gridDistanceMatrix8(points); D=full(D);
D = BFD(points);

% Integer input check
if ~all(D(:) == round(D(:)))
    disp("Non-integer inputs. Rounding to the nearest 1000th")
    D = round(1000*D); %convert to rounded integers
end



n=size(D,1);

%prep file
fname = 'problem.tsp';
fid = fopen(fname,'w');

%Magic incantation
fprintf(fid,'NAME: matlab_tsp\n');
fprintf(fid,'TYPE: TSP\n');
fprintf(fid,'DIMENSION: %d\n',n);
fprintf(fid,'EDGE_WEIGHT_TYPE: EXPLICIT\n');
fprintf(fid,'EDGE_WEIGHT_FORMAT: FULL_MATRIX\n');
fprintf(fid,'EDGE_WEIGHT_SECTION\n');

%divination circle
for i=1:n
    fprintf(fid,'%d ',D(i,:));
    fprintf(fid,'\n');
end

%cast incantation
fprintf(fid,'EOF\n');
fclose(fid);

%call the console command
% system('wsl concorde problem.tsp');
% If the above line doesn't work, use the full paths as such: ('wsl concordeDirectory .tspFile'sDirectory')
%EX: system('wsl
%/mnt/c/Users/YOUR_USERNAME_HERE/Downloads/concorde/TSP/concorde /mnt/c/Users/YOUR_USERNAME_HERE/Documents/VARIOUS_FOLDER_NAMES/problem.tsp');
system('/home/user/Documents/MATLAB/concorde/TSP/concorde /home/user/Documents/MATLAB/MinLatency/problem.tsp');

%read solution file
solfile = 'problem.sol';
fid = fopen(solfile,'r');

%counterspell
m=fscanf(fid,'%d',1);
tour = fscanf(fid,'%d');
fclose(fid);
tour = tour+1;
end
