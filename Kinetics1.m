% ACUTE EFFECT OF DYNAMIC STRETCHING ON COUNTER-MOVEMENT JUMP HEIGHT

% SETUP: 1 subject performed counter-movement jumps; the normal force was
% measured with a Kistler force plate


clear
close all

% CALIBRATION OF THE FORCE PLATE

load('calibration.afp')

U_z_raw = (sum(calibration(:,5:8),2))';

% plot(U_z_raw)

iStart = 1:800;
iM1 = 1000:1600;
iM2 = 1800:2400;
iM3 = 2600:3100;
iM4 = 3300:3700;
iEnd = 4100:4690;

coefDrift = polyfit([iStart iEnd],[U_z_raw(iStart) U_z_raw(iEnd)],1);
U_z_corrected = U_z_raw-(coefDrift(1)*[0:length(U_z_raw)-1]+...
    coefDrift(2));

% plot(U_z_corrected)

U_z_averages = [mean(U_z_corrected(iStart)) mean(U_z_corrected(iM1)) ...
    mean(U_z_corrected(iM2)) mean(U_z_corrected(iM3)) ...
    mean(U_z_corrected(iM4))];

F_N = [0 4.853*9.81 9.178*9.81 14.041*9.81 19.028*9.81];

coefFitted = polyfit(F_N,U_z_averages,1);
U_z_fitted = coefFitted(1)*F_N+coefFitted(2);

figure
plot(F_N,U_z_fitted)
hold on
scatter(F_N,U_z_averages)
title('calibration curve')
xlabel('F_N [N]')
ylabel('U_z [V]')
legend('U_{z,fitted}','U_{z,averages}')
hold off

pause


% CONDITION 1: best of 3 counter-movement jumps for height

for i=1:3
    load(['jumpingWithoutStretching' num2str(i) '.afp']);
end

s1 = sum(jumpingWithoutStretching1(:,5:8),2)';
s2 = sum(jumpingWithoutStretching2(:,5:8),2)';
s3 = sum(jumpingWithoutStretching3(:,5:8),2)';

% % A) CORRECTION FOR DRIFT (PIEZOELECTRIC FORCE TRANSDUCERS)

% figure
% plot(s1)
% hold on
% plot(s2)
% plot(s3)
% legend('U_{z,raw} first jump','U_{z,raw} second jump',...
%     'U_{z,raw} third jump')
% hold off

iStartWithoutS = 1:400;
iEndWithoutS = 2700:2846;

coefDrift1 = polyfit([iStartWithoutS iEndWithoutS],...
    [s1(iStartWithoutS) s1(iEndWithoutS)],1);
s1Corrected = s1-(coefDrift1(1)*[0:length(s1)-1]+coefDrift1(2));
coefDrift2 = polyfit([iStartWithoutS iEndWithoutS],...
    [s2(iStartWithoutS) s2(iEndWithoutS)],1);
s2Corrected = s2-(coefDrift2(1)*[0:length(s2)-1]+coefDrift2(2));
coefDrift3 = polyfit([iStartWithoutS iEndWithoutS],...
    [s3(iStartWithoutS) s3(iEndWithoutS)],1);
s3Corrected = s3-(coefDrift3(1)*[0:length(s3)-1]+coefDrift3(2));

% figure
% plot(s1Corrected)
% hold on
% plot(s2Corrected)
% plot(s3Corrected)
% legend('U_{z,corrected} first jump','U_{z,corrected} second jump',...
%     'U_{z,corrected} third jump')
% hold off

% % B) MAXIMAL VERTICAL JUMP HEIGHT

F_N_s1 = s1Corrected/coefFitted(1);
F_N_s2 = s2Corrected/coefFitted(1);
F_N_s3 = s3Corrected/coefFitted(1);

m = 60;
a_c_s1 = (-9.81)+F_N_s1/m;
a_c_s2 = (-9.81)+F_N_s2/m;
a_c_s3 = (-9.81)+F_N_s3/m;

% figure
% plot(a_c_s1)
% hold on
% plot(a_c_s2)
% plot(a_c_s3)
% legend('a_c first jump','a_c second jump','a_c third jump')
% hold off

iStart1 = 1400;
iStart2 = 1400;
iStart3 = 1000;

