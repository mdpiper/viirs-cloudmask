; docformat = 'rst'
;+
; Generates a text-based report with statistics and skill scores.
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-
pro viirs_generate_report, stats, out_name=out_name
   compile_opt idl2
   
   openw, u, out_name, /get_lun

   printf, u, '**********'
   printf, u, '* Report *'
   printf, u, '**********'
   printf, u
   printf, u, systime()
   printf, u
   printf, u, 'Directory: '
   printf, u, file_dirname(out_name, /mark_directory)
   printf, u
   printf, u, 'Input files:'
   printf, u, stats['iband_file']
   printf, u, stats['vcmip_file']
   printf, u
   printf, u, 'Total number of pixels in the scene, including fill areas:'
   printf, u, stats['n_full'], format='(i15)'
   printf, u
   printf, u, 'Number of pixels in the study area:'
   printf, u, stats['n_intersection'], format='(i15)'
   printf, u
   printf, u, 'Area (m^2) of study area:'
   printf, u, stats['area']
   printf, u
   printf, u, 'Number of cloudy pixels in VIBCM and VCMIP:'
   printf, u, stats['n_vibcm'], format='(i15)'
   printf, u, stats['n_vcmip'], format='(i15)'
   printf, u
   printf, u, 'Cloud fraction in VIBCM and VCMIP:'
   printf, u, stats['cf_vibcm'], format='(f15.4)'
   printf, u, stats['cf_vcmip'], format='(f15.4)'
   printf, u   
   printf, u, 'Contingency table - hit (a):'
   printf, u, stats['hit'], format='(i15)'
   printf, u
   printf, u, 'Contingency table - false alarm (b):'   
   printf, u, stats['false alarm'], format='(i15)'
   printf, u
   printf, u, 'Contingency table - miss (c):'   
   printf, u, stats['miss'], format='(i15)'
   printf, u
   printf, u, 'Contingency table - correct nonevent (d):'
   printf, u, stats['correct nonevent'], format='(i15)'   
   printf, u
   printf, u, 'Contingency table - sanity check:'
   printf, u, stats['sanity check'], format='(i15)'
   printf, u       
   printf, u, 'Bias:'
   printf, u, stats['bias'], format='(f15.4)'
   printf, u 
   printf, u, 'Hit rate:'
   printf, u, stats['hit rate'], format='(f15.4)'
   printf, u
   printf, u, 'Accuracy:'
   printf, u, stats['accuracy'], format='(f15.4)'
   printf, u
   printf, u, 'False alarm rate:'
   printf, u, stats['false alarm rate'], format='(f15.4)'
   printf, u   
   printf, u, 'Critical Success Index (CSI):'
   printf, u, stats['CSI'], format='(f15.4)'
   printf, u
   printf, u, 'Heidke Skill Score (HSS):'
   printf, u, stats['HSS'], format='(f15.4)'
   printf, u
   printf, u, 'Hanssen-Kuiper Skill Score (KSS):'
   printf, u, stats['KSS'], format='(f15.4)'
   printf, u
   
   free_lun, u
   
   print, 'Report file generated: ' + out_name
end
