: potassium channel

NEURON {
	SUFFIX k
	USEION k READ ek WRITE ik
	RANGE gbar
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	nalphaA = -0.01 (1/ms-mV)
	nalphaB = -10 (mV)
	nalphaV0 = -60 (mV)

	nbetaA = .125 (1/ms)
	nbetaB = -80 (mV)
	nbetaV0 = -70 (mV)
}

ASSIGNED {
	v (mV)
	ko (mM)
	ki (mM)
	ek (mV)
	ik (mA/cm2)
	nalpha (1/ms)
	nbeta (1/ms)
	ninf
	ntau (ms)
	g (siemens/cm2)
	gbar (siemens/cm2)
}

STATE {
	n
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gbar*n*n*n*n
	ik = g*(v-ek)
}

INITIAL {
	rate(v)
	n = ninf
}

DERIVATIVE states {
	rate(v)
	n' = (ninf-n)/ntau
}

PROCEDURE rate(v (mV)) {
	LOCAL va
	va = v-nalphaV0
	if (fabs(va)<1e-06){
	   	va = va+(1e-06)
	}
	nalpha = nalphaA*va/(exp(va/nalphaB)-1)
	nbeta = nbetaA*exp((v-nbetaV0)/nbetaB)
	
	ninf = nalpha/(nalpha+nbeta)
	ntau = 1/(nalpha+nbeta)
}

