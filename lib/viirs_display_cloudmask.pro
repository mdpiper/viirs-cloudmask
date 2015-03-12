; docformat = 'rst'
;+
; Visualizes the VIIRS cloud mask against the background of the RGB false 
; color composite. A slider is used to change the transparency of the mask
; image.
; 
; :examples:
;  After making the RGB and mask images, call this program with::
;     IDL> viirs_display_cloudmask, rgb, mask
;
; :requires:
;  IDL 8.1
;
; :author:
;  Mark Piper (mark.piper@colorado.edu)
;-

;+
; The event handler for the slider widget.
;
; :params:
;  event
;-
pro viirs_display_cloudmask_index_event, event
   compile_opt idl2, hidden
   
   ; Get the state variable from the top-level base.
   widget_control, event.top, get_uvalue=w
   state = w.uvalue
   
   ; Store the new image index and update the display.
   state['index'] = event.value
   w['mask'].transparency = state['index']
end


;+
; The launch routine. Sets up UI & state variable, loads data.
; 
; :params:
;  rgb: in, required, type=bytarr
;     The RGB false color composite image returned from viirs_make_rgb.
;  mask: in, required, type=bytarr
;     The binary mask image returned from viirs_make_cloudmask. 
;-
pro viirs_display_cloudmask, rgb, mask
   compile_opt idl2
   
   if rgb eq !null || mask eq !null then begin
      message, 'Need RGB and mask images. Returning.', /informational
      return
   endif
   
   wtop = widget_base(/column, title='VIS VIIRS Cloud Mask Viewer')

   ss = 0.8*get_screen_size()
   wdraw = widget_window(wtop, xsize=ss[0], ysize=ss[1])
      
   font = !version.os_family eq 'Windows' ? 'Helvetica*Bold*16' : $
      '-adobe-helvetica-bold-r-normal--14-140-75-75-p-82-iso8859-1'
   windex = widget_slider(wtop, $
      title='Cloud Mask Transparency', $
      /drag, $
      font=font, $
      value=100, $
      minimum=0, $
      maximum=100, $
      event_pro='viirs_display_cloudmask_index_event')
      
   widget_control, wtop, /realize
   
   ; Give the draw widget focus and extract the NG window reference.
   widget_control, wdraw, /input_focus
   widget_control, wdraw, get_value=w
   
   ; Display the RGB image with a linear two percent stretch and 
   ; the mask=transparent pink.
   grgb = image(hist_equal(rgb, percent=2), current=w, name='rgb')
   gmask = image(bytscl(mask), overplot=grgb, transparency=100, name='mask')
   ;(gmask.rgb_table)[*,-1] = !color.pink
   ct = gmask.rgb_table
   ct[*,-1] = !color.pink
   gmask.rgb_table = ct
   
   state = hash()
   state['index'] = 0
   
   ; Attach the state variable to the NG window's user value. Attach the NG
   ; window to the top-level base's user value. This ensures that state
   ; information can be communicated to both the widget & NG event handlers.
   w.uvalue = state
   widget_control, wtop, set_uvalue=w
   
   xmanager, 'viirs_display_cloudmask', wtop, /no_block
end

