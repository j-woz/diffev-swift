
## M4 stuff:
changecom(`dnl')
# We use changecom to change the M4 comment from hash to `dnl'
# dnl Define a convenience macro
define(`getenv', `esyscmd(printf -- "$`$1' ")')
# Created: esyscmd(`date "+%m/%d/%Y %I:%M%p"')

pop_gen[1]  =   0
#
pop_n[1]    =  21
pop_c[1]    =  getenv(POP_C)
pop_dimx[1] =   3
#
# order parameter [100]
#
pop_name    1,a100
type real,1
pop_xmin[1] =    -0.333333
pop_xmax[1] =     1.000
pop_smin[1] =    -0.333333
pop_smax[1] =     1.00000
pop_sig[1]  =     0.100
pop_lsig[1] =     0.0100
adapt   sigma,  1,0.2
adapt   lsig ,  1,0.02
#
# order parameter [110]
#
pop_name    2,a110
type real,2
pop_xmin[2] =    -0.333333
pop_xmax[2] =     1.000
pop_smin[2] =    -0.333333
pop_smax[2] =     1.00000
pop_sig[2]  =     0.100
pop_lsig[2] =     0.0100
adapt   sigma,  2,0.2
adapt   lsig ,  2,0.02
#
# Atomic displacement parameter
#
pop_name    3,adp
type real,3
pop_xmin[3] =     0.000000
pop_xmax[3] =     2.000
pop_smin[3] =     0.000000
pop_smax[3] =     0.80000
pop_sig[3]  =     0.100
pop_lsig[3] =     0.0100
adapt   sigma,  3,0.2
adapt   lsig ,  3,0.02
#
diff_cr[1]  = 0.9
diff_f[1]   = 0.81
diff_lo[1]  = 0.0
diff_k[1]   = 1.0
#
refine      none
refine      1,2,3
#
donor      random
#selection  compare
selection  best,all
#
trialfile  DIFFEV/Trials
restrial   DIFFEV/Results
logfile    DIFFEV/Parameter
summary    DIFFEV/Summary
#