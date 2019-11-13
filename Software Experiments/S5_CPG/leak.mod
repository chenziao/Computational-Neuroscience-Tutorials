: passive leak current

NEURON {
	SUFFIX leak
	NONSPECIFIC_CURRENT il
	RANGE il, el, gbar
}

UNITS {
	(mA) = (milliamp)
	(mV) = (millivolt)
}

PARAMETER {
	
}

ASSIGNED {
	v (mV)
	el (mV)
	gbar (siemens/cm2)
	il (mA/cm2)
}

BREAKPOINT { 
	il = gbar*(v - el)
}