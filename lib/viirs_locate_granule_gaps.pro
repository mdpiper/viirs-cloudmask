; docformat = 'rst'
;+
; Locates the gaps between the four granules in a VIIRS I-Band Imagery EDR 
; using the included geolocation (longitude, though latitude would also work)
; information.
;
; :params:
;  longitude: in, required, type=float
;   An array of longitude values read from a VIIRS I-Band Imagery EDR.
;
; :returns:
;  An 8-element array containing the start and stop indices of the four 
;  granules in the file, or null on fail.
;
; :requires:
;  IDL 8
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
function viirs_locate_granule_gaps, longitude
   compile_opt idl2

   ; Locate the gaps between granules with a vertical trace through the
   ; longitudes.
   lon_vertical_trace = longitude[0,*] ; first column
   fillvalue = -999.0 ; from docs; there are codes in [-999.0,-999.9]
   igaps = where(lon_vertical_trace le fillvalue, ngaps)
   if ngaps eq 0 then return, !null

   ; There are three gaps between the four granules plus fill at the top.
   igapchange = where((igaps - shift(igaps,1)) gt 1, ngapchange)
   igap1 = igaps[0:igapchange[0]-1]
   igap2 = igaps[igapchange[0]:igapchange[1]-1]
   igap3 = igaps[igapchange[1]:igapchange[2]-1]
   igap4 = igaps[igapchange[2]:-1]

   ; Start-stop indices for the granules.
   index = [ $
      0, igap1[0]-1, $           ; granule #1
      igap1[-1]+1, igap2[0]-1, $ ; #2
      igap2[-1]+1, igap3[0]-1, $ ; #3
      igap3[-1]+1, igap4[0]-1 $  ; #4
      ]

   return, index
end
