% ACUTE EFFECT OF A DYNAMIC BALANCE TASK ON SWAY FREQUENCY

% SETUP: 1 subject balanced on her right leg before and after a dynamic
% balance task; the ground reaction force was measured with a Kistler
% force plate


clear
close all

% CONDITION 1: balancing on the right leg for 30s

load('swayFrequencyBefore.afp')

U_x_raw_before = (sum(swayFrequencyBefore1(:,1:2),2))';
U_y_raw_before = (sum(swayFrequencyBefore1(:,3:4),2))';
U_z1_raw_before = (swayFrequencyBefore1(:,5))';
U_z2_raw_before = (swayFrequencyBefore1(:,6))';
U_z3_raw_before = (swayFrequencyBefore1(:,7))';
U_z4_raw_before = (swayFrequencyBefore1(:,8))';

% % A) CORRECTION FOR DRIFT (PIEZOELECTRIC FORCE TRANSDUCERS)

% plot(U_x_raw_before)
% hold on
% plot(U_y_raw_before)
% legend('U_{x,raw} before','U_{y,raw} before')
% hold off
% figure
% plot(U_z1_raw_before)
% hold on
% plot(U_z2_raw_before)
% plot(U_z3_raw_before)
% plot(U_z4_raw_before)
% legend('U_{z1,raw} before','U_{z2,raw} before','U_{z3,raw} before',...
%     'U_{z4,raw} before')
% hold off

iStart = 500:700;
iEnd = 7500:7700;

coefDriftX_before = polyfit([iStart iEnd],...
    [U_x_raw_before(iStart) U_x_raw_before(iEnd)],1);
U_x_corrected_before = U_x_raw_before-(coefDriftX_before(1)*...
    [0:length(U_x_raw_before)-1]+coefDriftX_before(2));
coefDriftY_before = polyfit([iStart iEnd],...
    [U_y_raw_before(iStart) U_y_raw_before(iEnd)],1);
U_y_corrected_before = U_y_raw_before-(coefDriftY_before(1)*...
    [0:length(U_y_raw_before)-1]+coefDriftY_before(2));
coefDriftZ1_before = polyfit([iStart iEnd],...
    [U_z1_raw_before(iStart) U_z1_raw_before(iEnd)],1);
U_z1_corrected_before = U_z1_raw_before-(coefDriftZ1_before(1)*...
    [0:length(U_z1_raw_before)-1]+coefDriftZ1_before(2));
coefDriftZ2_before = polyfit([iStart iEnd],...
    [U_z2_raw_before(iStart) U_z2_raw_before(iEnd)],1);
U_z2_corrected_before = U_z2_raw_before-(coefDriftZ2_before(1)*...
    [0:length(U_z2_raw_before)-1]+coefDriftZ2_before(2));
coefDriftZ3_before = polyfit([iStart iEnd],...
    [U_z3_raw_before(iStart) U_z3_raw_before(iEnd)],1);
U_z3_corrected_before = U_z3_raw_before-(coefDriftZ3_before(1)*...
    [0:length(U_z3_raw_before)-1]+coefDriftZ3_before(2));
coefDriftZ4_before = polyfit([iStart iEnd],...
    [U_z4_raw_before(iStart) U_z4_raw_before(iEnd)],1);
U_z4_corrected_before = U_z4_raw_before-(coefDriftZ4_before(1)*...
    [0:length(U_z4_raw_before)-1]+coefDriftZ4_before(2));

% figure
% plot(U_x_corrected_before)
% hold on
% plot(U_y_corrected_before)
% legend('U_{x,corrected} before','U_{y,corrected} before')
% hold off
% figure
% plot(U_z1_corrected_before)
% hold on
% plot(U_z2_corrected_before)
% plot(U_z3_corrected_before)
% plot(U_z4_corrected_before)
% legend('U_{z1,corrected} before','U_{z2,corrected} before',...
%     'U_{z3,corrected} before','U_{z4,corrected} before')
% hold off

