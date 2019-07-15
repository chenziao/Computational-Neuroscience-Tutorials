:High-voltage activated Ca2+ channel

NEURON {
        SUFFIX cat
	USEION ca READ eca WRITE ica
	RANGE gcatbar, gca, icat
	RANGE uinf, zinf, utau, ztau 
}

UNITS {
        (mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	gcatbar = 0.0001 (mho/cm2) <0,1e9>
}

STATE { u z }

ASSIGNED {
	v (mV)
	eca (mV)
	ica (mA/cm2)
	uinf
	zinf 
	utau (ms)
	ztau (ms)
	gca (mho/cm2)
	icat
}

BREAKPOINT { 
	SOLVE states METHOD cnexp
	gca = gcatbar*u*u*u*z
	ica = gca*(v-eca)
	icat = ica
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
	uinf = 1.0/(1.0+(exp (-(v+25)/(7.2))))       
	utau = (55 - 49.5/(1.0+(exp (-(v+58)/(17)))))         

	zinf = 1.0/(1.0+(exp ((v+36)/(7))))       
	ztau = (87.5 - 75/(1.0+(exp (-(v+50)/(16.9)))))   
	UNITSON	
}
