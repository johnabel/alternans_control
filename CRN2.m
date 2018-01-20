%% This is a System of CRN-2. There are two state variables: Voltage E and gating variable f.

function [time, St, Al, Con] = CRN2()

[INIT_St, Con] = initCons;
tspan = [0, 1000];
options = odeset('RelTol', 1e-06, 'AbsTol', 1e-12, 'MaxStep', 1);
[time, St] = ode15s(@(time, St)computeRates(time, St, Con), tspan, INIT_St, options);
[Rates, Al] = computeRates(time, St, Con);
Al = computeAl(Al, Con, St, time);

figure(1)  
subplot(3,3,[1 6])
plot(time, St(:,1), 'r')   % Voltage 
xlabel('time (ms)'); ylabel('Voltage (mV)');
subplot(3,3,[7 9])
plot(time, St(:,15), 'g')  % f gating variable 
xlabel('time (ms)'); ylabel('f-gating variable');
end

function [Legend_St, Legend_Al, Legend_time, Legend_Con] = createLegends()
    Legend_St = ''; Legend_Al = ''; Legend_time = ''; Legend_Con = '';
    Legend_time = strpad('time in component environment (millisecond)');
    Legend_St(:,1) = strpad('V in component membrane (millivolt)');
    Legend_Con(:,1) = strpad('R in component membrane (joule_per_mole_kelvin)');
    Legend_Con(:,2) = strpad('T in component membrane (kelvin)');
    Legend_Con(:,3) = strpad('F in component membrane (coulomb_per_millimole)');
    Legend_Con(:,4) = strpad('Cm in component membrane (picoF)');
    Legend_Al(:,1) = strpad('i_st in component membrane (picoA)');
    
    % Al(:,31)=0;
    Legend_Al(:,31) = strpad('i_Na in component fast_sodium_current (picoA)');
    
    Legend_Al(:,51) = strpad('i_K1 in component time_independent_potassium_current (picoA)');
    Legend_Al(:,52) = strpad('i_to in component transient_outward_K_current (picoA)');
    Legend_Al(:,54) = strpad('i_Kur in component ultrarapid_delayed_rectifier_K_current (picoA)');
    Legend_Al(:,55) = strpad('i_Kr in component rapid_delayed_rectifier_K_current (picoA)');
    Legend_Al(:,56) = strpad('i_Ks in component slow_delayed_rectifier_K_current (picoA)');
    Legend_Al(:,57) = strpad('i_Ca_L in component L_type_Ca_channel (picoA)');
    Legend_Al(:,65) = strpad('i_CaP in component sarcolemmal_calcium_pump_current (picoA)');
    Legend_Al(:,59) = strpad('i_NaK in component sodium_potassium_pump (picoA)');
    Legend_Al(:,64) = strpad('i_NaCa in component Na_Ca_exchanger_current (picoA)');
    Legend_Al(:,62) = strpad('i_B_Na in component background_currents (picoA)');
    Legend_Al(:,63) = strpad('i_B_Ca in component background_currents (picoA)');
    %% Stimulus part
    Legend_Con(:,5) = strpad('stim_start in component membrane (millisecond)');
    Legend_Con(:,6) = strpad('stim_end in component membrane (millisecond)');
    Legend_Con(:,7) = strpad('stim_period in component membrane (millisecond)');
    Legend_Con(:,8) = strpad('stim_duration in component membrane (millisecond)');
    Legend_Con(:,9) = strpad('stim_amplitude in component membrane (picoA)');
    %%
    Legend_Al(:,18) = strpad('E_Na in component fast_sodium_current (millivolt)');
    Legend_Con(:,10) = strpad('g_Na in component fast_sodium_current (nanoS_per_picoF)');
    Legend_St(:,2) = strpad('Na_i in component intracellular_ion_concentrations (millimolar)');
    Legend_Con(:,11) = strpad('Na_o in component standard_ionic_concentrations (millimolar)');
    Legend_St(:,3) = strpad('m in component fast_sodium_current_m_gate (dimensionless)');
    Legend_St(:,4) = strpad('h in component fast_sodium_current_h_gate (dimensionless)');
    Legend_St(:,5) = strpad('j in component fast_sodium_current_j_gate (dimensionless)');
   %% m-gating variables properties: m-inf=alpha_m/(alpha_m+bta_m)
    Legend_Al(:,2) = strpad('alpha_m in component fast_sodium_current_m_gate (per_millisecond)');
    Legend_Al(:,19) = strpad('beta_m in component fast_sodium_current_m_gate (per_millisecond)');
    Legend_Al(:,32) = strpad('m_inf in component fast_sodium_current_m_gate (dimensionless)');
    Legend_Al(:,42) = strpad('tau_m in component fast_sodium_current_m_gate (millisecond)');
    %%  h_gating variables properties
    Legend_Al(:,3) = strpad('alpha_h in component fast_sodium_current_h_gate (per_millisecond)');
    Legend_Al(:,20) = strpad('beta_h in component fast_sodium_current_h_gate (per_millisecond)');
    Legend_Al(:,33) = strpad('h_inf in component fast_sodium_current_h_gate (dimensionless)');
    Legend_Al(:,43) = strpad('tau_h in component fast_sodium_current_h_gate (millisecond)');
   
    %% j-gating variables properties
    Legend_Al(:,4) = strpad('alpha_j in component fast_sodium_current_j_gate (per_millisecond)');
    Legend_Al(:,21) = strpad('beta_j in component fast_sodium_current_j_gate (per_millisecond)');
    Legend_Al(:,34) = strpad('j_inf in component fast_sodium_current_j_gate (dimensionless)');
    Legend_Al(:,44) = strpad('tau_j in component fast_sodium_current_j_gate (millisecond)');
    
    %%
    Legend_Al(:,41) = strpad('E_K in component time_independent_potassium_current (millivolt)');
    Legend_Con(:,12) = strpad('g_K1 in component time_independent_potassium_current (nanoS_per_picoF)');
    Legend_Con(:,13) = strpad('K_o in component standard_ionic_concentrations (millimolar)');
    Legend_St(:,6) = strpad('K_i in component intracellular_ion_concentrations (millimolar)');
    Legend_Con(:,14) = strpad('K_Q10 in component transient_outward_K_current (dimensionless)');
    Legend_Con(:,15) = strpad('g_to in component transient_outward_K_current (nanoS_per_picoF)');

    %% oa-gating variables properties
    Legend_St(:,7) = strpad('oa in component transient_outward_K_current_oa_gate (dimensionless)');
    Legend_Al(:,5) = strpad('alpha_oa in component transient_outward_K_current_oa_gate (per_millisecond)');
    Legend_Al(:,22) = strpad('beta_oa in component transient_outward_K_current_oa_gate (per_millisecond)');
    Legend_Al(:,35) = strpad('tau_oa in component transient_outward_K_current_oa_gate (millisecond)');
    Legend_Al(:,45) = strpad('oa_infinity in component transient_outward_K_current_oa_gate (dimensionless)');
   
    %% oi-gating variables properties
    Legend_St(:,8) = strpad('oi in component transient_outward_K_current_oi_gate (dimensionless)');
    Legend_Al(:,6) = strpad('alpha_oi in component transient_outward_K_current_oi_gate (per_millisecond)');
    Legend_Al(:,23) = strpad('beta_oi in component transient_outward_K_current_oi_gate (per_millisecond)');
    Legend_Al(:,36) = strpad('tau_oi in component transient_outward_K_current_oi_gate (millisecond)');
    Legend_Al(:,46) = strpad('oi_infinity in component transient_outward_K_current_oi_gate (dimensionless)');
   %%
    Legend_Al(:,53) = strpad('g_Kur in component ultrarapid_delayed_rectifier_K_current (nanoS_per_picoF)');
    
    % ua
    Legend_St(:,9) = strpad('ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    
    Legend_St(:,10) = strpad('ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    
    %% ua gating variables properties: ua-inf=alpha_ua/(alpha_ua+bta_ua)
    Legend_Al(:,7) = strpad('alpha_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (per_millisecond)');
    Legend_Al(:,24) = strpad('beta_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (per_millisecond)');
    Legend_Al(:,37) = strpad('tau_ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (millisecond)');
    Legend_Al(:,47) = strpad('ua_infinity in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    
    %% ui gating variables properties
    Legend_Al(:,8) = strpad('alpha_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (per_millisecond)');
    Legend_Al(:,25) = strpad('beta_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (per_millisecond)');
    Legend_Al(:,38) = strpad('tau_ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (millisecond)');
    Legend_Al(:,48) = strpad('ui_infinity in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    
       
    %% xr gating variables properties
    Legend_Con(:,16) = strpad('g_Kr in component rapid_delayed_rectifier_K_current (nanoS_per_picoF)');
    Legend_St(:,11) = strpad('xr in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
    Legend_Al(:,9) = strpad('alpha_xr in component rapid_delayed_rectifier_K_current_xr_gate (per_millisecond)');
    Legend_Al(:,26) = strpad('beta_xr in component rapid_delayed_rectifier_K_current_xr_gate (per_millisecond)');
    Legend_Al(:,39) = strpad('tau_xr in component rapid_delayed_rectifier_K_current_xr_gate (millisecond)');
    Legend_Al(:,49) = strpad('xr_infinity in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
   
    %% xs gating variables properties
    Legend_Con(:,17) = strpad('g_Ks in component slow_delayed_rectifier_K_current (nanoS_per_picoF)');
    Legend_St(:,12) = strpad('xs in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    Legend_Al(:,10) = strpad('alpha_xs in component slow_delayed_rectifier_K_current_xs_gate (per_millisecond)');
    Legend_Al(:,27) = strpad('beta_xs in component slow_delayed_rectifier_K_current_xs_gate (per_millisecond)');
    Legend_Al(:,40) = strpad('tau_xs in component slow_delayed_rectifier_K_current_xs_gate (millisecond)');
    Legend_Al(:,50) = strpad('xs_infinity in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    
    %% I_Ca,L and its gating variables
    Legend_Con(:,18) = strpad('g_Ca_L in component L_type_Ca_channel (nanoS_per_picoF)');
    Legend_St(:,13) = strpad('Ca_i in component intracellular_ion_concentrations (millimolar)');
    
    Legend_St(:,14) = strpad('d in component L_type_Ca_channel_d_gate (dimensionless)');
    
    Legend_St(:,15) = strpad('f in component L_type_Ca_channel_f_gate (dimensionless)');
    Legend_St(:,16) = strpad('f_Ca in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    Legend_Al(:,11) = strpad('d_infinity in component L_type_Ca_channel_d_gate (dimensionless)');
   
    Legend_Al(:,28) = strpad('tau_d in component L_type_Ca_channel_d_gate (millisecond)');
    Legend_Al(:,12) = strpad('f_infinity in component L_type_Ca_channel_f_gate (dimensionless)');
    Legend_Al(:,29) = strpad('tau_f in component L_type_Ca_channel_f_gate (millisecond)');
    Legend_Al(:,13) = strpad('f_Ca_infinity in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    Legend_Con(:,45) = strpad('tau_f_Ca in component L_type_Ca_channel_f_Ca_gate (millisecond)');
    %%
    Legend_Con(:,19) = strpad('Km_Na_i in component sodium_potassium_pump (millimolar)');
    Legend_Con(:,20) = strpad('Km_K_o in component sodium_potassium_pump (millimolar)');
    Legend_Con(:,21) = strpad('i_NaK_max in component sodium_potassium_pump (picoA_per_picoF)');
    Legend_Al(:,58) = strpad('f_NaK in component sodium_potassium_pump (dimensionless)');
    Legend_Con(:,46) = strpad('sigma in component sodium_potassium_pump (dimensionless)');
    Legend_Al(:,61) = strpad('i_B_K in component background_currents (picoA)');
    Legend_Con(:,22) = strpad('g_B_Na in component background_currents (nanoS_per_picoF)');
    Legend_Con(:,23) = strpad('g_B_Ca in component background_currents (nanoS_per_picoF)');
    Legend_Con(:,24) = strpad('g_B_K in component background_currents (nanoS_per_picoF)');
    Legend_Al(:,60) = strpad('E_Ca in component background_currents (millivolt)');
    Legend_Con(:,25) = strpad('Ca_o in component standard_ionic_concentrations (millimolar)');
    Legend_Con(:,26) = strpad('I_NaCa_max in component Na_Ca_exchanger_current (picoA_per_picoF)');
    Legend_Con(:,27) = strpad('K_mNa in component Na_Ca_exchanger_current (millimolar)');
    Legend_Con(:,28) = strpad('K_mCa in component Na_Ca_exchanger_current (millimolar)');
    Legend_Con(:,29) = strpad('K_sat in component Na_Ca_exchanger_current (dimensionless)');
    Legend_Con(:,30) = strpad('gamma in component Na_Ca_exchanger_current (dimensionless)');
    Legend_Con(:,31) = strpad('i_CaP_max in component sarcolemmal_calcium_pump_current (picoA_per_picoF)');
    
    %% I_rel and its gating variables
    Legend_Al(:,66) = strpad('i_rel in component Ca_release_current_from_JSR (millimolar_per_millisecond)');
    
    Legend_Al(:,67) = strpad('Fn in component Ca_release_current_from_JSR (dimensionless)');
    Legend_Con(:,32) = strpad('K_rel in component Ca_release_current_from_JSR (per_millisecond)');
    Legend_Con(:,48) = strpad('V_rel in component intracellular_ion_concentrations (micrometre_3)');
    
    Legend_St(:,17) = strpad('Ca_rel in component intracellular_ion_concentrations (millimolar)');
    Legend_St(:,18) = strpad('u in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    Legend_St(:,19) = strpad('v in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    % w
    Legend_St(:,20) = strpad('w in component Ca_release_current_from_JSR_w_gate (dimensionless)');
    
    Legend_Con(:,47) = strpad('tau_u in component Ca_release_current_from_JSR_u_gate (millisecond)');
    Legend_Al(:,69) = strpad('u_infinity in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    
    Legend_Al(:,70) = strpad('tau_v in component Ca_release_current_from_JSR_v_gate (millisecond)');
    Legend_Al(:,72) = strpad('v_infinity in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    
    Legend_Al(:,14) = strpad('tau_w in component Ca_release_current_from_JSR_w_gate (millisecond)');
    Legend_Al(:,30) = strpad('w_infinity in component Ca_release_current_from_JSR_w_gate (dimensionless)');
    %%
    Legend_Al(:,68) = strpad('i_tr in component transfer_current_from_NSR_to_JSR (millimolar_per_millisecond)');
    Legend_Con(:,33) = strpad('tau_tr in component transfer_current_from_NSR_to_JSR (millisecond)');
    Legend_St(:,21) = strpad('Ca_up in component intracellular_ion_concentrations (millimolar)');
    Legend_Con(:,34) = strpad('I_up_max in component Ca_uptake_current_by_the_NSR (millimolar_per_millisecond)');
    Legend_Al(:,71) = strpad('i_up in component Ca_uptake_current_by_the_NSR (millimolar_per_millisecond)');
    Legend_Con(:,35) = strpad('K_up in component Ca_uptake_current_by_the_NSR (millimolar)');
    Legend_Al(:,73) = strpad('i_up_leak in component Ca_leak_current_by_the_NSR (millimolar_per_millisecond)');
    Legend_Con(:,36) = strpad('Ca_up_max in component Ca_leak_current_by_the_NSR (millimolar)');
    Legend_Con(:,37) = strpad('CMDN_max in component Ca_buffers (millimolar)');
    Legend_Con(:,38) = strpad('TRPN_max in component Ca_buffers (millimolar)');
    Legend_Con(:,39) = strpad('CSQN_max in component Ca_buffers (millimolar)');
    Legend_Con(:,40) = strpad('Km_CMDN in component Ca_buffers (millimolar)');
    Legend_Con(:,41) = strpad('Km_TRPN in component Ca_buffers (millimolar)');
    Legend_Con(:,42) = strpad('Km_CSQN in component Ca_buffers (millimolar)');
    Legend_Al(:,15) = strpad('Ca_CMDN in component Ca_buffers (millimolar)');
    Legend_Al(:,16) = strpad('Ca_TRPN in component Ca_buffers (millimolar)');
    Legend_Al(:,17) = strpad('Ca_CSQN in component Ca_buffers (millimolar)');
    Legend_Con(:,43) = strpad('V_cell in component intracellular_ion_concentrations (micrometre_3)');
    Legend_Con(:,44) = strpad('V_i in component intracellular_ion_concentrations (micrometre_3)');
    Legend_Con(:,49) = strpad('V_up in component intracellular_ion_concentrations (micrometre_3)');
    Legend_Al(:,74) = strpad('B1 in component intracellular_ion_concentrations (millimolar_per_millisecond)');
    Legend_Al(:,75) = strpad('B2 in component intracellular_ion_concentrations (dimensionless)');
    Legend_Rates(:,1) = strpad('d/dt V in component membrane (millivolt)');
    Legend_Rates(:,3) = strpad('d/dt m in component fast_sodium_current_m_gate (dimensionless)');
    
    Legend_Rates(:,4) = strpad('d/dt h in component fast_sodium_current_h_gate (dimensionless)');
    Legend_Rates(:,5) = strpad('d/dt j in component fast_sodium_current_j_gate (dimensionless)');
    Legend_Rates(:,7) = strpad('d/dt oa in component transient_outward_K_current_oa_gate (dimensionless)');
    Legend_Rates(:,8) = strpad('d/dt oi in component transient_outward_K_current_oi_gate (dimensionless)');

    Legend_Rates(:,9) = strpad('d/dt ua in component ultrarapid_delayed_rectifier_K_current_ua_gate (dimensionless)');
    
    Legend_Rates(:,10) = strpad('d/dt ui in component ultrarapid_delayed_rectifier_K_current_ui_gate (dimensionless)');
    Legend_Rates(:,11) = strpad('d/dt xr in component rapid_delayed_rectifier_K_current_xr_gate (dimensionless)');
    Legend_Rates(:,12) = strpad('d/dt xs in component slow_delayed_rectifier_K_current_xs_gate (dimensionless)');
    Legend_Rates(:,14) = strpad('d/dt d in component L_type_Ca_channel_d_gate (dimensionless)');
    Legend_Rates(:,15) = strpad('d/dt f in component L_type_Ca_channel_f_gate (dimensionless)');
    Legend_Rates(:,16) = strpad('d/dt f_Ca in component L_type_Ca_channel_f_Ca_gate (dimensionless)');
    Legend_Rates(:,18) = strpad('d/dt u in component Ca_release_current_from_JSR_u_gate (dimensionless)');
    Legend_Rates(:,19) = strpad('d/dt v in component Ca_release_current_from_JSR_v_gate (dimensionless)');
    
    
    Legend_Rates(:,20) = strpad('d/dt w in component Ca_release_current_from_JSR_w_gate (dimensionless)');

    Legend_Rates(:,2) = strpad('d/dt Na_i in component intracellular_ion_concentrations (millimolar)');

    Legend_Rates(:,6) = strpad('d/dt K_i in component intracellular_ion_concentrations (millimolar)');
    
    Legend_Rates(:,13) = strpad('d/dt Ca_i in component intracellular_ion_concentrations (millimolar');
 
    Legend_Rates(:,21) = strpad('d/dt Ca_up in component intracellular_ion_concentrations (millimolar)');

    
    Legend_Rates(:,17) = strpad('d/dt Ca_rel in component intracellular_ion_concentrations (millimolar)');
    
    Legend_St  = Legend_St';
    Legend_Al = Legend_Al';
    Legend_Rates = Legend_Rates';
    Legend_Con = Legend_Con';
end

function [St, Con] = initCons()
time = 0; Con = []; St = []; Al = [];

St(:,1) = -10;    % instead of stimulus current, I change the voltage initial condition (to avoid artifact)
%St(:,1) = -81.18;
Con(:,1) = 8.3143;
Con(:,2) = 310;
Con(:,3) = 96.4867;
Con(:,4) = 100;
Con(:,5) = 50;
Con(:,6) = 50000;
Con(:,7) = 1000;
Con(:,8) = 2;
Con(:,9) = 0;
%Con(:,9) = -2000;
Con(:,10) = 7.8;
St(:,2) = 1.117e+01;
Con(:,11) = 140;
St(:,3) = 2.908e-3;
St(:,4) = 9.649e-1;
St(:,5) = 9.775e-1;
Con(:,12) = 0.09;
Con(:,13) = 5.4;
St(:,6) = 1.39e+02;
Con(:,14) = 3;
Con(:,15) = 0.1652;
St(:,7) = 3.043e-2;
St(:,8) = 9.992e-1;
St(:,9) = 4.966e-3;
St(:,10) = 9.986e-1;
Con(:,16) = 0.029411765;
St(:,11) = 3.296e-5;  %xr
Con(:,17) = 0.12941176;
St(:,12) = 1.869e-2;  %xs
Con(:,18) = 0.12375;

St(:,13) = 0.01*1.013e-4; %Cai

St(:,14) = 1.367e-4;
St(:,15) = 9.996e-1;
St(:,16) = 7.755e-1;
Con(:,19) = 10;
Con(:,20) = 1.5;
Con(:,21) = 0.59933874;
Con(:,22) = 0.0006744375;
Con(:,23) = 0.001131;
Con(:,24) = 0;
Con(:,25) = 1.8;
Con(:,26) = 1600;
Con(:,27) = 87.5;
Con(:,28) = 1.38;
Con(:,29) = 0.1;
Con(:,30) = 0.35;
Con(:,31) = 0.275;
Con(:,32) = 30;
St(:,17) = 1.488;
St(:,18) = 2.35e-112;
St(:,19) = 1;
St(:,20) = 0.9992;
Con(:,33) = 180;
St(:,21) = 1.488;
Con(:,34) = 0.005;
Con(:,35) = 0.00092;
Con(:,36) = 15;
Con(:,37) = 0.05;
Con(:,38) = 0.07;
Con(:,39) = 10;
Con(:,40) = 0.00238;
Con(:,41) = 0.0005;
Con(:,42) = 0.8;
Con(:,43) = 20100;
Con(:,44) =  Con(:,43).*0.680000;
Con(:,45) = 2.00000;
Con(:,46) =  (1.00000./7.00000).*(exp(Con(:,11)./67.3000) - 1.00000);
Con(:,47) = 8.00000;
Con(:,48) =  0.00480000.*Con(:,43);
Con(:,49) =  0.0552000.*Con(:,43);

if (isempty(St)), warning('Initial values for St not set');, end
end

function [Rates, Al] = computeRates(time, St, Con)
global AlVariableCount;
StSize = size(St);
StColumnCount = StSize(2);
if ( StColumnCount == 1)
    St = St';
    Al = zeros(1, AlVariableCount);
else
    StRowCount = StSize(1);
    Al = zeros(StRowCount, AlVariableCount);
    Rates = zeros(StRowCount, StColumnCount);
end
Al(:,13) = power(1.00000+St(:,13)./0.000350000,  - 1.00000);
%Rates(:,16) = (Al(:,13) - St(:,16))./Con(:,45);
Rates(:,16) = 0;  % d/dt f_Ca


Al(:,11) = power(1.00000+exp((St(:,1)+10.0000)./ - 8.00000),  - 1.00000);
Al(:,28) = piecewise({abs(St(:,1)+10.0000)<1.00000e-10, 4.57900./(1.00000+exp((St(:,1)+10.0000)./ - 6.24000)) }, (1.00000 - exp((St(:,1)+10.0000)./ - 6.24000))./( 0.0350000.*(St(:,1)+10.0000).*(1.00000+exp((St(:,1)+10.0000)./ - 6.24000))));
Rates(:,14) = 0;   % d/dt d

Al(:,12) = exp( - (St(:,1)+28.0000)./6.90000)./(1.00000+exp( - (St(:,1)+28.0000)./6.90000));
Al(:,29) =  9.00000.*power( 0.0197000.*exp(  - power(0.0337000, 2.00000).*power(St(:,1)+10.0000, 2.00000))+0.0200000,  - 1.00000);
Rates(:,15) = (Al(:,12) - St(:,15))./Al(:,29);  % d/dt f

% tau_w
Al(:,14) = piecewise({abs(St(:,1) - 7.90000)<1.00000e-10, ( 6.00000.*0.200000)./1.30000 }, ( 6.00000.*(1.00000 - exp( - (St(:,1) - 7.90000)./5.00000)))./( (1.00000+ 0.300000.*exp( - (St(:,1) - 7.90000)./5.00000)).*1.00000.*(St(:,1) - 7.90000)));

% w_inf
Al(:,30) = 1.00000 - power(1.00000+exp( - (St(:,1) - 40.0000)./17.0000),  - 1.00000);

%d/dt w
Rates(:,20) = 0;
Al(:,2) = piecewise({St(:,1)== - 47.1300, 3.20000 }, ( 0.320000.*(St(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(St(:,1)+47.1300))));
Al(:,19) =  0.0800000.*exp( - St(:,1)./11.0000);
Al(:,32) = heaviside(St(:,1)-(-32.7));  % m_inf equation
Al(:,42) = 1.00000./(Al(:,2)+Al(:,19));  % tau_m equation
Rates(:,3) =0;        %d/dt m
Al(:,3) = piecewise({St(:,1)< - 40.0000,  0.135000.*exp((St(:,1)+80.0000)./ - 6.80000) }, 0.00000);
Al(:,20) = piecewise({St(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*St(:,1))+ 310000..*exp( 0.350000.*St(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((St(:,1)+10.6600)./ - 11.1000))));
Al(:,33) = heaviside(-St(:,1)+(-66.6)); %h_inf
Al(:,43) = 1.00000./(Al(:,3)+Al(:,20));
Rates(:,4) = 0;       % d/dt h
Al(:,4) = piecewise({St(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*St(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*St(:,1))).*(St(:,1)+37.7800))./(1.00000+exp( 0.311000.*(St(:,1)+79.2300))) }, 0.00000);
Al(:,21) = piecewise({St(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*St(:,1)))./(1.00000+exp(  - 0.137800.*(St(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*St(:,1)))./(1.00000+exp(  - 0.100000.*(St(:,1)+32.0000))));
Al(:,34) = Al(:,4)./(Al(:,4)+Al(:,21));
Al(:,44) = 1.00000./(Al(:,4)+Al(:,21));
%Rates(:,5) = (Al(:,34) - St(:,5))./Al(:,44);
Rates(:,5) = 0;    % d/dt j

Al(:,5) =  0.650000.*power(exp((St(:,1) -  - 10.0000)./ - 8.50000)+exp(((St(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
Al(:,22) =  0.650000.*power(2.50000+exp(((St(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
Al(:,35) = power(Al(:,5)+Al(:,22),  - 1.00000)./Con(:,14);
Al(:,45) = power(1.00000+exp(((St(:,1) -  - 10.0000)+10.4700)./ - 17.5400),  - 1.00000);
Rates(:,7) = 0;  % d/dt Oa

Al(:,6) = power(18.5300+ 1.00000.*exp(((St(:,1) -  - 10.0000)+103.700)./10.9500),  - 1.00000);
Al(:,23) = power(35.5600+ 1.00000.*exp(((St(:,1) -  - 10.0000) - 8.74000)./ - 7.44000),  - 1.00000);
Al(:,36) = power(Al(:,6)+Al(:,23),  - 1.00000)./Con(:,14);
Al(:,46) = power(1.00000+exp(((St(:,1) -  - 10.0000)+33.1000)./5.30000),  - 1.00000);
% Rates(:,8) = (Al(:,46) - St(:,8))./Al(:,36);
Rates(:,8) = 0;  % d/dt oi
Al(:,7) =  0.650000.*power(exp((St(:,1) -  - 10.0000)./ - 8.50000)+exp(((St(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
Al(:,24) =  0.650000.*power(2.50000+exp(((St(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
Al(:,37) = power(Al(:,7)+Al(:,24),  - 1.00000)./Con(:,14);  % tau-ua
Al(:,47) = power(1.00000+exp(((St(:,1) -  - 10.0000)+20.3000)./ - 9.60000),  - 1.00000);    % ua_inf
% Rates(:,9) = (Al(:,47) - St(:,9))./Al(:,37);
Rates(:,9) = 0;  %   d/dt ua:
Al(:,8) = power(21.0000+ 1.00000.*exp(((St(:,1) -  - 10.0000) - 195.000)./ - 28.0000),  - 1.00000);
Al(:,25) = 1.00000./exp(((St(:,1) -  - 10.0000) - 168.000)./ - 16.0000);
Al(:,38) = power(Al(:,8)+Al(:,25),  - 1.00000)./Con(:,14);
Al(:,48) = power(1.00000+exp(((St(:,1) -  - 10.0000) - 109.450)./27.4800),  - 1.00000);
%Rates(:,10) =  Con(:,50).*((Al(:,48) - St(:,10))./Al(:,38));
Rates(:,10) = 0;    % dui/dt
Al(:,9) = piecewise({abs(St(:,1)+14.1000)<1.00000e-10, 0.00150000 }, ( 0.000300000.*(St(:,1)+14.1000))./(1.00000 - exp((St(:,1)+14.1000)./ - 5.00000)));
Al(:,26) = piecewise({abs(St(:,1) - 3.33280)<1.00000e-10, 0.000378361 }, ( 7.38980e-05.*(St(:,1) - 3.33280))./(exp((St(:,1) - 3.33280)./5.12370) - 1.00000));
Al(:,39) = power(Al(:,9)+Al(:,26),  - 1.00000);
%Al(:,49) = power(1.00000+exp((St(:,1)+14.1000)./ - 6.50000),  - 1.00000);
Al(:,49)= 0.6143*(1-1.2348*St(:,15));  % xr-inf
%Rates(:,11) = (Al(:,49) - St(:,11))./Al(:,39);
Rates(:,11)=0;    % d/dt xr
Al(:,10) = piecewise({abs(St(:,1) - 19.9000)<1.00000e-10, 0.000680000 }, ( 4.00000e-05.*(St(:,1) - 19.9000))./(1.00000 - exp((St(:,1) - 19.9000)./ - 17.0000)));
Al(:,27) = piecewise({abs(St(:,1) - 19.9000)<1.00000e-10, 0.000315000 }, ( 3.50000e-05.*(St(:,1) - 19.9000))./(exp((St(:,1) - 19.9000)./9.00000) - 1.00000));
Al(:,40) =  0.500000.*power(Al(:,10)+Al(:,27),  - 1.00000);
%Al(:,50) = power(1.00000+exp((St(:,1) - 19.9000)./ - 12.7000),  - 0.500000);
Al(:,50) = 0.25*(1-1.1*St(:,15)); % xs-inf
%Rates(:,12) = (Al(:,50) - St(:,12))./Al(:,40);
Rates(:,12) =0; % d/dt xs
Al(:,41) =  (( Con(:,1).*Con(:,2))./Con(:,3)).*log(Con(:,13)./St(:,6));
Al(:,51) = ( Con(:,4).*Con(:,12).*(St(:,1) - Al(:,41)))./(1.00000+exp( 0.0700000.*(St(:,1)+80.0000)));

%Al(:,52) =  Con(:,4).*Con(:,15).*power(St(:,7), 3.00000).*St(:,8).*(St(:,1) - Al(:,41));
%Al(:,52) =  Con(:,4).*Con(:,15).*power(Al(:,45), 3.00000).*St(:,8).*(St(:,1) - Al(:,41));
Al(:,52) =  Con(:,4).*Con(:,15).*power(Al(:,45), 3.00000).*Al(:,46).*(St(:,1) - Al(:,41)); %% I-to
Al(:,53) = 0.00500000+0.0500000./(1.00000+exp((St(:,1) - 15.0000)./ - 13.0000));

% Al(:,54) =  Con(:,4).*Al(:,53).*power(St(:,9), 3.00000).*St(:,10).*(St(:,1) - Al(:,41));
Al(:,54) =  Con(:,4).*Al(:,53).*power(Al(:,47), 3.00000).*St(:,10).*(St(:,1) - Al(:,41));

%Al(:,55) = ( Con(:,4).*Con(:,16).*St(:,11).*(St(:,1) - Al(:,41)))./(1.00000+exp((St(:,1)+15.0000)./22.4000)); %% I-kr
Al(:,55) = ( Con(:,4).*Con(:,16).*Al(:,49).*(St(:,1) - Al(:,41)))./(1.00000+exp((St(:,1)+15.0000)./22.4000));

% Al(:,56) =  Con(:,4).*Con(:,17).*power(St(:,12), 2.00000).*(St(:,1) - Al(:,41));   %% I-ks
Al(:,56) =  Con(:,4).*Con(:,17).*power(Al(:,50), 2.00000).*(St(:,1) - Al(:,41));

Al(:,58) = power(1.00000+ 0.124500.*exp((  - 0.100000.*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2)))+ 0.0365000.*Con(:,46).*exp((  - Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))),  - 1.00000);
Al(:,59) = ( (( Con(:,4).*Con(:,21).*Al(:,58).*1.00000)./(1.00000+power(Con(:,19)./St(:,2), 1.50000))).*Con(:,13))./(Con(:,13)+Con(:,20));
Al(:,61) =  Con(:,4).*Con(:,24).*(St(:,1) - Al(:,41));

Rates(:,6) =0;  %d/dt Ki
Al(:,18) =  (( Con(:,1).*Con(:,2))./Con(:,3)).*log(Con(:,11)./St(:,2));
Al(:,31) = 0;  % I_Na

Al(:,64) = ( Con(:,4).*Con(:,26).*( exp(( Con(:,30).*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))).*power(St(:,2), 3.00000).*Con(:,25) -  exp(( (Con(:,30) - 1.00000).*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))).*power(Con(:,11), 3.00000).*St(:,13)))./( (power(Con(:,27), 3.00000)+power(Con(:,11), 3.00000)).*(Con(:,28)+Con(:,25)).*(1.00000+ Con(:,29).*exp(( (Con(:,30) - 1.00000).*St(:,1).*Con(:,3))./( Con(:,1).*Con(:,2)))));
Al(:,62) =  Con(:,4).*Con(:,22).*(St(:,1) - Al(:,18));

Rates(:,2) =0;   % d/dt Na-i

Al(:,1) = piecewise({time>=Con(:,5)&time<=Con(:,6)&(time - Con(:,5)) -  floor((time - Con(:,5))./Con(:,7)).*Con(:,7)<=Con(:,8), Con(:,9) }, 0.00000);

%Al(:,57) =  Con(:,4).*Con(:,18).*Al(:,11).*St(:,15).*St(:,16).*(St(:,1) - 65.0000);
Al(:,57) =  Con(:,4).*Con(:,18).*Al(:,11).*St(:,15).*Al(:,13).*(St(:,1) - 65.0000);

Al(:,65) = ( Con(:,4).*Con(:,31).*St(:,13))./(0.000500000+St(:,13));
Al(:,60) =  (( Con(:,1).*Con(:,2))./( 2.00000.*Con(:,3))).*log(Con(:,25)./St(:,13));
Al(:,63) =  Con(:,4).*Con(:,23).*(St(:,1) - Al(:,60));
Rates(:,1) =  - (Al(:,31)+Al(:,51)+Al(:,52)+Al(:,54)+Al(:,55)+Al(:,56)+Al(:,62)+Al(:,63)+Al(:,59)+Al(:,65)+Al(:,64)+Al(:,57)+Al(:,1))./Con(:,4);
%% I_rel
%Al(:,66) =  Con(:,32).*power(St(:,18), 2.00000).*St(:,19).*Al(:,30).*(St(:,17) - St(:,13));
%Al(:,66) =  Con(:,32).*power(St(:,18), 2.00000).*St(:,19).*Al(:,30).*St(:,17);
%Al(:,66) =  Con(:,32).*power(Al(:,69), 2.00000).*Al(:,72).*Al(:,30).*St(:,17);
Al(:,66) = 0;

Al(:,68) = (St(:,21) - St(:,17))./Con(:,33);    % I-tr
% Rates(:,17) =  (Al(:,68) - Al(:,66)).*power(1.00000+( Con(:,39).*Con(:,42))./power(St(:,17)+Con(:,42), 2.00000),  - 1.00000);
Rates(:,17) =0; % d/dt Ca-rel

Al(:,67) =  1000.00.*( 1.00000e-15.*Con(:,48).*Al(:,66) -  (1.00000e-15./( 2.00000.*Con(:,3))).*( 0.500000.*Al(:,57) -  0.200000.*Al(:,64)));
%% u_inf --> Heaviside function:
%Al(:,69) = power(1.00000+exp( - (Al(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
%Al(:,69)=heaviside(Al(:,67)-3.4175e-13);
Al(:,69) =0;

%Rates(:,18) = (Al(:,69) - St(:,18))./Con(:,47);
Rates(:,18) = 0;   % d/dt u

%% v_inf --> Heaviside function:
%Al(:,72) = 1.00000 - power(1.00000+exp( - (Al(:,67) - 6.83500e-14)./1.36700e-15),  - 1.00000);
% Al(:,72)=heaviside(Al(:,67)-6.8350e-14);
Al(:,72) =1;

Al(:,70) = 1.91000+ 2.09000.*power(1.00000+exp( - (Al(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);   % tau_v
%Rates(:,19) = (Al(:,72) - St(:,19))./Al(:,70);
Rates(:,19) = 0;   % d/dt v

Al(:,71) = Con(:,34)./(1.00000+Con(:,35)./St(:,13));
Al(:,73) = ( Con(:,34).*St(:,21))./Con(:,36);

Rates(:,21) =0;   % dCa-uptake/dt

Al(:,74) = ( 2.00000.*Al(:,64) - (Al(:,65)+Al(:,57)+Al(:,63)))./( 2.00000.*Con(:,44).*Con(:,3))+( Con(:,49).*(Al(:,73) - Al(:,71))+ Al(:,66).*Con(:,48))./Con(:,44);
Al(:,75) = 1.00000+( Con(:,38).*Con(:,41))./power(St(:,13)+Con(:,41), 2.00000)+( Con(:,37).*Con(:,40))./power(St(:,13)+Con(:,40), 2.00000);
% Rates(:,13) = Al(:,74)./Al(:,75);  % d/dt Cai
Rates(:,13) = 0; 
Rates = Rates';
end

% Calculate Al variables
function Al = computeAl(Al, Con, St, time)
Al(:,13) = power(1.00000+St(:,13)./0.000350000,  - 1.00000);
Al(:,11) = power(1.00000+exp((St(:,1)+10.0000)./ - 8.00000),  - 1.00000);
Al(:,28) = piecewise({abs(St(:,1)+10.0000)<1.00000e-10, 4.57900./(1.00000+exp((St(:,1)+10.0000)./ - 6.24000)) }, (1.00000 - exp((St(:,1)+10.0000)./ - 6.24000))./( 0.0350000.*(St(:,1)+10.0000).*(1.00000+exp((St(:,1)+10.0000)./ - 6.24000))));
Al(:,12) = exp( - (St(:,1)+28.0000)./6.90000)./(1.00000+exp( - (St(:,1)+28.0000)./6.90000));
Al(:,29) =  9.00000.*power( 0.0197000.*exp(  - power(0.0337000, 2.00000).*power(St(:,1)+10.0000, 2.00000))+0.0200000,  - 1.00000);
Al(:,14) = piecewise({abs(St(:,1) - 7.90000)<1.00000e-10, ( 6.00000.*0.200000)./1.30000 }, ( 6.00000.*(1.00000 - exp( - (St(:,1) - 7.90000)./5.00000)))./( (1.00000+ 0.300000.*exp( - (St(:,1) - 7.90000)./5.00000)).*1.00000.*(St(:,1) - 7.90000)));  % tau_w
Al(:,30) = 1.00000 - power(1.00000+exp( - (St(:,1) - 40.0000)./17.0000),  - 1.00000);  % w_inf
Al(:,2) = piecewise({St(:,1)== - 47.1300, 3.20000 }, ( 0.320000.*(St(:,1)+47.1300))./(1.00000 - exp(  - 0.100000.*(St(:,1)+47.1300))));
Al(:,19) =  0.0800000.*exp( - St(:,1)./11.0000);
Al(:,32) = heaviside(St(:,1)-(-32.7));   % m_inf

Al(:,42) = 1.00000./(Al(:,2)+Al(:,19));
Al(:,3) = piecewise({St(:,1)< - 40.0000,  0.135000.*exp((St(:,1)+80.0000)./ - 6.80000) }, 0.00000);
Al(:,20) = piecewise({St(:,1)< - 40.0000,  3.56000.*exp( 0.0790000.*St(:,1))+ 310000..*exp( 0.350000.*St(:,1)) }, 1.00000./( 0.130000.*(1.00000+exp((St(:,1)+10.6600)./ - 11.1000))));
Al(:,33) = heaviside(-St(:,1)+(-66.6));   % h_inf

Al(:,43) = 1.00000./(Al(:,3)+Al(:,20));
Al(:,4) = piecewise({St(:,1)< - 40.0000, ( (  - 127140..*exp( 0.244400.*St(:,1)) -  3.47400e-05.*exp(  - 0.0439100.*St(:,1))).*(St(:,1)+37.7800))./(1.00000+exp( 0.311000.*(St(:,1)+79.2300))) }, 0.00000);
Al(:,21) = piecewise({St(:,1)< - 40.0000, ( 0.121200.*exp(  - 0.0105200.*St(:,1)))./(1.00000+exp(  - 0.137800.*(St(:,1)+40.1400))) }, ( 0.300000.*exp(  - 2.53500e-07.*St(:,1)))./(1.00000+exp(  - 0.100000.*(St(:,1)+32.0000))));
Al(:,34) = Al(:,4)./(Al(:,4)+Al(:,21));
Al(:,44) = 1.00000./(Al(:,4)+Al(:,21));
Al(:,5) =  0.650000.*power(exp((St(:,1) -  - 10.0000)./ - 8.50000)+exp(((St(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);
Al(:,22) =  0.650000.*power(2.50000+exp(((St(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);
Al(:,35) = power(Al(:,5)+Al(:,22),  - 1.00000)./Con(:,14);
Al(:,45) = power(1.00000+exp(((St(:,1) -  - 10.0000)+10.4700)./ - 17.5400),  - 1.00000);
Al(:,6) = power(18.5300+ 1.00000.*exp(((St(:,1) -  - 10.0000)+103.700)./10.9500),  - 1.00000);
Al(:,23) = power(35.5600+ 1.00000.*exp(((St(:,1) -  - 10.0000) - 8.74000)./ - 7.44000),  - 1.00000);
Al(:,36) = power(Al(:,6)+Al(:,23),  - 1.00000)./Con(:,14);
Al(:,46) = power(1.00000+exp(((St(:,1) -  - 10.0000)+33.1000)./5.30000),  - 1.00000);

Al(:,7) =  0.650000.*power(exp((St(:,1) -  - 10.0000)./ - 8.50000)+exp(((St(:,1) -  - 10.0000) - 40.0000)./ - 59.0000),  - 1.00000);   % alpha_ua:
Al(:,24) =  0.650000.*power(2.50000+exp(((St(:,1) -  - 10.0000)+72.0000)./17.0000),  - 1.00000);    % beta_ua:
Al(:,37) = power(Al(:,7)+Al(:,24),  - 1.00000)./Con(:,14);     % tau_ua:
Al(:,47) = power(1.00000+exp(((St(:,1) -  - 10.0000)+20.3000)./ - 9.60000),  - 1.00000);    % ua_inf:

Al(:,8) = power(21.0000+ 1.00000.*exp(((St(:,1) -  - 10.0000) - 195.000)./ - 28.0000),  - 1.00000);
Al(:,25) = 1.00000./exp(((St(:,1) -  - 10.0000) - 168.000)./ - 16.0000);
Al(:,38) = power(Al(:,8)+Al(:,25),  - 1.00000)./Con(:,14);
Al(:,48) = power(1.00000+exp(((St(:,1) -  - 10.0000) - 109.450)./27.4800),  - 1.00000);
Al(:,9) = piecewise({abs(St(:,1)+14.1000)<1.00000e-10, 0.00150000 }, ( 0.000300000.*(St(:,1)+14.1000))./(1.00000 - exp((St(:,1)+14.1000)./ - 5.00000)));
Al(:,26) = piecewise({abs(St(:,1) - 3.33280)<1.00000e-10, 0.000378361 }, ( 7.38980e-05.*(St(:,1) - 3.33280))./(exp((St(:,1) - 3.33280)./5.12370) - 1.00000));
Al(:,39) = power(Al(:,9)+Al(:,26),  - 1.00000);

%Al(:,49) = power(1.00000+exp((St(:,1)+14.1000)./ - 6.50000),  - 1.00000);
Al(:,49)= 0.6143*(1-1.2348*St(:,15));    % xr-inf
Al(:,10) = piecewise({abs(St(:,1) - 19.9000)<1.00000e-10, 0.000680000 }, ( 4.00000e-05.*(St(:,1) - 19.9000))./(1.00000 - exp((St(:,1) - 19.9000)./ - 17.0000)));
Al(:,27) = piecewise({abs(St(:,1) - 19.9000)<1.00000e-10, 0.000315000 }, ( 3.50000e-05.*(St(:,1) - 19.9000))./(exp((St(:,1) - 19.9000)./9.00000) - 1.00000));
Al(:,40) =  0.500000.*power(Al(:,10)+Al(:,27),  - 1.00000);

% Al(:,50) = power(1.00000+exp((St(:,1) - 19.9000)./ - 12.7000),  - 0.500000);
Al(:,50) = 0.25*(1-1.1*St(:,15));    % xs-inf
Al(:,41) =  (( Con(:,1).*Con(:,2))./Con(:,3)).*log(Con(:,13)./St(:,6));
Al(:,51) = ( Con(:,4).*Con(:,12).*(St(:,1) - Al(:,41)))./(1.00000+exp( 0.0700000.*(St(:,1)+80.0000)));
% Al(:,52) =  Con(:,4).*Con(:,15).*power(St(:,7), 3.00000).*St(:,8).*(St(:,1) - Al(:,41));
% Al(:,52) =  Con(:,4).*Con(:,15).*power(Al(:,45), 3.00000).*St(:,8).*(St(:,1) - Al(:,41));
Al(:,52) =  Con(:,4).*Con(:,15).*power(Al(:,45), 3.00000).*Al(:,46).*(St(:,1) - Al(:,41));    % I-to
Al(:,53) = 0.00500000+0.0500000./(1.00000+exp((St(:,1) - 15.0000)./ - 13.0000));
Al(:,54) =  Con(:,4).*Al(:,53).*power(Al(:,47), 3.00000).*St(:,10).*(St(:,1) - Al(:,41));
%Al(:,55) = ( Con(:,4).*Con(:,16).*St(:,11).*(St(:,1) - Al(:,41)))./(1.00000+exp((St(:,1)+15.0000)./22.4000));
Al(:,55) = ( Con(:,4).*Con(:,16).*Al(:,49).*(St(:,1) - Al(:,41)))./(1.00000+exp((St(:,1)+15.0000)./22.4000));   % I-kr
% Al(:,56) =  Con(:,4).*Con(:,17).*power(St(:,12), 2.00000).*(St(:,1) - Al(:,41));   % I-ks
Al(:,56) =  Con(:,4).*Con(:,17).*power(Al(:,50), 2.00000).*(St(:,1) - Al(:,41));

Al(:,58) = power(1.00000+ 0.124500.*exp((  - 0.100000.*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2)))+ 0.0365000.*Con(:,46).*exp((  - Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))),  - 1.00000);
Al(:,59) = ( (( Con(:,4).*Con(:,21).*Al(:,58).*1.00000)./(1.00000+power(Con(:,19)./St(:,2), 1.50000))).*Con(:,13))./(Con(:,13)+Con(:,20));
Al(:,61) =  Con(:,4).*Con(:,24).*(St(:,1) - Al(:,41));
Al(:,18) =  (( Con(:,1).*Con(:,2))./Con(:,3)).*log(Con(:,11)./St(:,2));
Al(:,31) = 0; % . I_Na
Al(:,64) = ( Con(:,4).*Con(:,26).*( exp(( Con(:,30).*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))).*power(St(:,2), 3.00000).*Con(:,25) -  exp(( (Con(:,30) - 1.00000).*Con(:,3).*St(:,1))./( Con(:,1).*Con(:,2))).*power(Con(:,11), 3.00000).*St(:,13)))./( (power(Con(:,27), 3.00000)+power(Con(:,11), 3.00000)).*(Con(:,28)+Con(:,25)).*(1.00000+ Con(:,29).*exp(( (Con(:,30) - 1.00000).*St(:,1).*Con(:,3))./( Con(:,1).*Con(:,2)))));
Al(:,62) =  Con(:,4).*Con(:,22).*(St(:,1) - Al(:,18));
Al(:,1) = piecewise({time>=Con(:,5)&time<=Con(:,6)&(time - Con(:,5)) -  floor((time - Con(:,5))./Con(:,7)).*Con(:,7)<=Con(:,8), Con(:,9) }, 0.00000);
%Al(:,57) =  Con(:,4).*Con(:,18).*Al(:,11).*St(:,15).*St(:,16).*(St(:,1) - 65.0000);
Al(:,57) =  Con(:,4).*Con(:,18).*Al(:,11).*St(:,15).*Al(:,13).*(St(:,1) - 65.0000);

Al(:,65) = ( Con(:,4).*Con(:,31).*St(:,13))./(0.000500000+St(:,13));
Al(:,60) =  (( Con(:,1).*Con(:,2))./( 2.00000.*Con(:,3))).*log(Con(:,25)./St(:,13));
Al(:,63) =  Con(:,4).*Con(:,23).*(St(:,1) - Al(:,60));

%% I-release
%Al(:,66) =  Con(:,32).*power(St(:,18), 2.00000).*St(:,19).*Al(:,30).*(St(:,17) - St(:,13));
%Al(:,66) =  Con(:,32).*power(St(:,18), 2.00000).*St(:,19).*Al(:,30).*St(:,17);
%Al(:,66) =  Con(:,32).*power(Al(:,69), 2.00000).*Al(:,72).*Al(:,30).*St(:,17);
Al(:,66) = 0;
Al(:,68) = (St(:,21) - St(:,17))./Con(:,33);   % I-tr
Al(:,67) =  1000.00.*( 1.00000e-15.*Con(:,48).*Al(:,66) -  (1.00000e-15./( 2.00000.*Con(:,3))).*( 0.500000.*Al(:,57) -  0.200000.*Al(:,64)));

%% u_inf --> Heaviside function:
%Al(:,69) = power(1.00000+exp( - (Al(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);
% Al(:,69)=heaviside(Al(:,67)-3.4175e-13);
Al(:,69)=0;
Al(:,70) = 1.91000+ 2.09000.*power(1.00000+exp( - (Al(:,67) - 3.41750e-13)./1.36700e-15),  - 1.00000);    % tau_v
%% v_inf --> Heaviside function:
%Al(:,72) = 1.00000 - power(1.00000+exp( - (Al(:,67) - 6.83500e-14)./1.36700e-15),  - 1.00000);
% Al(:,72)=heaviside(Al(:,67)-6.8350e-14);
Al(:,72)=0;
Al(:,71) = Con(:,34)./(1.00000+Con(:,35)./St(:,13));
Al(:,73) = ( Con(:,34).*St(:,21))./Con(:,36);
Al(:,74) = ( 2.00000.*Al(:,64) - (Al(:,65)+Al(:,57)+Al(:,63)))./( 2.00000.*Con(:,44).*Con(:,3))+( Con(:,49).*(Al(:,73) - Al(:,71))+ Al(:,66).*Con(:,48))./Con(:,44);
Al(:,75) = 1.00000+( Con(:,38).*Con(:,41))./power(St(:,13)+Con(:,41), 2.00000)+( Con(:,37).*Con(:,40))./power(St(:,13)+Con(:,40), 2.00000);
Al(:,15) = ( Con(:,37).*St(:,13))./(St(:,13)+Con(:,40));
Al(:,16) = ( Con(:,38).*St(:,13))./(St(:,13)+Con(:,41));
Al(:,17) = ( Con(:,39).*St(:,17))./(St(:,17)+Con(:,42));
end

% Compute result of a piecewise function
function x = piecewise(cases, default)
    set = [0];
    for i = 1:2:length(cases)
        if (length(cases{i+1}) == 1)
            x(cases{i} & ~set,:) = cases{i+1};
        else
            x(cases{i} & ~set,:) = cases{i+1}(cases{i} & ~set);
        end
        set = set | cases{i};
        if(set), break, end
    end
    if (length(default) == 1)
        x(~set,:) = default;
    else
        x(~set,:) = default(~set);
    end
end

% Pad out or shorten strings to a set length
function strout = strpad(strin)
    req_length = 160;
    insize = size(strin,2);
    if insize > req_length
        strout = strin(1:req_length);
    else
        strout = [strin, blanks(req_length - insize)];
    end
end

