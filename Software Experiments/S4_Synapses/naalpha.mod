: spike-generating sodium channel (Pyramid)

NEURON {
	SUFFIX naalpha
	USEION na READ ena WRITE ina
	RANGE gnabar, gna
	RANGE minf, hinf, mtau, htau
	RANGE alphaam,alphabm,alphacm,alphadm,alphafm
	RANGE alphaah,alphabh,alphach,alphadh,alphafh
	RANGE betaam,betabm,betacm,betadm,betafm	
	RANGE betaah,betabh,betach,betadh,betafh
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)

}

PARAMETER {
	gnabar = 0.12 (siemens/cm2) <0,1e9>
	
	alphaam = -4.5
	alphabm = -0.1
	alphacm = -1
	alphadm = 45
	alphafm = -10
	betaam = 4
	betabm = 0
	betacm = 0
	betadm = 70
	betafm = 18
	
	alphaah = 0.07
	alphabh = 0
	alphach = 0
	alphadh = 70
	alphafh = 20
	betaah = 1
	betabh = 0
	betach = 1
	betadh = 40
	betafh = -10

}

ASSIGNED {
	v (mV)
	ena (mV)
	ina (mA/cm2)
	minf
	hinf
	mtau (ms)
	htau (ms)
	gna (siemens/cm2)
}

STATE {
	m h
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gna = gnabar*m*m*m*h
	ina = gna*(v-ena)
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
	LOCAL ma, mb, ha, hb
	UNITSOFF

	ma = (alphaam + alphabm*v)/(alphacm + exp((alphadm+v)/alphafm))
	mb = (betaam + betabm*v)/(betacm + exp((betadm+v)/betafm))

	ha = (alphaah + alphabh*v)/(alphach + exp((alphadh+v)/alphafh))
	hb = (betaah + betabh*v)/(betach + exp((betadh+v)/betafh))


	minf = ma/(ma+mb)
	mtau = 1/(ma+mb)
	
	hinf = ha/(ha+hb)
	htau = 1/(ha+hb)

	UNITSON
}