% correction for offset
a_c_s1_corrected = a_c_s1-a_c_s1(iStart1);
a_c_s2_corrected = a_c_s2-a_c_s2(iStart2);
a_c_s3_corrected = a_c_s3-a_c_s3(iStart3);

% figure
% plot(a_c_s1_corrected)
% hold on
% plot(a_c_s2_corrected)
% plot(a_c_s3_corrected)
% legend('a_{c,corrected} first jump','a_{c,corrected} second jump',...
%     'a_{c,corrected} third jump')
% hold off

% find where the vertical acceleration is close to 0 in the end
[~, iEndMin1] = min(abs(a_c_s1_corrected(2124:2576)));
[~, iEndMin2] = min(abs(a_c_s2_corrected(2100:2557)));
[~, iEndMin3] = min(abs(a_c_s3_corrected(1703:2219)));

a_c_s1_cut = a_c_s1_corrected(iStart1:2123+iEndMin1);
a_c_s2_cut = a_c_s2_corrected(iStart2:2099+iEndMin2);
a_c_s3_cut = a_c_s3_corrected(iStart3:1702+iEndMin3);

% correction for integration drift
a_c_s1_final = a_c_s1_cut-mean(a_c_s1_cut);
a_c_s2_final = a_c_s2_cut-mean(a_c_s2_cut);
a_c_s3_final = a_c_s3_cut-mean(a_c_s3_cut);

fs = 200;
t1 = [0:length(a_c_s1_final)-1]/fs;
t2 = [0:length(a_c_s2_final)-1]/fs;
t3 = [0:length(a_c_s3_final)-1]/fs;

v_c_s1 = cumtrapz(t1,a_c_s1_final);
v_c_s2 = cumtrapz(t2,a_c_s2_final);
v_c_s3 = cumtrapz(t3,a_c_s3_final);

% correction for integration drift
v_c_s1_final = v_c_s1-mean(v_c_s1);
v_c_s2_final = v_c_s2-mean(v_c_s2);
v_c_s3_final = v_c_s3-mean(v_c_s3);

r_c_s1 = cumtrapz(t1,v_c_s1_final);
r_c_s2 = cumtrapz(t2,v_c_s2_final);
r_c_s3 = cumtrapz(t3,v_c_s3_final);

figure
plot(t1,r_c_s1)
hold on
plot(t2,r_c_s2)
plot(t3,r_c_s3)
title('counter-movement jumps without stretching')
xlabel('time [s]')
ylabel('vertical displacement [m]')
legend('first jump','second jump','third jump')
hold off


% the maximal counter-movement jump height is operationalized as the maxi-
% mal vertical displacement of the center of mass in relation to upright
% standing

jumpHeight_withoutStretching = max([max(r_c_s1) max(r_c_s2) max(r_c_s3)])

pause


% CONDITION 2: best of 3 counter-movement jumps for height after 2 dynamic
% stretching exercises for the posterior and 1 for the anterior chain as
% well as 1 for both, 15-20 repetitions each on both sides

for i=1:3
    load(['jumpingWithStretching' num2str(i) '.afp']);
end

s4 = sum(jumpingWithStretching1(:,5:8),2)';
s5 = sum(jumpingWithStretching2(:,5:8),2)';
s6 = sum(jumpingWithStretching3(:,5:8),2)';

% % A) CORRECTION FOR DRIFT (PIEZOELECTRIC FORCE TRANSDUCERS)

% figure
% plot(s4)
% hold on
% plot(s5)
% plot(s6)
% legend('U_{z,raw} fourth jump','U_{z,raw} fifth jump',...
%     'U_{z,raw} sixth jump')
% hold off

iStartWithS = 1:400;
iEndWithS = 2200:2299;

coefDrift4 = polyfit([iStartWithS iEndWithS],...
    [s4(iStartWithS) s4(iEndWithS)],1);
s4Corrected = s4-(coefDrift4(1)*[0:length(s4)-1]+coefDrift4(2));
coefDrift5 = polyfit([iStartWithS iEndWithS],...
    [s5(iStartWithS) s5(iEndWithS)],1);
s5Corrected = s5-(coefDrift5(1)*[0:length(s5)-1]+coefDrift5(2));
coefDrift6 = polyfit([iStartWithS iEndWithS],...
    [s6(iStartWithS) s6(iEndWithS)],1);
