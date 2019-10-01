# N-point-Hedging-Rule

A platform has been developed to find the optimal coordinates of n-point hedging rule for an agricultural reservoir using the genetic algorithm (GA). This platform written in MATLAB can be modified for any agricultural reservoir considering different objective function. The Hyrum Reservoir as the agricultural reservoir in the Bear River system is considered as the case study and the platform is executed for different values for n-point (1, 5, 10, 20, and 40) under minimizing the vulnerability indicator. In addition, the values for vulnerability achieved by the GA are compared to the standard linear operation policy (SLOP). Results indicated that there are no differences between the optimal n-point hedging rule found by GA and the SLOP in terms of vulnerability. After analyzing the results, the author found that the water availability is more than the amount of demand related to the demand sites of the Hyrum reservoir in all period of the operation. In other words, there is a spill from the reservoir for all the period of operation. That’s why the vulnerability for all n-point hedging rule achieved by the GA is similar to the vulnerability calculated based on the SLOP. Therefore, it is recommended that the operators of the Hyrum reservoir keep using the SLOP until there is a development in the agricultural field that leads to increasing the amount of the demand. In developing situation, they can run the platform to achieve the optimal n-point hedging rule in terms of minimizing the vulnerability or even other objective functions.

## Hedging Rule in the Reservoir System

The importance and the rule of hedging rule policy are discussed and shown in the reservoir operation system section and Fig 3. Recall that the simplest form that links AW to RV is SLOP described in the introduction section and Fig 1. Although SLOP is based on releases to stratify demands in each period as much as there is water in the reservoir storage, when there is no sufficient water ($S_t<Demand_t$) in the reservoir storage, all the water storage should be released which means that the reservoir will be empty in the next period. That’s why SLOP doesn’t preserve water for the future requirements and system faces a big failure to meet the demand in the next periods. To cope this issue, some researchers use the non-linear forms of hedging rule and evaluate it using performance indicators. Others try to find the optimal values of both 45o slopes and the threshold of the spill. Moreover, there is another approach to modifying SLOP using breaking the lines (AB, BC, and CD in Fig 2) into more lines with different slopes called n-point hedging rule. Regardless of these approaches to modify the hedging rule, usually, the modification of the hedging rule is considered under a specific objective function (convert to an optimization problem). The objective function can be an improvement in the performance criteria such as reliability, resiliency or vulnerability or even minimizing the deficit.

| ![A layout of SLOP \label{fig:1}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig1.jpg) | 
|:--:| 
| *Fig 1. A layout of SLOP* |

| ![A layout of two-point hedging rule \label{fig:2}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig2.jpg) | 
|:--:| 
| *Fig 2. A layout of two-point hedging rule* |

| ![The simulation process of an agricultural reservoir operation \label{fig:3}](https://github.com/Mahyarona/N-point-Hedging-Rule/blob/master/Fig3.jpg) | 
|:--:| 
| *Fig 3. The simulation process of an agricultural reservoir operation* |
## Performance Criteria of the Reservoir System

To evaluate the performance of a water resources system, it is necessary to develop and use indices. The most famous indices have been introduced by Hashimoto et al. (1982) and developed by many researchers (Loucks et al. 1981 and Sandoval-Solis et al. 2011). The Hashimoto's risk-based indicators are reliability, vulnerability, and resiliency that quantify the frequency, size, and length of the system failures, respectively. The sustainability is another index that shows the efficiency of the system calculated based on reliability, vulnerability, and resiliency. According to demerit feature of SLOP (poor performance regarding the vulnerability), the vulnerability indicator is considered as the objective function in GA to find the optimal coordinate for n-point hedging rule and its formulations is as follows:


![Eq.1 \label{Eq:1}](http://bit.ly/2ollqxf) <br />
![Eq.1 \label{Eq:1}](http://bit.ly/2nATp4P) <br />


in which T= number of operating periods; $Demand_t$=the demand at operation period ; $V_n$= vulnerability index; $Def_t$ = volume of deficit in period t; $V_{nscaled}$ = scaled vulnerability index; $Deamnd_{tmax}$ = the demand at the period that maximum deficit happens ($t_max$).
