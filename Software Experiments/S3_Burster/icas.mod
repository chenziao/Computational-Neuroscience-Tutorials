: Hyperpolarization-activated channel 

NEURON {
	SUFFIX cas
	USEION ca READ eca WRITE ica 
	RANGE gcasbar, gcas, icas
	RANGE uinf, utau
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	gcasbar = 0.055 (siemens/cm2) <0,1e9>
}

ASSIGNED {
	v (mV)
	eca (mV)
	ica (mA/cm2)
	uinf
	utau (ms)
	gcas (siemens/cm2)
	icas
}

STATE {
	u
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gcas = gcasbar*u*u*u
	ica = gcas*(v-eca)
	icas = ica
}

INITIAL {
	rate(v)
	u = uinf
}

DERIVATIVE states {
	rate(v)
	u' = (uinf-u)/utau
}

PROCEDURE rate(v(mV)) {
	UNITSOFF
	uinf = (1.0)/(1+ (exp (-(v+22)/(8.5))))         
	utau = ((16)-(13.1)/(1+(exp (-(v+25.1)/(26.4)))))      
 
	UNITSON	
}
