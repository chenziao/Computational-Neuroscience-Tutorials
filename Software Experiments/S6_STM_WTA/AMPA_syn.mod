:Excitatory AMPA synapse

NEURON {
	POINT_PROCESS AMPA
	USEION ca READ eca,ica
	NONSPECIFIC_CURRENT iampa
	RANGE taug1, taug2, factorg, normconstg
	RANGE gampa, gampas, gAMPAmax, eampa
	RANGE icag, P0g, fcag
	RANGE Afactor, pooldiam, z
	RANGE lambda1, lambda2, threshold1, threshold2
	RANGE k, cainf, eca, taucag, icatotal
	RANGE initW
}

UNITS {
	(mV) = (millivolt)
        (nA) = (nanoamp)
	(uS) = (microsiemens)
	FARADAY = 96485 (coul)
	pi = 3.141592 (1)
}

PARAMETER {
	:AMPA Weight
	initW = 2.1

	:AMPA
	taug1 = .5 (ms)
	taug2 = 7 (ms)
	gAMPAmax = 1e-3 (uS)
	eampa = 0 (mV)
}

ASSIGNED {
	v (mV)
	eca (mV)
	ica (nA)

	:AMPA
	iampa (nA)
	gampa
	gampas
	factorg
	normconstg
}

STATE {
	:AMPA
	Ag
	Bg
}

INITIAL {

	:AMPA
	Ag = 0
	Bg = 0
	factorg = taug1*taug2/(taug2-taug1)
	normconstg = -1/(factorg*(1/exp(log(taug2/taug1)/(taug1*(1/taug1-1/taug2)))-1/exp(log(taug2/taug1)/(taug2*(1/taug1-1/taug2)))))
}

BREAKPOINT {
	SOLVE states METHOD cnexp
}

DERIVATIVE states {
	:AMPA
	Ag' = -Ag/taug1
	Bg' = -Bg/taug2
	gampa = normconstg*factorg*(Bg-Ag)
	gampas = gampa
	if (gampas > 40) {gampas = 40}
	iampa = initW*gAMPAmax*gampas*(v-eampa)
}

NET_RECEIVE(wgt) {
        LOCAL x
	x = wgt
	state_discontinuity(Ag,Ag+x)
	state_discontinuity(Bg,Bg+x)
}
