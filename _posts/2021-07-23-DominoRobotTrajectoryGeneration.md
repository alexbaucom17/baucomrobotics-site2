---
title: Domino Robot Trajectory Generation
date: 2021-07-23 12:30:00 -0700
categories: [Projects]
tags: [robotics, dominorobot]     # TAG names should always be lowercase
math: true
---


## Motivation

One of the core software components needed for the Domino Robot was a method of generating a trajectory for the robot to follow. As far as trajectory generation goes, this case was quite simple as the robot has omni-directional drive, only needs to move point to point, and doesn’t have to avoid obstacles. This means there are virtually no geometric constraints on the trajectory generation and the bulk of the work is just to create a smooth velocity profile. 

A relatively standard velocity profile is called a “trapezoidal profile” and uses three constant acceleration segments.

![](/assets/MyFirstComputerBuild/parts.jpg)
_Different regions of a trapezoidal profile._

While this is a very simple method, one of the downsides of it is that it requires infinite jerk at each of the points where the acceleration has an instantaneous jump. This can cause vibrations and jerks (as the name implies) which is not ideal for a robot which needs to smoothly start and stop with high precision near dominos. An alternative to a trapezoidal profile is an “s-curve” profile which, in the general case, consists of seven constant jerk segments which allow for much smoother transitions.

![](/assets/MyFirstComputerBuild/parts.jpg)
_Different regions of an s-curve velocity profile._

