; docformat = 'rst'
;+
; Reads a single HDF5 dataset from a Suomi NPP VIIRS file given its full path.
;
; :params:
;  viirs_file: in, required, type=string
;     The path to a VIIRS I-Band file.
;  dataset: in, required, type=string
;     The full path to an HDF5 dataset in a VIIRS I-Band file.
;
; :keywords:
;  reverse: in, optional, type=boolean
;     Set this keyword to flip the imagery about a vertical axis.
;  silent: in, optional, type=boolean
;     Set this keyword to turn off informational messages.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_read_dataset, viirs_file, dataset, $
      reverse=reverse, $
      silent=silent
   compile_opt idl2
   on_error, 2
   
   if n_params() ne 2 then $
      message, 'Need paths to file and VIIRS dataset.'
   
   if ~keyword_set(silent) then print, 'Reading: ' + dataset
   file_id = h5f_open(viirs_file)
   dataset_id = h5d_open(file_id, dataset)
   data = h5d_read(dataset_id)
   h5d_close, dataset_id
   h5f_close, file_id
   
   ; Flip about vertical axis; handy to display pixels without geolocation.
   if keyword_set(reverse) then data = reverse(data) 
   
   return, data
end

; Example
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
dataset = '/All_Data/VIIRS-IMG-GTM-EDR-GEO_All/Longitude'
longitude = viirs_read_dataset(f, dataset)
help, longitude
end
