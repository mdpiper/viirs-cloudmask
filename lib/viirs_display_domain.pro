; docformat = 'rst'
;+
; Displays where the data from a VIIRS file are located on the Earth, with
; optional output to KML.
; 
; :params:
;  viirs_file: in, required, type=string
;   The path to a VIIRS I-Band file.
; 
; :keywords:
;  save: in, optional, type=boolean
;   Set this keyword to save the visualization to KML file.
;
; :uses:
;  viirs_read_dataset
;  
; :author:
;  Mark Piper (mark.piper@colorado.edu) 
;-
pro viirs_display_domain, viirs_file, group, save=save
   compile_opt idl2
   
   if group eq !null then group = 'VIIRS-IMG-GTM-EDR-GEO_All'
   
   ; Read geolocations from file.
   dataset = '/All_Data/' + group + '/' + ['Longitude','Latitude']
   longitude = viirs_read_dataset(viirs_file, dataset[0])
   latitude = viirs_read_dataset(viirs_file, dataset[1])
   
   ; Locate flagged values.
   fillvalue_base = -999.0 ; additional flags are set below this value.
   tol = 1.0
   i_fill = where(abs(longitude - fillvalue_base) le tol, /null)
   
   ; Map longitudes to [0,360].
   longitude += 360.0
   longitude mod= 360.0

   ; Places NaNs at flagged locations.
   longitude[i_fill] = !values.f_nan
   latitude[i_fill] = !values.f_nan
   
   ; Determine bounding box.
   minlon = min(longitude, max=maxlon, /nan)
   minlat = min(latitude, max=maxlat, /nan)
   x = [minlon, maxlon, maxlon, minlon, minlon]
   y = [minlat, minlat, maxlat, maxlat, minlat]
   
   ; Visualize.
   if keyword_set(save) then begin
      m = map('Mercator', limit=[minlat,minlon,maxlat,maxlon], /buffer)
      box = polyline(x, y, color='red', target=m, /data)
      m.save, 'viirs_display_domain.kml'
   endif else begin
      m = map('Mercator', $
         center_longitude=mean([minlon,maxlon]), $
         color='tan', $
         title='Data domain')
      m.mapgrid.label_position = 0
      m.mapgrid.label_color = 'black'
      c = mapcontinents(fill_color='light gray')
      box = polyline(x, y, color='red', target=m, /data)
   endelse
end

; Example
f = file_which('GIGTO-VI1BO-VI2BO-VI3BO-VI4BO-VI5BO_npp_d20120206_t2357498_e0004017_b01442_c20120208215415851238_noaa_ops.h5')
viirs_display_domain, f, save=0
end