% % B) CENTER OF PRESSURE

% sensitivities of the system force transducer and charge amplifier
% according to specifications for range 1
F_x_before = U_x_corrected_before/0.08;
F_y_before = U_y_corrected_before/0.08;
F_z1_before = U_z1_corrected_before/0.038;
F_z2_before = U_z2_corrected_before/0.038;
F_z3_before = U_z3_corrected_before/0.038;
F_z4_before = U_z4_corrected_before/0.038;

COP_x_before = (-0.068*F_x_before+0.12*(F_z1_before-F_z2_before-...
    F_z3_before+F_z4_before))./(F_z1_before+F_z2_before+F_z3_before+...
    F_z4_before);
COP_y_before = (-0.068*F_y_before+0.2*(F_z1_before+F_z2_before-...
    F_z3_before-F_z4_before))./(F_z1_before+F_z2_before+F_z3_before+...
    F_z4_before);
COP_before = [COP_x_before(1400:6900);COP_y_before(1400:6900)];

figure
plot(COP_before(1,:),COP_before(2,:))
title('center of pressure before dynamic balance task')
xlabel('displacement in the x-direction [m]')
ylabel('displacement in the y-direction [m]')

pause

fs = 200;
[pxx_x_before,f_x_before] = pwelch(COP_before(1,:)-...
    mean(COP_before(1,:)),[],[],[],fs);
figure
plot(f_x_before,pxx_x_before)
title('power spectral density estimate: x-direction before dynamic balance task')
xlabel('frequency [Hz]')
ylabel('PSD [m^2/Hz]')

pause

[pxx_y_before,f_y_before] = pwelch(COP_before(2,:)-...
    mean(COP_before(2,:)),[],[],[],fs);
figure
plot(f_y_before,pxx_y_before)
title('power spectral density estimate: y-direction before dynamic balance task')
xlabel('frequency [Hz]')
ylabel('PSD [m^2/Hz]')

pause


% CONDITION 2: balancing on the right leg for 30s after a dynamic balance
% task, namely 20 single-leg hops on a soft mat

load('swayFrequencyAfter.afp')

U_x_raw_after = (sum(swayFrequencyAfter1(:,1:2),2))';
U_y_raw_after = (sum(swayFrequencyAfter1(:,3:4),2))';
U_z1_raw_after = (swayFrequencyAfter1(:,5))';
U_z2_raw_after = (swayFrequencyAfter1(:,6))';
U_z3_raw_after = (swayFrequencyAfter1(:,7))';
U_z4_raw_after = (swayFrequencyAfter1(:,8))';

% % A) CORRECTION FOR DRIFT (PIEZOELECTRIC FORCE TRANSDUCERS)

% figure
% plot(U_x_raw_after)
% hold on
% plot(U_y_raw_after)
% legend('U_{x,raw} after','U_{y,raw} after')
% hold off
% figure
% plot(U_z1_raw_after)
% hold on
% plot(U_z2_raw_after)
% plot(U_z3_raw_after)
% plot(U_z4_raw_after)
% legend('U_{z1,raw} after','U_{z2,raw} after','U_{z3,raw} after',...
%     'U_{z4,raw} after')
% hold off

iStart = 500:700;
iEnd = 7500:7700;

coefDriftX_after = polyfit([iStart iEnd],...
    [U_x_raw_after(iStart) U_x_raw_after(iEnd)],1);
U_x_corrected_after = U_x_raw_after-(coefDriftX_after(1)*...
    [0:length(U_x_raw_after)-1]+coefDriftX_after(2));
coefDriftY_after = polyfit([iStart iEnd],...
    [U_y_raw_after(iStart) U_y_raw_after(iEnd)],1);
U_y_corrected_after = U_y_raw_after-(coefDriftY_after(1)*...
    [0:length(U_y_raw_after)-1]+coefDriftY_after(2));
