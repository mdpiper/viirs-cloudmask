; docformat = 'rst'
;+
; Replaces pixel-trim values with the mean value of surrounding non-fill pixels.
;
; :author:
;  Curtis Seaman, CIRA/Colorado State University
;  
; :history:
;  2015-03, Mark Piper: Use median instead of mean value across pixel trim line.
;-
pro eliminate_lines_single, latitude, longitude, red, ascending

print, 'Eliminating bowtie deletion lines.'

old_red = red
old_lon = longitude
old_lat = latitude

size_factor = 1
array_size = size(latitude)
if array_size[0] ne 2 then begin
  print, 'ERROR: array not 2-D. Something went wrong. I quit!'
  stop
endif
if array_size[1] ne 6400 and array_size[1] ne 3200 then print, 'WARNING: not a typical array size. This might not work!'
if array_size[1] eq 6400 then size_factor = 1
if array_size[1] eq 3200 then size_factor = 2

;stop
for i = 0, array_size[1]-1 do begin
  ;if i le 2016 or i ge 4384 then begin
    strip = latitude(i, *)
    jmax = where(strip eq max(strip, /NAN))
    jmin = where(strip eq min(strip, /NAN))
    if (jmax[0] gt 1 and jmax[0] lt array_size[2]-2) or (jmin[0] gt 1 and jmin[0] lt array_size[2]-2) then begin
      strip = longitude(i,*)
      if min(strip) lt -175.5 and max(strip) gt 175.5 then begin
        ;stop
        eastern_hemisphere = where(strip gt 0.0, neh)
        ;western_hemisphere = where(strip lt 0.0, nwh)
        if neh gt 0 then strip(eastern_hemisphere) -= 360.0
        ;if nwh gt 0 then strip(western_hemisphere) += 360.0
      endif
      kmax = where(strip eq max(strip, /NAN))
      kmin = where(strip eq min(strip, /NAN))
      if (kmax[0] gt 1 and kmax[0] lt array_size[2]-2) or (kmin[0] gt 1 and kmin[0] lt array_size[2]-2) then begin

      endif else begin
        sorted_strip = sort(strip)
        sorted_latitude = latitude(i, sorted_strip)
        sorted_longitude = longitude(i, sorted_strip)
        sorted_red = red(i, sorted_strip)
        latitude(i,*) = sorted_latitude
        longitude(i,*) = sorted_longitude
        red(i,*) = sorted_red
      endelse
    endif else begin
      sorted_strip = sort(strip)
      sorted_latitude = latitude(i, sorted_strip)
      sorted_longitude = longitude(i, sorted_strip)
      sorted_red = red(i, sorted_strip)
      latitude(i,*) = sorted_latitude
      longitude(i,*) = sorted_longitude
      red(i,*) = sorted_red
    endelse

  if ascending then begin
   if latitude(i,array_size[2]-1) lt latitude(i,0) then begin
     longitude(i,*) = reverse(longitude(i,*), 2, /overwrite)
     latitude(i,*) = reverse(latitude(i,*), 2, /overwrite)
     red(i,*) = reverse(red(i,*), 2, /overwrite)
   endif
  endif

  bad_red = where(finite(red(i,*)) eq 0, nbad_red)
  if nbad_red gt 0 then begin
    for j = 0, nbad_red-1 do begin
      if bad_red(j) gt 0 and bad_red(j) lt array_size[2]-1 then begin
        op = 1
        om = 1
        k = 0
        while (bad_red(j) - om) eq bad_red(j-om) do begin
          om += 1
          k += 1
          if j-om le 0 then break
          if k ge 4 then break
        endwhile
        k = 0
        if j lt nbad_red-1 then begin
          while (bad_red(j) + op) eq bad_red(j+op) do begin
            op += 1
            k += 1
            if j+op ge (nbad_red - 1) then break
            if k ge 4 then break
          endwhile
        endif
        mn = (bad_red(j) - om) > 0
        mx = (bad_red(j) + op) < (array_size[2]-1)
;        red(i,bad_red(j)) = (red(i,mn) + red(i,mx))/2.0
        red(i,bad_red(j)) = median([red(i,mn), red(i,mx)]) ; MP
      endif
    endfor
  endif
endfor

print, 'Done.'
;stop
end
