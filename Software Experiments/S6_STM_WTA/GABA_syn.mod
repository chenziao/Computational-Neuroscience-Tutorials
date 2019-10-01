:Inhibitory GABA synapse

NEURON {
	POINT_PROCESS GABA
	USEION ca READ eca,ica
	NONSPECIFIC_CURRENT igaba
	RANGE taug1, taug2, factorg, normconstg
	RANGE ggaba, ggabas, gGABAmax, egaba
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
	:GABA Weight
	initW = 9

	:GABA
	taug1 = .5 (ms)
	taug2 = 7 (ms)
	gGABAmax = 1e-3 (uS)
	egaba = -60 (mV)
}

ASSIGNED {
	v (mV)
	eca (mV)
	ica (nA)

	:GABA
	igaba (nA)
	ggaba
	ggabas
	factorg
	normconstg
}

STATE {
	:GABA
	Ag
	Bg
}

INITIAL {

	:GABA
	Ag = 0
	Bg = 0
	factorg = taug1*taug2/(taug2-taug1)
	normconstg = -1/(factorg*(1/exp(log(taug2/taug1)/(taug1*(1/taug1-1/taug2)))-1/exp(log(taug2/taug1)/(taug2*(1/taug1-1/taug2)))))
}

BREAKPOINT {
	SOLVE states METHOD cnexp
}

DERIVATIVE states {
	:GABA
	Ag' = -Ag/taug1
	Bg' = -Bg/taug2
	ggaba = normconstg*factorg*(Bg-Ag)
	ggabas = ggaba
	if (ggabas > 40) {ggabas = 40}
	igaba = initW*gGABAmax*ggabas*(v-egaba)
}

NET_RECEIVE(wgt) {
        LOCAL x
	x = wgt
	state_discontinuity(Ag,Ag+x)
	state_discontinuity(Bg,Bg+x)
}
