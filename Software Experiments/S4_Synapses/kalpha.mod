: spike-generating sodium channel (Pyramid)

NEURON {
	SUFFIX kalpha
	USEION k READ ek WRITE ik
	RANGE gkbar, gk
	RANGE ninf, ntau
	RANGE alphaan,alphabn,alphacn,alphadn,alphafn
	RANGE betaan,betabn,betacn,betadn,betafn	
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	gkbar = 0.036 (siemens/cm2) <0,1e9>
	
	alphaan = -0.6
	alphabn = -0.01
	alphacn = -1
	alphadn = 60
	alphafn = -10
	betaan = 0.125
	betabn = 0
	betacn = 0
	betadn = 70
	betafn = 80
	
}

ASSIGNED {
	v (mV)
	ek (mV)
	ik (mA/cm2)
	ninf
	ntau (ms)
	gk (siemens/cm2)
}

STATE {
	n
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gk = gkbar*n*n*n*n
	ik = gk*(v-ek)
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
	LOCAL na, nb
	UNITSOFF

	na = (alphaan + alphabn*v)/(alphacn + exp((alphadn+v)/alphafn))
	nb = (betaan + betabn*v)/(betacn + exp((betadn+v)/betafn))
	
	ninf = na/(na+nb)
	ntau = 1/(na+nb)

	UNITSON
}