coefDriftZ1_after = polyfit([iStart iEnd],...
    [U_z1_raw_after(iStart) U_z1_raw_after(iEnd)],1);
U_z1_corrected_after = U_z1_raw_after-(coefDriftZ1_after(1)*...
    [0:length(U_z1_raw_after)-1]+coefDriftZ1_after(2));
coefDriftZ2_after = polyfit([iStart iEnd],...
    [U_z2_raw_after(iStart) U_z2_raw_after(iEnd)],1);
U_z2_corrected_after = U_z2_raw_after-(coefDriftZ2_after(1)*...
    [0:length(U_z2_raw_after)-1]+coefDriftZ2_after(2));
coefDriftZ3_after = polyfit([iStart iEnd],...
    [U_z3_raw_after(iStart) U_z3_raw_after(iEnd)],1);
U_z3_corrected_after = U_z3_raw_after-(coefDriftZ3_after(1)*...
    [0:length(U_z3_raw_after)-1]+coefDriftZ3_after(2));
coefDriftZ4_after = polyfit([iStart iEnd],...
    [U_z4_raw_after(iStart) U_z4_raw_after(iEnd)],1);
U_z4_corrected_after = U_z4_raw_after-(coefDriftZ4_after(1)*...
    [0:length(U_z4_raw_after)-1]+coefDriftZ4_after(2));

% figure
% plot(U_x_corrected_after)
% hold on
% plot(U_y_corrected_after)
% legend('U_{x,corrected} after','U_{y,corrected} after')
% hold off
% figure
% plot(U_z1_corrected_after)
% hold on
% plot(U_z2_corrected_after)
% plot(U_z3_corrected_after)
% plot(U_z4_corrected_after)
% legend('U_{z1,corrected} after','U_{z2,corrected} after',...
%     'U_{z3,corrected} after','U_{z4,corrected} after')
% hold off

% % B) CENTER OF PRESSURE

% sensitivities of the system force transducer and charge amplifier
% according to specifications for range 1
F_x_after = U_x_corrected_after/0.08;
F_y_after = U_y_corrected_after/0.08;
F_z1_after = U_z1_corrected_after/0.038;
F_z2_after = U_z2_corrected_after/0.038;
F_z3_after = U_z3_corrected_after/0.038;
F_z4_after = U_z4_corrected_after/0.038;

COP_x_after = (-0.068*F_x_after+0.12*(F_z1_after-F_z2_after-F_z3_after+...
    F_z4_after))./(F_z1_after+F_z2_after+F_z3_after+F_z4_after);
COP_y_after = (-0.068*F_y_after+0.2*(F_z1_after+F_z2_after-F_z3_after-...
    F_z4_after))./(F_z1_after+F_z2_after+F_z3_after+F_z4_after);
COP_after = [COP_x_after(1400:6900);COP_y_after(1400:6900)];

figure
plot(COP_after(1,:),COP_after(2,:))
title('center of pressure after dynamic balance task')
xlabel('displacement in the x-direction [m]')
ylabel('displacement in the y-direction [m]')

pause

fs = 200;
[pxx_x_after,f_x_after] = pwelch(COP_after(1,:)-...
    mean(COP_after(1,:)),[],[],[],fs);
figure
plot(f_x_after,pxx_x_after)
title('power spectral density estimate: x-direction after dynamic balance task')
xlabel('frequency [Hz]')
ylabel('PSD [m^2/Hz]')

pause

[pxx_y_after,f_y_after] = pwelch(COP_after(2,:)-...
    mean(COP_after(2,:)),[],[],[],fs);
figure
plot(f_y_after,pxx_y_after)
title('power spectral density estimate: y-direction after dynamic balance task')
xlabel('frequency [Hz]')
ylabel('PSD [m^2/Hz]')


% LIMITATIONS: experiment with only one leg and 1 specific balance task,
% without variation in time between the balance task and the measurement on
% the force plate; calibration for range 1 only according to specifications