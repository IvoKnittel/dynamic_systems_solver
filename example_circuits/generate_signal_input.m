function [ut, times] = generate_signal_input()
dt=0.03;
times = 0:dt:1;
Umax=5;
period=2;
dUdt=2*Umax*dt/period;
ut = zeros(length(times), 1);
ut(1) = 0 ;

for j = 2:length(times)
    ut(j)             = ut(j-1)+sawtooth(times(j),dUdt,period);
end