I opted to use an s-curve trajectory and implement my own version as the generalized equations are quite [complex](https://journals.sagepub.com/doi/full/10.5772/5652), primarily because they guarantee time optimality (which I didn’t need). In the end, using an s-curve over a trapezoidal profile was probably overkill, but it made for a great learning experience by figuring out the derivations myself and it did allow the robot to drive extremely smoothly.

## Iterative S-Curve Generation

The method I developed was an iterative method to compute an s-curve trajectory that is guaranteed to satisfy kinematic limits, but is not guaranteed to be time optimal. This method worked well for the Domino Robot because the computing power was limited, the trajectory generation did not have to adhere to strict time limits, and time optimality was not necessary.

### Derivation

Let the state vector $X(t)$ be

$$
\begin{equation}
X(t) = \begin{bmatrix} p(t) \\ v(t) \\ a(t) \\ j(t) \end{bmatrix}.
\end{equation}
$$

Let an S-curve trajectory be defined as a set of polynomials 

$$
\begin{equation}
\begin{align} a(t) =& a_0 + j(t)t \nonumber \\  v(t) =& v_0 + a_0t + \frac{1}{2}j(t)t^2 \\ p(t) =& p_0 + v_0t + \frac{1}{2}a_0t^2 + \frac{1}{6}j(t)t^3 \nonumber \end{align}
\label{eqn:scurve}
\end{equation}
$$

where the jerk, $j(t)$, is the control input for the trajectory and follows the structure
$$
\begin{equation}
j(t) = \begin{cases}  j_{lim}, &\text{if $t_0 < t < t_1$} \\ 0, &\text{if $t_1< t < t_2$} \\ -j_{lim}, &\text{if $t_2< t < t_3$} \\ 0, &\text{if $t_3< t < t_4$} \\ -j_{lim}, &\text{if $t_4< t < t_5$} \\ 0, &\text{if $t_5< t < t_6$} \\  j_{lim}, &\text{if $t_6< t < t_7$} \end{cases}
\end{equation}
$$

where $$t_{0...7}$$ are the 'switch times' of the trajectory and $$j_{lim}$$ is a constant.

Given an initial state at $t=0$

$$
\begin{equation}
X(0) = \begin{bmatrix} 0 \\ 0 \\ 0 \\ 0 \end{bmatrix} 
\end{equation}
$$

and a final state at $t=t_7$

$$
\begin{equation}
X(t_7) = \begin{bmatrix} P_f \\ 0 \\ 0 \\ 0 \end{bmatrix},
\end{equation}
$$

solve for $j_{lim}$ and $t_{0...7}$ subject to dynamic limits,

$$
\begin{equation}
\begin{align} j(t) \leq& J_{max} \\ a(t) \leq& A_{max} \\ v(t) \leq& V_{max}. \end{align}
\end{equation}
$$

Let $j_{lim} = J_{max}$ for the regions of constant jerk. Let $a_{lim} = A_{max}$ and $v_{lim} = V_{max}$ be the acceleration and velocity limits of the solution, respectively.  Then, the time spent in the constant jerk region, $\Delta t_j$, can be found by computing how long it takes to reach the maximum acceleration while commanding the maximum jerk:

$$
\begin{equation} \label{eqn:dtj} \Delta t_j = t_1-t_0=t_3-t_2=t_5-t_4=t_7-t_6=\frac{a_{lim}}{j_{lim}} \end{equation}
$$

and, by substituting into \eqref{eq:scurve},

$$
\begin{equation}
\begin{align}  \Delta a_j =& j_{lim}\Delta t_j \\ \Delta v_j =& a(t_i)\Delta t_j + \frac{1}{2}j_{lim}{\Delta t_j}^2 \\ \Delta p_j =& v(t_i)\Delta t_j + \frac{1}{2}a(t_i){\Delta t_j}^2 + \frac{1}{6}j_{lim}{\Delta t_j}^3. \end{align}
\end{equation}
$$

In the regions of constant acceleration, the time, $\Delta t_a$, can be found by computing how much time it takes to reach the maximum velocity while accelerating at a constant rate. Note that the change in velocity from the constant jerk regions (both positive and negative jerk) must be accounted for. This gives

$$
\begin{equation} 
\Delta t_a = t_2-t_1=t_6-t_5=\frac{v_{lim} - 2\Delta v_j}{a_{lim}}
\label{eqn:dta}
\end{equation}
$$

and, by substituting into \eqref{eq:scurve},

$$
\begin{equation} 
\begin{align}  \Delta v_a =& a_{lim}\Delta t_a \\ \Delta p_a =& v(t_i)\Delta t_a + \frac{1}{2}a_{lim}{\Delta t_a}^2 \end{align}
\end{equation}
$$

Finally, the constant velocity region can be used to compute the time. $\Delta t_v$, by determining how long the robot must stay at the constant velocity to reach the target position, while accounting for the change in position due to the constant jerk (both positive and negative) and acceleration regions.

$$
\begin{equation} \Delta t_v = t_4-t_3=\frac{P_f - 2\Delta p_{j+} - 2\Delta p_{j-} - 2\Delta p_a}{v_{lim}} 
\label{eqn:dtv}
\end{equation}
$$

and, by substituting into \eqref{eq:scurve},

$$
\begin{equation}
\begin{align} \Delta p_v =& v_{lim}\Delta t_v. \end{align}
\end{equation}
$$

Observe that in \eqref{eq:dtj}, $\Delta t_j$ will always be positive for positive values of $a_{lim}$ and $j_{lim}$. However, it may not be feasible to solve \eqref{eq:dta} or \eqref{eq:dtv} for positive values of $\Delta t_a$ or $\Delta t_v$, depending on the limits $a_{lim}$ and $v_{lim}$ as well as the final position $P_f$. For example, a negative value of $\Delta t_a$ would mean that the change in velocity during both constant jerk phases $t_0 \rightarrow t_1$ and $t_2 \rightarrow t_3$ is larger than the velocity limit. How can this be fixed? The velocity limit, $v_{lim}$ cannot be increased, as that would violate the problem requirements of $v(t) \leq V_{max}$, but the max acceleration could be reduced to something less than $a_{lim}$ until a solution is found. This iterative limit adjustment is the crux of this trajectory generation algorithm.

If $\Delta t_a$ is negative and therefore no valid solution can be found, $a_{lim}$ can be reduced according to

$$
\begin{equation}
a_{lim} = a_{lim} \beta ^ {1+\gamma N}
\end{equation}
$$

where $\beta$ and $\gamma$ are decay parameters in the range $[0, 1]$ and $N$ is a counter indicating how many iterations have passed. The solution can then be attempted again with the adjusted value of $a_{lim}$.

It is possible for $\Delta t_a$ to have a valid solution, but for $\Delta t_v$ to be negative and therefore invalid. In this situation, a similar adjustment can be applied to $v_{lim}$

$$
\begin{equation}
v_{lim} = v_{lim} \alpha ^ {1+\gamma N}
\end{equation}
$$

where $\alpha$ is also a decay parameter in the range $[0, 1]$. If both $\Delta t_a$ and $\Delta t_v$ have valid, positive solutions then that means it is possible to solve for a feasible set of switch times $t_{0...7}$ subject to the dynamic limits:

$$
\begin{equation}
\begin{align} t_0 =& 0 \nonumber \\  t_1 =& \Delta t_j \nonumber \\ t_2 =& \Delta t_j + \Delta t_a \nonumber \\  t_3 =& 2\Delta t_j + \Delta t_a \\ t_4 =& 2\Delta t_j + \Delta t_a + \Delta t_v \nonumber \\  t_5 =& 3\Delta t_j + \Delta t_a + \Delta t_v \nonumber \\ t_6 =& 3\Delta t_j + 2\Delta t_a + \Delta t_v \nonumber \\ t_7 =& 4\Delta t_j + 2\Delta t_a + \Delta t_v. \nonumber \end{align}
\end{equation}
$$

## Algorithm

Given the results of the derivation above, this iterative s-curve generation can be implemented according to the following algorithm:

```c++
bool generateSCurve(float dist, 
                    const DynamicLimits& limits, 
                    const SolverParameters& solver, 
                    SCurveParameters* params)
{
    bool solution_found = false;
    // If distance to move is tiny, trajectory is all zeros.
    if (fabs(dist) < solver.min_dist)
    {
        setAllParamsToZero(params);
        solution_found = true;
        return solution_found;
    }

    // Initialize limits to max
    float v_lim = limits.max_vel;
    float a_lim = limits.max_acc;
    float j_lim = limits.max_jerk;

    // Start search loop
    int loop_counter = 0;
    constexpr float d6 = 1/6.0;
    while(!solution_found && loop_counter < solver.num_loops)
    {
        loop_counter++;

        // Constant jerk region
        float dt_j = a_lim / j_lim;
        float dv_j = 0.5 * j_lim * std::pow(dt_j, 2);
        float dp_j1 = d6 * j_lim * std::pow(dt_j, 3);
        float dp_j2 = (v_lim - dv_j) * dt_j + 0.5 * a_lim * std::pow(dt_j, 2) - d6 * j_lim * std::pow(dt_j, 3);

        // Constant accel region
        float dt_a = (v_lim - 2 * dv_j) / a_lim;
        if (dt_a <= 0)
        {
            // If dt_a is negative, it means we couldn't find a solution
            // so adjust accel parameter and try loop again
            a_lim *= std::pow(solver.beta_decay, 1 + solver.exponent_decay * loop_counter);
            continue;
        }
        float dp_a = dv_j * dt_a + 0.5 * a_lim * std::pow(dt_a, 2);

        // Constant velocity region
        float dt_v = (dist - 2 * dp_j1 - 2 * dp_j2 - 2 * dp_a) / v_lim;
        if (dt_v <= 0)
        {
            // If dt_v is negative, it means we couldn't find a solution
            // so adjust velocity parameter and try loop again
            v_lim *= std::pow(solver.alpha_decay, 1 + solver.exponent_decay * loop_counter);
            continue;
        }

        // If we get here, it means we found a valid solution and can populate the rest of the 
        // switch time parameters
        solution_found = true;
        populateSolutionParameters(params, v_lim, a_lim, j_lim, dt_j, dt_a, dt_v);
    }

    return solution_found;
}
```

## Using the S-Curve in Trajectory Generation

Using the algorithm above to generate S-curve trajectories in 1-D, I was able to create a trajectory generator that worked in 3 dimensions (x, y, and angle) using the nice properties of the omni-directional robot and the fact that the system only needed to move point to point without obstacle avoidance.

This was simply a matter of defining a “trajectory” as a combination of two “sub-trajectories”, one for the planer motion and one for the angular motion where each consisted of a ‘direction’ and ‘speed’. Using the current position of the robot when generating the trajectory, I used the Euclidian distance to the target point for translation and simple subtraction for the angle (don’t forget to wrap!) as the Pf

 for each of the sub-trajectories respectively. The S-curves for translation and rotation were then each solved independently to create the full trajectory. Solving each of these S-curves independently means that the translational and rotational movements take different amounts of times to complete, but this isn’t technically a problem for an omni-directional robot. However, I liked the look of the driving with the trajectories synchronized, so I added an extra step to do this synchronization (details in the next section).

The last step was to add a simple lookup function that could take in a time relative to the start of the trajectory and produce a target position and velocity.  Using the s-curve polynomial definition and the limits and switch times which were solved for originally, this is quite straightforward. The only extra step is to modify the values for the translation section to use the vector direction to get both x and y.

### Trajectory Synchronization

I achieved trajectory synchronization across both the translational and rotational motions by slowing down the faster motion to match the total time of the slower motion. I could have tried to do this by matching the switch times between the two trajectories, but this wouldn’t be guaranteed to always result in a feasible solution. Instead, I simply increased the switch time of each step in the faster trajectory by $\frac{1}{7}(T_{final,slow}−T_{final,fast})$

 which results in the same total time for both trajectories and guarantees that all regions of the faster trajectory will be strictly slower than before. This ensures that a solution which respects the maximum kinematic values can be found.

Finally, the new vlim
, alim, and jlim can be found by solving the inverse of the problem derived above. Using equations 9, 13, and 16

 above performing some substitution and re-arranging, the following linear system can be found:

⎡⎣⎢⎢dtjdt2jdt2j(dta−dtj)−1dtadt2j+dt2a0−1dtv+2dtj⎤⎦⎥⎥⎡⎣⎢jlimalimvlim⎤⎦⎥=⎡⎣⎢00Pf⎤⎦⎥.(21)

Since the switch times, and thus dtj
, dta, and dtv

, are known, the linear system can be solved easily by any linear algebra library to find the new limits which provide a synchronized motion.
Results

As I mentioned before, this level of smoothing was probably overkill in the end, but it did produce some very nice results. If you are interested in exploring further, the code can be found in the SmoothTrajectoryGenerator class of the Domino Robot source code.

Smooth trajectory generation in action (click to enlarge).

Smooth trajectory generation using the same initial limits as the previous plot, but solving for a much smaller total distance (click to enlarge)

Smooth trajectory generation using the same initial limits as the previous plots, but solving for a much longer total distance (click to enlarge).
An example of an unsynchronized trajectory where the translation finishes prior to the rotation.

An example of an unsynchronized trajectory where the translation finishes prior to the rotation.
An example of a synchronized trajectory where both the translation and rotation finish at the same time.

An example of a synchronized trajectory where both the translation and rotation finish at the same time.
