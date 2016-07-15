function confirm = Scor6AxisReadSerial(ser)
%% ScorSim6axisReadSerial reads information from designated COM port and
% uses ScorBot6AxisCallback to return information to command window
%
%
%
%
% D. Saiontz, 12July2016, SEAP

%% Declare global variables for most recent data point
global recentT;
global recentP;
global recentV;
global recentS;

%% Read serial object
flushinput(ser);
confirm = true;
% Runs callback

% splitStr = zeros(20);
% out = zeros(2);
% A = zeros(20);
% B = zeros(20);
% fclose(s);
% for i = 1:20
%     fopen(s);
%     out = (fscanf(s));
%     splitStr = regexp(out,',','split');
%     while size(splitStr) ~= 19
%         out = fscanf(s);
%         splitStr = regexp(out, ',', 'split');
%     end
%     A = cell2table(splitStr);
%     B = table2array(A);
%     for j = 1:19
%         data(i,j) = str2double(B(1,j));
%     end
%     T = data(1); % Time stamp
%     P = data(2:7); % Axis positions
%     V = data(8:13); % Axis velocities
%     S = data(14:19); % Axis states
%     fclose(s);
% end
end