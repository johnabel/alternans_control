""" authors: john abel, amene asgari targhi
code for the CRN2 model in python
"""
from __future__ import division
import numpy as np
from scipy.integrate import odeint
import matplotlib.pyplot as plt

# set up Con[stants (Con[) (?) and initial state values (St) (?)
# note that indexing corresponds to matlab indexing, i.e. starts at 1, so
# zero-index values are set to 0.
# these are taken directly from CRN2.m
St = np.array([  0.00000000e+000,  -1.00000000e+001,   1.11700000e+001,
         2.90800000e-003,   9.64900000e-001,   9.77500000e-001,
         1.39000000e+002,   3.04300000e-002,   9.99200000e-001,
         4.96600000e-003,   9.98600000e-001,   3.29600000e-005,
         1.86900000e-002,   1.01300000e-006,   1.36700000e-004,
         9.99600000e-001,   7.75500000e-001,   1.48800000e+000,
         2.35000000e-112,   1.00000000e+000,   9.99200000e-001,
         1.48800000e+000])
Con = np.array([  0.00000000e+00,   8.31430000e+00,   3.10000000e+02,
         9.64867000e+01,   1.00000000e+02,   5.00000000e+01,
         5.00000000e+04,   1.00000000e+03,   2.00000000e+00,
         0.00000000e+00,   7.80000000e+00,   1.40000000e+02,
         9.00000000e-02,   5.40000000e+00,   3.00000000e+00,
         1.65200000e-01,   2.94117650e-02,   1.29411760e-01,
         1.23750000e-01,   1.00000000e+01,   1.50000000e+00,
         5.99338740e-01,   6.74437500e-04,   1.13100000e-03,
         0.00000000e+00,   1.80000000e+00,   1.60000000e+03,
         8.75000000e+01,   1.38000000e+00,   1.00000000e-01,
         3.50000000e-01,   2.75000000e-01,   3.00000000e+01,
         1.80000000e+02,   5.00000000e-03,   9.20000000e-04,
         1.50000000e+01,   5.00000000e-02,   7.00000000e-02,
         1.00000000e+01,   2.38000000e-03,   5.00000000e-04,
         8.00000000e-01,   2.01000000e+04,   1.36680000e+04,
         2.00000000e+00,   1.00091030e+00,   8.00000000e+00,
         9.64800000e+01,   1.10952000e+03])

# i think this is up through line 328


# from here, I was not sure as to how the CRN2 is actually modeled. So I'm
# leaving these defined in case we need them.

# now, I'm working in section 6.3 to create the CRN2 model from the eqns
# that you gave in your dissertation

y0 = np.array([Estim, 1]) # initial condition, 6.3e

def dCRN2(y, t):
    """The CRN2 system as prepared for scipy.integrate.odeint.
    Equations are taken from
    ==========
    Takes:
    y : np.ndarray of length 2
        This is the current state of the system (E,f)
    t : float
        This is the time. integrate.odeint reuires this variable here.
    """
    # take in the current values
    E, f = y

    # define functions used within system.
    # E0 and f0 are the variables E and f but only within the
    # scope of I1, I2, fbar, tau_f
    def I1(E0): #6.3b
        return

    def I2(E0,f0): #6.3b
        return

    def fbar(E0): #6.3d
        return (1+np.exp((E0+28)/6.9))**-1

    def tau_f(E0): #6.3d
        return 9.*(0.0197*np.exp((−0.03372**2)*(E0 +10)**2) +0.02)**−1

    # all the component voltage definitions from eq 6.3b
    def I_K1(E0, Ki0):
        return
    def I_to(E0,oa,oi,Ki0):
        return
    def I_Kur(E0,ua,ui,Ki0):
        return
    def I_Kr(E0,Ki0,xr_bar):
        return
    def I_Ks(E0,Ki0,xs_bar):
        return
    def I_NaK(E0,Nai0):
        return
    def I_bNa(E0,Nai0):
        return
    def I_NaCa(E0,Nai0,Cai0):
        return
    def I_bCa(E0,Cai0):
        return
    def I_CaL(E0,f0,d_bar,f_Ca_bar,):
        return

    # actually do the calculation
    dEdt = (I1(E)+I2(E,f))/C_M # eq 6.3a
    dfdt = (fbar(E)-f)/tau_f(E) # eq 6.3c
    dy = np.array([dEdt,dfdt]) # return the derivatives
    return dy

# do the integration
E,f = odeint(dCRN2, y0, np.linspace(0,10,1001))








