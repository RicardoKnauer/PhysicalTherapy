% ACUTE EFFECT OF STATIC STRETCHING ON SQUAT JUMP HEIGHT

% SETUP: 1 subject with 4 active markers (lateral acromion, superior aspect
% of greater trochanter, lateral knee joint line, lateral malleolus) per-
% formed squat jumps from a standardized starting position; the markers'
% paths in the sagittal plane were measured with the Optotrak Certus®
% system


clear
close all

% CONDITION 1: best of 3 squat jumps for height

% readndf() by Welter, 1998 & Zaal, 1997
[x1,y1,z1,fs] = readndf('jumpingWithoutStretching.ndf');

shoulder1 = [x1(:,1) y1(:,1)];
hip1 = [x1(:,2) y1(:,2)];
knee1 = [x1(:,3) y1(:,3)];
ankle1 = [x1(:,4) y1(:,4)];

shoulder1 = -shoulder1/1000;
hip1 = -hip1/1000;
knee1 = -knee1/1000;
ankle1 = -ankle1/1000;

% t = [0:length(x1)-1]/fs;

% plot(t,shoulder1(:,1),t,hip1(:,1),t,knee1(:,1),t,ankle1(:,1))
% title('control plot: x-direction')
% xlabel('time [s]')
% ylabel('displacement in the x-direction [m]')
% legend('shoulder','hip','knee','ankle')
%
% pause
%
% plot(t,shoulder1(:,2),t,hip1(:,2),t,knee1(:,2),t,ankle1(:,2))
% title('control plot: y-direction')
% xlabel('time [s]')
% ylabel('displacement in the y-direction [m]')
% legend('shoulder','hip','knee','ankle')
%
% pause

% % check if the amount of error, especially due to soft tissue artifacts
% % at the lateral knee joint line (Sati, de Guise, Larouche & Drouin,
% % 1996), is approximately within expected limits
%
% thighLength = sqrt(sum((hip1-knee1).^2,2));
% shankLength = sqrt(sum((knee1-ankle1).^2,2));
%
% figure
% subplot(2,1,1)
% plot(t,thighLength)
% title('control plot: thigh length')
% xlabel('time [s]')
% ylabel('thigh length [m]')
%
% subplot(2,1,2)
% plot(t,shankLength)
% title('control plot: shank length')
% xlabel('time [s]')
% ylabel('shank length [m]')
%
% pause

% constants based on anthropometric approximations
r_c_trunk1 = shoulder1+(hip1-shoulder1)*0.5;
r_c_thigh1 = hip1+(knee1-hip1)*0.428;
r_c_shank1 = knee1+(ankle1-knee1)*0.5;

% figure
% plot(t,shoulder1(:,1),t,hip1(:,1),t,knee1(:,1),t,ankle1(:,1),t,...
%     r_c_trunk1(:,1),t,r_c_thigh1(:,1),t,r_c_shank1(:,1))
% title('control plot: x-direction')
% xlabel('time [s]')
% ylabel('displacement in the x-direction [m]')
% legend('shoulder','hip','knee','ankle','center of mass: trunk',...
%     'center of mass: thigh','center of mass: shank')
%
% pause
%
% plot(t,shoulder1(:,2),t,hip1(:,2),t,knee1(:,2),t,ankle1(:,2),t,...
%     r_c_trunk1(:,2),t,r_c_thigh1(:,2),t,r_c_shank1(:,2))
% title('control plot: y-direction')
% xlabel('time [s]')
% ylabel('displacement in the y-direction [m]')
% legend('shoulder','hip','knee','ankle','center of mass: trunk',...
%     'center of mass: thigh','center of mass: shank')
%
% pause

m_subject = 60;
% constants based on anthropometric approximations
r_c1 = (0.6314*m_subject*r_c_trunk1+0.2350*m_subject*r_c_thigh1+...
    0.1336*m_subject*r_c_shank1)/m_subject;

% figure
% plot(t,shoulder1(:,1),t,hip1(:,1),t,knee1(:,1),t,ankle1(:,1),t,...
%     r_c_trunk1(:,1),t,r_c_thigh1(:,1),t,r_c_shank1(:,1),t,r_c1(:,1))
% title('control plot: x-direction')
% xlabel('time [s]')
% ylabel('displacement in the x-direction [m]')
% legend('shoulder','hip','knee','ankle','center of mass: trunk',...
%     'center of mass: thigh','center of mass: shank','center of mass')
%
% pause
%
% plot(t,shoulder1(:,2),t,hip1(:,2),t,knee1(:,2),t,ankle1(:,2),t,...
%     r_c_trunk1(:,2),t,r_c_thigh1(:,2),t,r_c_shank1(:,2),t,r_c1(:,2))
% title('control plot: y-direction')
% xlabel('time [s]')
% ylabel('displacement in the y-direction [m]')
% legend('shoulder','hip','knee','ankle','center of mass: trunk',...
%     'center of mass: thigh','center of mass: shank','center of mass')
%
% pause

[maximum1,imax1] = max(r_c1(:,2));


% CONDITION 2: best of 3 squat jumps for height after 2 static stretching
% exercises for the posterior and 1 for the anterior chain, 30s each on
% both sides

% readndf() by Welter, 1998 & Zaal, 1997
[x2,y2] = readndf('jumpingWithStretching.ndf');

shoulder2 = [x2(:,1) y2(:,1)];
hip2 = [x2(:,2) y2(:,2)];
knee2 = [x2(:,3) y2(:,3)];
ankle2 = [x2(:,4) y2(:,4)];

shoulder2 = -shoulder2/1000;
hip2 = -hip2/1000;
knee2 = -knee2/1000;
ankle2 = -ankle2/1000;

r_c_trunk2 = shoulder2+(hip2-shoulder2)*0.5;
r_c_thigh2 = hip2+(knee2-hip2)*0.428;
r_c_shank2 = knee2+(ankle2-knee2)*0.5;

r_c2 = (0.6314*m_subject*r_c_trunk2+0.2350*m_subject*r_c_thigh2+...
    0.1336*m_subject*r_c_shank2)/m_subject;

[maximum2,imax2] = max(r_c2(:,2));


figure
plot(r_c1(imax1-50:imax1+50,1),r_c1(imax1-50:imax1+50,2),...
    r_c2(imax2-50:imax2+50,1),r_c2(imax2-50:imax2+50,2))
axis equal
xlabel('displacement in the x-direction [m]')
ylabel('displacement in the y-direction [m]')
legend('center of mass: without stretching',...
    'center of mass: with stretching')

% the maximal squat jump height is operationalized as the maximal vertical
% displacement of the center of mass in relation to upright standing
squatJumpHeight_withoutStretching = maximum1-r_c1(end-200,2)
squatJumpHeight_withStretching = maximum2-r_c2(end-200,2)
withoutStretching_minus_withStretching = ...
    squatJumpHeight_withoutStretching-squatJumpHeight_withStretching


% LIMITATIONS: experiment with only squat jumps and 1 specific stretching
% protocol, without variation in time between stretching and the squat jump
% trial, although the negative acute effects of pre-exercise static stret-
% ching are generally consistent with the literature (Simic, Sarabon &
% Markovic, 2013)