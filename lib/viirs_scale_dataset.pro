; docformat = 'rst'
;+
; A helper routine to apply scale factors from a VIIRS dataset to the data.
; 
; :params:
;  data: in, required, type=float
;   A dataset read from a VIIRS file. 
;  factors: in, required, type=float
;   The scale factors associated with the data.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_scale_dataset, data, factors
   compile_opt idl2

   return, data*factors[0] + factors[1]   
end

; Example
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
path = '/All_Data/VIIRS-I1-IMG-EDR_All/'
dataset = path + 'Reflectance'
factors = path + 'ReflectanceFactors'
i1_reflectance = viirs_read_dataset(f, dataset)
i1_reflectance_factors = viirs_read_dataset(f, factors)
i1_reflectance = viirs_scale_dataset(i1_reflectance, i1_reflectance_factors)
help, i1_reflectance
print, min(i1_reflectance), max(i1_reflectance)
end
