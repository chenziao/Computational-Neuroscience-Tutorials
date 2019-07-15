: alf-dendrotoxin sensitive, slowly inactivating channel

NEURON {
	SUFFIX kA
	USEION k READ ek WRITE ik
	RANGE gkAbar, gkA,  ia
	RANGE uinf, zinf, utau, ztau
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	gkAbar = 0.200 (siemens/cm2) <0,1e9>
}

ASSIGNED {
	v (mV)
	ek (mV)
	ik (mA/cm2)
	uinf
	zinf 
	utau (ms)
	ztau (ms)
	gkA (siemens/cm2)
	ia
}

STATE {
	u z
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gkA = gkAbar*u*u*u*z
	ik = gkA*(v-ek)
	ia = ik
}

INITIAL {
	rate(v)
	u = uinf
	z = zinf
}

DERIVATIVE states {
	rate(v)
	u' = (uinf-u)/utau
	z' = (zinf-z)/ztau
}

PROCEDURE rate(v(mV)) {
	UNITSOFF
	uinf = (1.0)/(1.0+(exp (-(v+27)/(8.7))))       
	utau = ((11.6) - (10.4)/(1.0+(exp (-(v+32.9)/(15.2)))))         
	zinf = 1.0/(1.0+(exp ((v+56.9)/(4.9))))       
	ztau = (38.6 - 29.2/(1.0+(exp (-(v+38.9)/(26.5)))))     
	UNITSON
}
	

