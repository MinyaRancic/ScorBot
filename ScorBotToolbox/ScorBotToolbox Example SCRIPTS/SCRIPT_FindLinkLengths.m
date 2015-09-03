%Find last link length
ScorSetBSEPR([0,pi/2,-pi/2,-5*pi/9,0]);
ScorWaitForMove;
pause(2);
ScorSetBSEPR([0,pi/2,-pi/2, 5*pi/9,0]);
[~,~,cData] = ScorWaitForMove('CollectData','On');

%% Plot results
fig = figure;
axs = axes('Parent',fig);
xlabel('x (mm)');
ylabel('y (mm)');
zlabel('z (mm)');
hold on
view(3)
daspect([1 1 1]);

tXYZPR = cData.tXYZPR;
XYZ = tXYZPR(:,2:4);
plt(1) = plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.r');

x=XYZ(:,1);
z=XYZ(:,3);
[xc,zc,r] = circfit(x,z);

% Plot center
plt(2) = plot3(xc,mean(XYZ(:,2)),zc,'*r');
% Plot radius
ang = 2*pi*rand(1,1);
plt(3) = plot3([0,r]*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,2),[0,r]*cos(ang)+zc,':k');
txt(1) = text(r/2*sin(ang)+xc,mean(XYZ(:,2)),r/2*cos(ang)+zc,sprintf('r = %.3f',r));
% Plot circle
ang = linspace(0,2*pi,100);
plt(4) = plot3(r*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,numel(ang)),r*cos(ang)+zc,':k');

link4 = r;
fprintf('Link 4 = %f mm\n',link4);

%% Find Second to last link
ScorSetBSEPR([0,pi/2,-5*pi/6,0,0]);
ScorWaitForMove;
pause(2);
ScorSetBSEPR([0,pi/2,-0.1,0,0]);
[~,~,cData] = ScorWaitForMove('CollectData','On');

%% Plot results
tXYZPR = cData.tXYZPR;
XYZ = tXYZPR(:,2:4);
plt(1) = plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.g');

x=XYZ(:,1);
z=XYZ(:,3);
[xc,zc,r] = circfit(x,z);

% Plot center
plt(2) = plot3(xc,mean(XYZ(:,2)),zc,'*g');
% Plot radius
ang = 2*pi*rand(1,1);
plt(3) = plot3([0,r]*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,2),[0,r]*cos(ang)+zc,':k');
txt(1) = text(r/2*sin(ang)+xc,mean(XYZ(:,2)),r/2*cos(ang)+zc,sprintf('r = %.3f',r));
% Plot circle
ang = linspace(0,2*pi,100);
plt(4) = plot3(r*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,numel(ang)),r*cos(ang)+zc,':k');

link3 = r-link4;
fprintf('Link 3 = %f mm\n',link3);

%% Find third to last link and last link
ScorSetBSEPR([0,2*pi/3,-pi/2,0,0]);
ScorWaitForMove;
pause(2);
ScorSetBSEPR([0,pi/6,-pi/2,0,0]);
[~,~,cData] = ScorWaitForMove('CollectData','On');

%% Plot results
tXYZPR = cData.tXYZPR;
XYZ = tXYZPR(:,2:4);
plt(1) = plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.b');

x=XYZ(:,1);
z=XYZ(:,3);
[xc,zc,r] = circfit(x,z);

% Plot center
plt(2) = plot3(xc,mean(XYZ(:,2)),zc,'*b');
% Plot radius
ang = 2*pi*rand(1,1);
plt(3) = plot3([0,r]*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,2),[0,r]*cos(ang)+zc,':k');
txt(1) = text(r/2*sin(ang)+xc,mean(XYZ(:,2)),r/2*cos(ang)+zc,sprintf('r = %.3f',r));
% Plot circle
ang = linspace(0,2*pi,100);
plt(4) = plot3(r*sin(ang)+xc,repmat(mean(XYZ(:,2)),1,numel(ang)),r*cos(ang)+zc,':k');

% r^2 = link2^2 + (link3 + link4)^2
link2 = sqrt(r^2-(link3 + link4)^2);
fprintf('Link 2 = %f mm\n',link2);

link0 = zc;
fprintf('Link 0 = %f mm\n',link0);

%% Find second to last link
ScorSetBSEPR([2*pi/3,pi/2,-pi/2,0,0]);
ScorWaitForMove;
pause(2);
ScorSetBSEPR([-2*pi/3,pi/2,-pi/2,0,0]);
[~,~,cData] = ScorWaitForMove('CollectData','On');

%% Plot results
tXYZPR = cData.tXYZPR;
XYZ = tXYZPR(:,2:4);
plt(1) = plot3(XYZ(:,1),XYZ(:,2),XYZ(:,3),'.m');

x=XYZ(:,1);
y=XYZ(:,2);
[xc,yc,r] = circfit(x,y);

% Plot center
plt(2) = plot3(xc,yc,mean(XYZ(:,3)),'*m');
% Plot radius
ang = 2*pi*rand(1,1);
plt(3) = plot3([0,r]*sin(ang)+xc,[0,r]*cos(ang)+yc,repmat(mean(XYZ(:,3)),1,2),':k');
txt(1) = text(r/2*sin(ang)+xc,r/2*cos(ang)+yc,mean(XYZ(:,3)),sprintf('r = %.3f',r));
% Plot circle
ang = linspace(0,2*pi,100);
plt(4) = plot3(r*sin(ang)+xc,r*cos(ang)+yc,repmat(mean(XYZ(:,3)),1,numel(ang)),':k');

link1 = r - (link3 + link4);
fprintf('Link 1 = %f mm\n',link1);

%% Home ScorBot
ScorGoHome;