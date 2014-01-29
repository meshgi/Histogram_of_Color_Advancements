function d = dist_emd_hat ( h1 , h2 , q )

d = emd_hat_gd_metric_mex ( h1' , h2' , q , 0 , 1 );