function du=sawtooth(t,dUdt,period)
du=dUdt*sign(sin(2*pi*t/period));