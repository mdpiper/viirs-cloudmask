; docformat = 'rst'
;+
; Reads the datasets and geocoords from a VIIRS Imagery EDR (I-Band) file, 
; applies scale factors, and removes granule gaps. The datasets and geocoords 
; are returned as a structure variable.
;
; :params:
;  viirs_file: in, required, type=string
;   The path to a VIIRS I-Band file.
;   
; :keywords:
;  report: in, optional, type=boolean
;   Set this keyword to generate status updates in ENVI. If this keyword isn't
;   set, this routine works in pure IDL.
;  
; :uses:
;  VIIRS_READ_DATASET, VIIRS_SCALE_DATASET,
;  VIIRS_LOCATE_GRANULE_GAPS, VIIRS_REMOVE_GRANULE_GAPS
;
; :requires:
;  ENVI 5
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_ingest_iband_file, viirs_file, report=report
   compile_opt idl2

   if keyword_set(report) then begin
      e = envi(/current)
      str = ['Input File : ', viirs_file]
      envi_report_init, str, base=base, title='Reading VIIRS I-Band EDR'
      n_steps = 2+3+2 ; I counted.
      envi_report_inc, base, n_steps
      istep = 0
   endif
   
   data = hash()
   data['file'] = viirs_file

   ; Read geocoords.
   geocoords = ['Longitude','Latitude']
   foreach coord, geocoords do begin
      if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
      path = '/All_Data/VIIRS-IMG-GTM-EDR-GEO_All/' + coord
      data[coord] = viirs_read_dataset(viirs_file, path, /silent)
   endforeach

   ; Identify gaps between granules, then join latitude and longitude.
   igaps = viirs_locate_granule_gaps(data['Longitude'])
   foreach coord, geocoords do $
      data[coord] = viirs_remove_granule_gaps(data[coord], igaps)
   
   ; Read, scale, join granules in reflective bands
   rbands = 'I' + strtrim(indgen(3, start=1),2)
   foreach iband, rbands do begin
      if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
      path = '/All_Data/VIIRS-' + iband + '-IMG-EDR_All/'
      dataset = path + 'Reflectance'
      factors = path + 'ReflectanceFactors'
      packed = viirs_read_dataset(viirs_file, dataset, /silent)
      scaled = viirs_read_dataset(viirs_file, factors, /silent)
      data[iband] = viirs_scale_dataset(packed, scaled)
      data[iband] = viirs_remove_granule_gaps(data[iband], igaps)
   endforeach
   
   ; Read, scale, join granules in emissive bands.
   ebands = 'I' + strtrim(indgen(2, start=4),2)
   foreach iband, ebands do begin
      if keyword_set(report) then envi_report_stat, base, ++istep, n_steps
      path = '/All_Data/VIIRS-' + iband + '-IMG-EDR_All/'
      dataset = path + 'BrightnessTemperature'
      factors = path + 'BrightnessFactors'
      packed = viirs_read_dataset(viirs_file, dataset, /silent)
      scaled = viirs_read_dataset(viirs_file, factors, /silent)
      data[iband] = viirs_scale_dataset(packed, scaled)
      data[iband] = viirs_remove_granule_gaps(data[iband], igaps)
   endforeach

   if keyword_set(report) then envi_report_init, base=base, /finish

   data['dimensions'] = size(data['Longitude'], /dimensions)
   return, data.tostruct()
end

; Example (assuming data in IDL path)
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
iband_data = viirs_ingest_iband_file(f)
help, iband_data
end
