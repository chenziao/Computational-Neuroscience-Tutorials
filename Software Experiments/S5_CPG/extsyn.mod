:Exitatory Synapse

NEURON {
	POINT_PROCESS ext
	NONSPECIFIC_CURRENT iext
	RANGE w, tau
	RANGE gmax, eext, iext
}

UNITS {
	(mV) = (millivolt)
    (nA) = (nanoamp)
	(uS) = (microsiemens)
}

PARAMETER {
	tau = 3 (ms)
	gmax = 80e-6 (uS)
}

ASSIGNED {
	w
	v (mV)
	iext (nA)
	eext (mV)
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
	iext = w*g*(v-eext)
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