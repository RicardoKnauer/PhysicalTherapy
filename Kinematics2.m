% ACUTE EFFECT OF A MOTOR-COGNITIVE DUAL-TASK ON THE ABILITY TO MAINTAIN
% CYCLING CADENCE

% SETUP: 1 subject cycled on stationary bike with 1 active marker (pedal);
% the marker's path in the sagittal plane was measured with the Optotrak
% Certus® system


clear
close all

% CONDITION 1: maintaining 60 revolutions per minute (metronome-paced)

% readndf() by Welter, 1998 & Zaal, 1997
[x1,y1,z1,fs] = readndf('cyclingWithoutDistraction.ndf');

x1 = x1/1000;
y1 = y1/1000;

t = [0:length(x1)-1]'/fs;

plot(t,x1)
xlabel('time [s]')
ylabel('displacement in the x-direction [m]')

pause

figure
plot(t,y1)
xlabel('time [s]')
ylabel('displacement in the y-direction [m]')

pause

centerOfRotation1 = [ones(6000,1)*(min(x1)+(max(x1)-min(x1))/2) ...
    ones(6000,1)*(min(y1)+(max(y1)-min(y1))/2)];
crankShaft1 = [centerOfRotation1(:,1) x1 centerOfRotation1(:,2) y1];

% figure
% for i=1:length(x1)
%     plot3([t(i) t(i)],[crankShaft1(i,1) crankShaft1(i,2)],...
%         [crankShaft1(i,3) crankShaft1(i,4)])
%     hold on
% end
% title('control plot: crankshaft')
% xlabel('time [s]')
% ylabel('displacement in the x-direction [m]')
% zlabel('displacement in the y-direction [m]')
% hold off
% 
% pause

crankAngle1 = unwrap(atan2((crankShaft1(:,4)-crankShaft1(:,3)),...
    (crankShaft1(:,2)-crankShaft1(:,1))));
crankAngularVelocity1 = gradient(crankAngle1,1/fs);
RPM1 = abs((crankAngularVelocity1/(2*pi))*60);


% CONDITION 2: maintaining 60 revolutions per minute (metronome-paced) with
% a motor-cognitive dual-task, namely counting backwards by 7s from 200

% readndf() by Welter, 1998 & Zaal, 1997
[x2,y2] = readndf('cyclingWithDistraction.ndf');

x2 = x2/1000;
y2 = y2/1000;

centerOfRotation2 = [ones(6000,1)*(min(x2)+(max(x2)-min(x2))/2) ...
    ones(6000,1)*(min(y2)+(max(y2)-min(y2))/2)];
crankShaft2 = [centerOfRotation2(:,1) x2 centerOfRotation2(:,2) y2];

crankAngle2 = unwrap(atan2((crankShaft2(:,4)-crankShaft2(:,3)),...
    (crankShaft2(:,2)-crankShaft2(:,1))));
crankAngularVelocity2 = gradient(crankAngle2,1/fs);
RPM2 = abs((crankAngularVelocity2/(2*pi))*60);


figure
h = plot(t,RPM1,t,RPM2,[0 60],[60 60]);
set(h(3),'Color','k','linewidth',2)
xlabel('time [s]')
ylabel('revolutions [min]')
legend('without distraction','with distraction')

RPM_withoutDistraction = -(crankAngle1(end)-crankAngle1(1))/(2*pi)
difference_withoutDistraction = 60-RPM_withoutDistraction
RPM_withDistraction = -(crankAngle2(end)-crankAngle2(1))/(2*pi)
difference_withDistraction = 60-RPM_withDistraction


% LIMITATIONS: possible environmental distractions during both conditions,
% e.g. due to background noise by other experiments in the measurement
% area, although the effect was tried to be minimized by using headphones