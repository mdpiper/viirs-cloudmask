function viirs_calculate_stats, stacked_file
   compile_opt idl2

   e = envi(/current)
   if e eq !null then e = envi(/headless)

   s = e.openraster(stacked_file)
   d_vibcm = s.getdata(bands=0)
   d_vcmip = s.getdata(bands=1)
   
   stats = hash()

   ; Total number of pixels in the scene, including fill areas.
   stats['n_full'] = n_elements(d_vibcm) ; = ns*nl

   ; Define the intersection between vibcm and vcmip, and the number of 
   ; pixels in this intersection. This is the "roi".
   m_vibcm = d_vibcm ne 0B
   m_vcmip = d_vcmip ne 0B
   i_intersection = where((m_vibcm + m_vcmip) eq 2B, n_intersection)
   stats['n_intersection'] = n_elements(i_intersection)
   ; visual check: g = image(bytscl(m_vibcm + m_vcmip))
   
   ; The vibcm and vcmip pixels, flattened and restored to the range [0,1].
   s_vibcm = d_vibcm[i_intersection] - 1B
   s_vcmip = d_vcmip[i_intersection] - 1B
   
   ; The area, in m^2, covered by the roi.
   pixelsize = 373.1 ; m
   stats['area'] = stats['n_intersection'] * product(s.spatialref.pixel_size)
   
   ; The number of cloudy pixels in vibcm and vcmip.
   stats['n_vibcm'] = total(s_vibcm, /integer)
   stats['n_vcmip'] = total(s_vcmip, /integer)
   
   ; The cloud fraction in vibcm and vcmip.
   stats['cf_vibcm'] = float(stats['n_vibcm']) / stats['n_intersection']
   stats['cf_vcmip'] = float(stats['n_vcmip']) / stats['n_intersection']

   ; Calculate entries in contingency table.
   !null = where((s_vibcm eq 1B) and (s_vcmip eq 1B), na) ; hit
   !null = where((s_vibcm eq 1B) and (s_vcmip eq 0B), nb) ; false alarm
   !null = where((s_vibcm eq 0B) and (s_vcmip eq 1B), nc) ; miss
   !null = where((s_vibcm eq 0B) and (s_vcmip eq 0B), nd) ; correct nonevent
   stats['hit'] = na
   stats['false alarm'] = nb
   stats['miss'] = nc
   stats['correct nonevent'] = nd
   stats['sanity check'] = (na + nb + nc + nd) eq stats['n_intersection']

   _na = double(na)
   _nb = double(nb)
   _nc = double(nc)
   _nd = double(nd)

   stats['bias'] = (_na + _nb) / (_na + _nc)
   stats['hit rate'] = _na / (_na + _nc)
   stats['accuracy'] = (_na + _nd) / stats['n_intersection']
   stats['false alarm rate'] = _nb / (_nb + _nd)
   stats['CSI'] = _na / (_na + _nb + _nc) ; Critical Success Index
   stats['HSS'] = 2*(_na*_nd - _nb*_nc) $
      / ((_na + _nc)*(_nd + _nc) + (_na + _nb)*(_nd + _nb)) ; Heidke Skill Score
   stats['KSS'] = (_na*_nd - _nb*_nc) $   
      / ((_na + _nc)*(_nd + _nb)) ; Hanssen-Kuiper Skill Score
         
   ; XXX: Option to close ENVI
   
   return, stats
end