s6Corrected = s6-(coefDrift6(1)*[0:length(s6)-1]+coefDrift6(2));

% figure
% plot(s4Corrected)
% hold on
% plot(s5Corrected)
% plot(s6Corrected)
% legend('U_{z,corrected} fourth jump','U_{z,corrected} fifth jump',...
%     'U_{z,corrected} sixth jump')
% hold off

% % B) MAXIMAL VERTICAL JUMP HEIGHT

F_N_s4 = s4Corrected/coefFitted(1);
F_N_s5 = s5Corrected/coefFitted(1);
F_N_s6 = s6Corrected/coefFitted(1);

m = 60;
a_c_s4 = (-9.81)+F_N_s4/m;
a_c_s5 = (-9.81)+F_N_s5/m;
a_c_s6 = (-9.81)+F_N_s6/m;

% figure
% plot(a_c_s4)
% hold on
% plot(a_c_s5)
% plot(a_c_s6)
% legend('a_c fourth jump','a_c fifth jump','a_c sixth jump')
% hold off

iStart4 = 830;
iStart5 = 830;
iStart6 = 830;

% correction for offset
a_c_s4_corrected = a_c_s4-a_c_s4(iStart4);
a_c_s5_corrected = a_c_s5-a_c_s5(iStart5);
a_c_s6_corrected = a_c_s6-a_c_s6(iStart6);

% figure
% plot(a_c_s4_corrected)
% hold on
% plot(a_c_s5_corrected)
% plot(a_c_s6_corrected)
% legend('a_{c,corrected} fourth jump','a_{c,corrected} fifth jump',...
%     'a_{c,corrected} sixth jump')
% hold off

% find where the vertical acceleration is close to 0 in the end
[~, iEndMin4] = min(abs(a_c_s4_corrected(1671:2065)));
[~, iEndMin5] = min(abs(a_c_s5_corrected(1613:1932)));
[~, iEndMin6] = min(abs(a_c_s6_corrected(1654:1782)));

a_c_s4_cut = a_c_s4_corrected(iStart4:1670+iEndMin4);
a_c_s5_cut = a_c_s5_corrected(iStart5:1612+iEndMin5);
a_c_s6_cut = a_c_s6_corrected(iStart6:1653+iEndMin6);

% correction for integration drift
a_c_s4_final = a_c_s4_cut-mean(a_c_s4_cut);
a_c_s5_final = a_c_s5_cut-mean(a_c_s5_cut);
a_c_s6_final = a_c_s6_cut-mean(a_c_s6_cut);

fs = 200;
t4 = [0:length(a_c_s4_final)-1]/fs;
t5 = [0:length(a_c_s5_final)-1]/fs;
t6 = [0:length(a_c_s6_final)-1]/fs;

v_c_s4 = cumtrapz(t4,a_c_s4_final);
v_c_s5 = cumtrapz(t5,a_c_s5_final);
v_c_s6 = cumtrapz(t6,a_c_s6_final);

% correction for integration drift
v_c_s4_final = v_c_s4-mean(v_c_s4);
v_c_s5_final = v_c_s5-mean(v_c_s5);
v_c_s6_final = v_c_s6-mean(v_c_s6);

r_c_s4 = cumtrapz(t4,v_c_s4_final);
r_c_s5 = cumtrapz(t5,v_c_s5_final);
r_c_s6 = cumtrapz(t6,v_c_s6_final);

figure
plot(t4,r_c_s4)
hold on
plot(t5,r_c_s5)
plot(t6,r_c_s6)
title('counter-movement jumps with stretching')
xlabel('time [s]')
ylabel('vertical displacement [m]')
legend('fourth jump','fifth jump','sixth jump')
hold off


% the maximal counter-movement jump height is operationalized as the maxi-
% mal vertical displacement of the center of mass in relation to upright
% standing

jumpHeight_withStretching = max([max(r_c_s4) max(r_c_s5) max(r_c_s6)])

withStretching_minus_withoutStretching = ...
    jumpHeight_withStretching-jumpHeight_withoutStretching


% LIMITATIONS: experiment with only counter-movement jumps and 1 specific
% stretching protocol, without variation in time between stretching and the
% counter-movement jump trial, although the (very small) positive acute
% effects of pre-exercise dynamic stretching are generally consistent with
% the literature (Behm, Blazevich, Kay & McHugh, 2016)