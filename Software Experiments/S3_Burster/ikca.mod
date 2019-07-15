:  iC   fast Ca2+/V-dependent K+ channel

NEURON {
	SUFFIX kca
	USEION k READ ek WRITE ik
	USEION cas READ casi VALENCE 2 
      RANGE ik, gk, gkcabar, ikca
}

UNITS {
      (mM) = (milli/liter)
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	gkcabar= 6.000	(mho/cm2)
}

ASSIGNED {
	v (mV)
	ek (mV)
	casi (mM)
	ik (mA/cm2)
	cinf 
	ctau (ms)
	gk (mho/cm2)
	ikca
}

STATE {
	c
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	gk = gkcabar*c*c*c*c       
	ik = gk*(v-ek)
	ikca = ik
}



INITIAL {
	rate(v,casi)
	c = cinf
}

DERIVATIVE states {
        rate(v,casi)
	c' = (cinf-c)/ctau
}

UNITSOFF


UNITSON

PROCEDURE rate(v (mV), casi (mM)) {
	UNITSOFF
	cinf = ((casi)/(casi + 0.030))*((1.0)/(1+ (exp (-(v+51)/(4)))))
	ctau = ((90.3)-(75.09)/(1+(exp (-(v+46)/(22.7)))))
	UNITSON
}
