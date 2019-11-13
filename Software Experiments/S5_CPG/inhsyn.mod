:Exitatory Synapse

NEURON {
	POINT_PROCESS inh
	NONSPECIFIC_CURRENT iinh
	RANGE w, tau
	RANGE gmax, einh, iinh
}

UNITS {
	(mV) = (millivolt)
    (nA) = (nanoamp)
	(uS) = (microsiemens)
}

PARAMETER {
	tau = 10 (ms)
	gmax = 40e-6 (uS)
}

ASSIGNED {
	w
	v (mV)
	iinh (nA)
	einh (mV)
	g (uS)
}

STATE {
	A
	B
}

INITIAL {
	A = 0
	B = 0
}

BREAKPOINT {
	SOLVE states METHOD cnexp
	g = gmax*A*B
	iinh = w*g*(v-einh)
}

DERIVATIVE states {
	A' = 1/tau
	B' = -B/tau
}

NET_RECEIVE(wgt) {
    LOCAL x
	x = wgt
	state_discontinuity(A,(A*B/(B+x*exp(1))))
	state_discontinuity(B,B+x*exp(1))
}