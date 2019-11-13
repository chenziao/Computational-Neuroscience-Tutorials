: transient sodium channel

NEURON {
	SUFFIX na
	USEION na READ ena WRITE ina
	RANGE gbar
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	malphaA = -0.1 (1/ms-mV)
	malphaB = -10 (mV)
	malphaV0 = -45 (mV)
	
	mbetaA = 4 (1/ms)
	mbetaB = -18 (mV)
	mbetaV0 = -70 (mV)
	
	halphaA = 0.07 (1/ms)
	halphaB = -20 (mV)
	halphaV0 = -70 (mV)
	
	hbetaA = 1 (1/ms)
	hbetaB = -10 (mV)
	hbetaV0 = -40 (mV)
}

ASSIGNED {
	v (mV)
	ena (mV)
	ina (mA/cm2)
	malpha (1/ms)
	mbeta (1/ms)
	halpha (1/ms)
	hbeta (1/ms)
	minf
	hinf
	mtau (ms)
	htau (ms)
	g (siemens/cm2)
	gbar (siemens/cm2)
}

STATE {
	m h
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gbar*m*m*m*h
	ina = g*(v-ena)
}

INITIAL {
	rate(v)
	m = minf
	h = hinf
}

DERIVATIVE states {
	rate(v)
	m' = (minf-m)/mtau
	h' = (hinf-h)/htau
}

PROCEDURE rate(v (mV)) {
	LOCAL va
	va = v-malphaV0
	if (fabs(va)<1e-04){
	   	va = va+(1e-04)
	}
	
	malpha = malphaA*va/(exp(va/malphaB)-1)
	mbeta = mbetaA*exp((v-mbetaV0)/mbetaB)
	
	halpha = halphaA*exp((v-halphaV0)/halphaB)
	hbeta = hbetaA/(exp((v-hbetaV0)/hbetaB)+1) 
	
	minf = malpha/(malpha+mbeta)
	mtau = 1/(malpha+mbeta)
	
	hinf = halpha/(halpha+hbeta)
	htau = 1/(halpha+hbeta)
}