pro viirs_make_pretty_pictures, $
      data1=data1, $
      data2=data2, $
      out_dir=output_dir, $
      iband=iband, $
      vcmip=vcmip, $
      stacked_masks=stacked, $
      rgb_composite=rgb
   compile_opt idl2
   
   if output_dir eq !null then output_dir = file_expand_path('.') + path_sep()
   
   case 1 of
      keyword_set(vcmip): begin
      
         bmask = bytscl(reverse(data2, 1))
         
         g1 = image(bmask, /buffer, dimensions=[960,768], $
            title='VCMIP-derived Cloud Mask')
         out_name = output_dir + 'vcmip.png'
         print, 'Saving: ' + out_name
         g1.save, out_name, resolution=600
         g1.close
      end
      keyword_set(iband): begin
      
         rgb = reverse(viirs_make_rgb(data1), 2)
         bmask = bytscl(reverse(data2, 1))
         
         g1 = image(hist_equal(rgb, percent=2), /buffer, dimensions=[960,768], $
            title='VIIRS (I3,I2,I1) false-color composite')
         out_name = output_dir + 'viirs-i3-i2-i1-composite-1.png'
         print, 'Saving: ' + out_name
         g1.save, out_name, resolution=600
         g1.close
         
         g2 = image(bmask, /buffer, title='VIIRS I-Band Cloud Mask')
         out_name = output_dir + 'vibcm.png'
         print, 'Saving: ' + out_name
         g2.save, out_name, resolution=600
         g2.close
         
         g3 = image(rgb, /buffer, title='RGB composite + mask overlay')
         g4 = image(bmask, transparency=50, overplot=g3)
         out_name = output_dir + 'vibcm-rgb-overlay.png'
         print, 'Saving: ' + out_name
         g3.save, out_name, resolution=600
         g3.close
      end
      keyword_set(stacked): begin ; XXX: oh, the horror.
         e = envi(/current)
         stack = e.openraster(data1)
         d_vibcm = stack.getdata(bands=0)
         d_vcmip = stack.getdata(bands=1)
         
         i_hit = where((d_vibcm eq 2B) and (d_vcmip eq 2B)) ; hit
         i_fa = where((d_vibcm eq 2B) and (d_vcmip ne 2B)) ; false alarm
         i_miss = where((d_vibcm ne 2B) and (d_vcmip eq 2B)) ; miss
         i_back = where((d_vibcm eq 0B) and (d_vcmip eq 0B))
         
         d_vcmip_vibcm = d_vibcm*0B
         d_vcmip_vibcm[i_hit] = 4B
         d_vcmip_vibcm[i_fa] = 3B
         d_vcmip_vibcm[i_miss] = 2B
         d_vcmip_vibcm[i_back] = 1B
         
         ct = colortable(['black', 'light gray', 'blue', 'yellow', 'white'], $
            ncolors=5)
         g = image(reverse(d_vcmip_vibcm, 2), rgb_table=ct, /buffer, $
            title='VIBCM-VCMIP Comparison', dimensions=[960,768])
            
         out_name = output_dir + 'vibcm-vcmip-comparison.png'
         print, 'Saving: ' + out_name
         g.save, out_name, resolution=600
         g.close
      end
      keyword_set(rgb): begin
         e = envi(/current)
         rgb = e.openraster(data1)
         d_rgb = rgb.getdata(bands=[0,1,2])
         i_replace = where(d_rgb eq 0)
         d_rgb[i_replace] = 211B
         d_rgb = hist_equal(d_rgb, percent=2)
         g = image(d_rgb, /order, /buffer, dimensions=[960,768], $
            title='VIIRS (I3,I2,I1) false-color composite')
         out_name = output_dir + 'viirs-i3-i2-i1-composite-2.png'
         print, 'Saving: ' + out_name
         g.save, out_name, resolution=600
         g.close
      end
      else: begin
         print, 'No matches, man.'
      end
   endcase
end
