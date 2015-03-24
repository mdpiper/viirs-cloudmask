; docformat = 'rst'
;+
; Builds the cloud mask. For a pixel to be considered cloudy, it must pass
; all tests. The mask is returned as a byte array.
;
; :params:
;  data: in, required, type=structure
;   A structure of I-band data returned from VIIRS_INGEST_IBAND_FILE. 
;
; :keywords:
;  report: in, optional, type=boolean
;   Set this keyword to generate status updates in ENVI. If this keyword isn't
;   set, this routine works in pure IDL.
;
; :uses:
;  VIIRS_CLOUDMASK_FILTER1, VIIRS_CLOUDMASK_FILTER2, 
;  VIIRS_CLOUDMASK_FILTER3, VIIRS_CLOUDMASK_FILTER4,
;  VIIRS_CLOUDMASK_FILTER5, VIIRS_CLOUDMASK_FILTER6
;  VIIRS_CLOUDMASK_FILTER7
;
; :requires:
;  ENVI 5
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_build_cloudmask, data, report=report
   compile_opt idl2
   
   if keyword_set(report) then begin
      e = envi(/current)
      str = 'Building Cloud Mask'
      envi_report_init, str, base=base, title='Building VIIRS I-Band Cloud Mask'
      n_steps = 7
      envi_report_inc, base, n_steps
      istep = 0
   endif
   
   f1 = viirs_cloudmask_filter1(data.i1)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f2 = viirs_cloudmask_filter2(data.i1, data.i2, data.i3)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f3 = viirs_cloudmask_filter3(data.i5)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f4 = viirs_cloudmask_filter4(data.i3, data.i5)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f5 = viirs_cloudmask_filter5(data.i1, data.i2)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f6 = viirs_cloudmask_filter6(data.i1) ; empty
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   f7 = viirs_cloudmask_filter7(data.i2, data.i3)
   if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
   
   if keyword_set(report) then envi_report_init, base=base, /finish
   
   return, f1 and f2 and f3 and f4 and f5 and f6 and f7
end

; Example (assuming data in IDL path)
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
iband_data = viirs_ingest_iband_file(f)
vibcm = viirs_build_cloudmask(iband_data)
end
