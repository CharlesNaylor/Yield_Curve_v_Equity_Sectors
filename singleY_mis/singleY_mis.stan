// adapted from stan manual p182
data {
  int<lower=0> N; // total # of days
  int<lower=0> K; // total # of factors
  int<lower=0> N_mis[K]; // number of missing points for each factor
  
  // parameters for student_ts of missing factor data
  real param_mu[K];
  real<lower=0> param_nu[K];
  real<lower=0> param_sigma[K];
  
  vector[N-N_mis[1]] obs_early; // observed early factor
  vector[N-N_mis[2]] obs_mid; // observed mid factor
  vector[N-N_mis[3]] obs_late; // observed late factor
  real y[N]; // equity sector returns
}
parameters {
  vector[N_mis[1]] mis_early;
  vector[N_mis[2]] mis_mid;
  vector[N_mis[3]] mis_late;
  vector[K] beta; // OLS coefficients
  real<lower=0> sigma; // error term for y
}
transformed parameters {
  matrix[N,K] x;
  x[:N_mis[1],1] = mis_early;
  x[N_mis[1]+1:,1] = obs_early;
  x[:N_mis[2],2] = mis_mid;
  x[N_mis[2]+1:,2] = obs_mid;
  x[:N_mis[3],3] = mis_late;
  x[N_mis[3]+1:,3] = obs_late;
}
model {
  for(k in 1:K) {
    x[,k] ~ student_t(param_nu[k], param_mu[k], param_sigma[k]);
  }
  beta ~ normal(0, 0.1); 
  sigma ~ cauchy(0, 1);
  y ~ normal(x*beta, sigma);
}
