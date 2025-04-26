; Variables (v) and Flags (f)

v_bgscroll_buffer:	equ	$FFFFA800	; background scroll buffer ($200 bytes)
v_ngfx_buffer:	equ $FFFFAA00	; Nemesis graphics decompression buffer ($200 bytes)
v_spritequeue:	equ $FFFFAC00	; sprite display queue, in order of priority ($400 bytes)
v_16x16:		equ $FFFFB000	; 16x16 tile mappings

VDP_Command_Buffer:		equ $FFFFC800
VDP_Command_Buffer_Slot:	equ $FFFFC800+($12*$16)

v_tracksonic:	equ $FFFFCB00	; position tracking data for Sonic ($100 bytes)
v_hscrolltablebuffer:	equ $FFFFCC00 ; scrolling table data (actually $380 bytes, but $400 is reserved for it)
v_objspace:	equ $FFFFD000	; object variable space ($40 bytes per object) ($2000 bytes)
v_player:	equ v_objspace	; object variable space for Sonic ($40 bytes)
v_lvlobjspace:	equ $FFFFD800	; level object variable space ($1800 bytes)

v_snddriver_ram:	equ $FFFF8000 ; start of RAM for the sound driver data ($5C0 bytes)

; =================================================================================
; From here on, until otherwise stated, all offsets are relative to v_snddriver_ram
; =================================================================================
v_startofvariables:	equ $000
v_sndprio:		equ $000	; sound priority (priority of new music/SFX must be higher or equal to this value or it won't play; bit 7 of priority being set prevents this value from changing)
f_pausemusic:		equ $001	; flag set to stop music when paused

v_ring_speaker:		equ $002	; which speaker the "ring" sound is played in (00 = right; 01 = left)
f_push_playing:		equ $003	; if set, prevents further push sounds from playing

f_voice_selector:	equ $004	; $00 = use music voice pointer; $40 = use special voice pointer; $80 = use track voice pointer

v_sound_id:		equ $005	; sound or music copied from below
v_soundqueue0:		equ $006	; sound to play 0
v_soundqueue1:		equ $007	; sound to play 1
v_soundqueue2:		equ $008	; sound to play 2
v_soundqueue3:		equ $009	; sound to play 3

v_special_voice_ptr:	equ $00A	; voice data pointer for special SFX ($D0-$DF) (4 bytes)

v_sfx_track_ram:	equ $010	; Start of SFX RAM

v_sfx_fm_tracks:	equ v_sfx_track_ram+TrackSz*0
v_sfx_fm3_track:	equ v_sfx_fm_tracks+TrackSz*0
v_sfx_fm4_track:	equ v_sfx_fm_tracks+TrackSz*1
v_sfx_fm5_track:	equ v_sfx_fm_tracks+TrackSz*2
v_sfx_fm_tracks_end:	equ v_sfx_fm_tracks+TrackSz*3
v_sfx_psg_tracks:	equ v_sfx_fm_tracks_end
v_sfx_psg1_track:	equ v_sfx_psg_tracks+TrackSz*0
v_sfx_psg2_track:	equ v_sfx_psg_tracks+TrackSz*1
v_sfx_psg3_track:	equ v_sfx_psg_tracks+TrackSz*2
v_sfx_psg_tracks_end:	equ v_sfx_psg_tracks+TrackSz*3
v_sfx_track_ram_end:	equ v_sfx_psg_tracks_end

v_spcsfx_track_ram:	equ v_sfx_track_ram_end	; Start of special SFX RAM, straight after the end of SFX RAM

v_spcsfx_fm4_track:	equ v_spcsfx_track_ram+TrackSz*0
v_spcsfx_psg3_track:	equ v_spcsfx_track_ram+TrackSz*1
v_spcsfx_track_ram_end:	equ v_spcsfx_track_ram+TrackSz*2

; =================================================================================
; From here on, no longer relative to sound driver RAM
; =================================================================================

v_gamemode:	equ $FFFF8600	; game mode (00=Sega; 04=Title; 08=Demo; 0C=Level; 10=SS; 14=Cont; 18=End; 1C=Credit; +8C=PreLevel)
v_jpadhold2:	equ $FFFF8602	; joypad input - held, duplicate
v_jpadpress2:	equ $FFFF8603	; joypad input - pressed, duplicate
v_jpadhold1:	equ $FFFF8604	; joypad input - held
v_jpadpress1:	equ $FFFF8605	; joypad input - pressed

v_vdp_buffer1:	equ $FFFF860C	; VDP instruction buffer (2 bytes)

v_demolength:	equ $FFFF8614	; the length of a demo in frames (2 bytes)
v_scrposy_dup:	equ $FFFF8616	; screen position y (duplicate) (2 bytes)
v_bgscrposy_dup:	equ $FFFF8618	; background screen position y (duplicate) (2 bytes)
v_scrposx_dup:	equ $FFFF861A	; screen position x (duplicate) (2 bytes)
v_bgscreenposx_dup_unused:	equ $FFFF861C	; background screen position x (duplicate) (2 bytes)
v_bg3screenposy_dup_unused:	equ $FFFF861E	; (2 bytes)
v_bg3screenposx_dup_unused:	equ $FFFF8620	; (2 bytes)

v_hbla_hreg:	equ $FFFF8624	; VDP H.interrupt register buffer (8Axx) (2 bytes)
v_hbla_line:	equ $FFFF8625	; screen line where water starts and palette is changed by HBlank
v_pfade_start:	equ $FFFF8626	; palette fading - start position in bytes
v_pfade_size:	equ $FFFF8627	; palette fading - number of colours
v_vbla_routine:	equ $FFFF862A	; VBlank - routine counter
v_spritecount:	equ $FFFF862C	; number of sprites on-screen
v_random:	equ $FFFF8636	; pseudo random number buffer (4 bytes)
f_pause:		equ $FFFF863A	; flag set to pause the game (2 bytes)
v_vdp_buffer2:	equ $FFFF8640	; VDP instruction buffer (2 bytes)
f_hbla_pal:	equ $FFFF8644	; flag set to change palette during HBlank (0000 = no; 0001 = change) (2 bytes)
v_waterpos1:	equ $FFFF8646	; water height, actual (2 bytes)
v_waterpos2:	equ $FFFF8648	; water height, ignoring sway (2 bytes)
v_waterpos3:	equ $FFFF864A	; water height, next target (2 bytes)
f_water:		equ $FFFF864C	; flag set for water
v_wtr_routine:	equ $FFFF864D	; water event - routine counter
f_wtr_state:	equ $FFFF864E	; water palette state when water is above/below the screen (00 = partly/all dry; 01 = all underwater)
f_hint_updates:	equ $FFFF864F

v_pal_buffer:	equ $FFFF8650	; palette data buffer (used for palette cycling) ($30 bytes)
v_plc_buffer:	equ $FFFF8680	; pattern load cues buffer (maximum $10 PLCs) ($60 bytes)
v_ptrnemcode:	equ $FFFF86E0	; pointer for nemesis decompression code ($1502 or $150C) (4 bytes)

f_plc_execute:	equ $FFFF86F8	; flag set for pattern load cue execution (2 bytes)

v_screenposx:	equ $FFFF8700	; screen position x (2 bytes)
v_screenposy:	equ $FFFF8704	; screen position y (2 bytes)
v_bgscreenposx:	equ $FFFF8708	; background screen position x (2 bytes)
v_bgscreenposy:	equ $FFFF870C	; background screen position y (2 bytes)
v_bg2screenposx:	equ $FFFF8710	; 2 bytes
v_bg2screenposy:	equ $FFFF8714	; 2 bytes
v_bg3screenposx:	equ $FFFF8718	; 2 bytes
v_bg3screenposy:	equ $FFFF871C	; 2 bytes

v_limitleft1:	equ $FFFF8720	; left level boundary (2 bytes)
v_limitright1:	equ $FFFF8722	; right level boundary (2 bytes)
v_limittop1:	equ $FFFF8724	; top level boundary (2 bytes)
v_limitbtm1:	equ $FFFF8726	; bottom level boundary (2 bytes)
v_limitleft2:	equ $FFFF8728	; left level boundary (2 bytes)
v_limitright2:	equ $FFFF872A	; right level boundary (2 bytes)
v_limittop2:	equ $FFFF872C	; top level boundary (2 bytes)
v_limitbtm2:	equ $FFFF872E	; bottom level boundary (2 bytes)

v_limitleft3:	equ $FFFF8732	; left level boundary, at the end of an act (2 bytes)

v_scrshiftx:	equ $FFFF873A	; x-screen shift (new - last) * $100
v_scrshifty:	equ $FFFF873C	; y-screen shift (new - last) * $100

v_lookshift:	equ $FFFF873E	; screen shift when Sonic looks up/down (2 bytes)
v_dle_routine:	equ $FFFF8742	; dynamic level event - routine counter
f_nobgscroll:	equ $FFFF8744	; flag set to cancel background scrolling

v_fg_xblock:	equ	$FFFF874A	; foreground x-block parity (for redraw)
v_fg_yblock:	equ	$FFFF874B	; foreground y-block parity (for redraw)
v_bg1_xblock:	equ	$FFFF874C	; background x-block parity (for redraw)
v_bg1_yblock:	equ	$FFFF874D	; background y-block parity (for redraw)
v_bg2_xblock:	equ	$FFFF874E	; secondary background x-block parity (for redraw)
v_bg2_yblock:	equ	$FFFF874F	; secondary background y-block parity (unused)
v_bg3_xblock:	equ	$FFFF8750	; teritary background x-block parity (for redraw)
v_bg3_yblock:	equ	$FFFF8751	; teritary background y-block parity (unused)

v_fg_scroll_flags:	equ $FFFF8754	; screen redraw flags for foreground
v_bg1_scroll_flags:	equ $FFFF8756	; screen redraw flags for background 1
v_bg2_scroll_flags:	equ $FFFF8758	; screen redraw flags for background 2
v_bg3_scroll_flags:	equ $FFFF875A	; screen redraw flags for background 3
f_bgscrollvert:	equ $FFFF875C	; flag for vertical background scrolling
v_sonframenum:	equ $FFFF8766	; frame to display for Sonic
v_anglebuffer:	equ $FFFF8768	; angle of collision block that Sonic or object is standing on

v_opl_routine:	equ $FFFF876C	; ObjPosLoad - routine counter
v_opl_screen:	equ $FFFF876E	; ObjPosLoad - screen variable
v_opl_data:	equ $FFFF8770	; ObjPosLoad - data buffer ($10 bytes)
Camera_X_pos_coarse	equ $FFFF8778

v_ssangle:	equ $FFFF8780	; Special Stage angle (2 bytes)
v_ssrotate:	equ $FFFF8782	; Special Stage rotation speed (2 bytes)
v_btnpushtime1:	equ $FFFF8790	; button push duration - in level (2 bytes)
v_btnpushtime2:	equ $FFFF8792	; button push duration - in demo (2 bytes)
v_palchgspeed:	equ $FFFF8794	; palette fade/transition speed (0 is fastest) (2 bytes)
v_collindex:	equ $FFFF8796	; ROM address for collision index of current level (4 bytes)
v_palss_num:	equ $FFFF879A	; palette cycling in Special Stage - reference number (2 bytes)
v_palss_time:	equ $FFFF879C	; palette cycling in Special Stage - time until next change (2 bytes)

v_obj31ypos:	equ $FFFF87A4	; y-position of object 31 (MZ stomper) (2 bytes)
v_bossstatus:	equ $FFFF87A7	; status of boss and prison capsule (01 = boss defeated; 02 = prison opened)
v_trackpos:	equ $FFFF87A8	; position tracking reference number (2 bytes)
v_trackbyte:	equ $FFFF87A9	; low byte for position tracking
f_lockscreen:	equ $FFFF87AA	; flag set to lock screen during bosses
v_256loop1:	equ $FFFF87AC	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256loop2:	equ $FFFF87AD	; 256x256 level tile which contains a loop (GHZ/SLZ)
v_256roll1:	equ $FFFF87AE	; 256x256 level tile which contains a roll tunnel (GHZ)
v_256roll2:	equ $FFFF87AF	; 256x256 level tile which contains a roll tunnel (GHZ)
v_lani0_frame:	equ $FFFF87B0	; level graphics animation 0 - current frame
v_lani0_time:	equ $FFFF87B1	; level graphics animation 0 - time until next frame
v_lani1_frame:	equ $FFFF87B2	; level graphics animation 1 - current frame
v_lani1_time:	equ $FFFF87B3	; level graphics animation 1 - time until next frame
v_lani2_frame:	equ $FFFF87B4	; level graphics animation 2 - current frame
v_lani2_time:	equ $FFFF87B5	; level graphics animation 2 - time until next frame
v_lani3_frame:	equ $FFFF87B6	; level graphics animation 3 - current frame
v_lani3_time:	equ $FFFF87B7	; level graphics animation 3 - time until next frame
v_lani4_frame:	equ $FFFF87B8	; level graphics animation 4 - current frame
v_lani4_time:	equ $FFFF87B9	; level graphics animation 4 - time until next frame
v_lani5_frame:	equ $FFFF87BA	; level graphics animation 5 - current frame
v_lani5_time:	equ $FFFF87BB	; level graphics animation 5 - time until next frame
v_gfxbigring:	equ $FFFF87BE	; settings for giant ring graphics loading (2 bytes)
f_conveyrev:	equ $FFFF87C0	; flag set to reverse conveyor belts in LZ/SBZ
v_obj63:		equ $FFFF87C1	; object 63 (LZ/SBZ platforms) variables (6 bytes)
f_wtunnelmode:	equ $FFFF87C7	; LZ water tunnel mode
f_lockmulti:	equ $FFFF87C8	; flag set to lock controls, lock Sonic's position & animation
f_wtunnelallow:	equ $FFFF87C9	; LZ water tunnels (00 = enabled; 01 = disabled)
f_jumponly:	equ $FFFF87CA	; flag set to lock controls apart from jumping
v_obj6B:		equ $FFFF87CB	; object 6B (SBZ stomper) variable
f_lockctrl:	equ $FFFF87CC	; flag set to lock controls during ending sequence
f_bigring:	equ $FFFF87CD	; flag set when Sonic collects the giant ring
v_itembonus:	equ $FFFF87D0	; item bonus from broken enemies, blocks etc. (2 bytes)
v_timebonus:	equ $FFFF87D2	; time bonus at the end of an act (2 bytes)
v_ringbonus:	equ $FFFF87D4	; ring bonus at the end of an act (2 bytes)
f_endactbonus:	equ $FFFF87D6	; time/ring bonus update flag at the end of an act
v_sonicend:	equ $FFFF87D7	; routine counter for Sonic in the ending sequence
v_lz_deform:	equ	$FFFF87D8	; LZ deformtaion offset, in units of $80 (2 bytes)
f_switch:	equ $FFFF87E0	; flags set when Sonic stands on a switch ($10 bytes)
v_scroll_block_1_size:	equ $FFFF87F0	; (2 bytes)
v_scroll_block_2_size:	equ $FFFF87F2	; unused (2 bytes)
v_scroll_block_3_size:	equ $FFFF87F4	; unused (2 bytes)
v_scroll_block_4_size:	equ $FFFF87F6	; unused (2 bytes)

v_spritetablebuffer:	equ $FFFF8800 ; sprite table ($280 bytes, last $80 bytes are overwritten by v_pal_water_dup)
v_pal_water_dup:	equ $FFFF8A00 ; duplicate underwater palette, used for transitions ($80 bytes)
v_pal_water:	equ $FFFF8A80	; main underwater palette ($80 bytes)
v_pal_dry:	equ $FFFF8B00	; main palette ($80 bytes)
v_pal_dry_dup:	equ $FFFF8B80	; duplicate palette, used for transitions ($80 bytes)

f_restart:	equ $FFFF8E02	; restart level flag (2 bytes)
v_framecount:	equ $FFFF8E04	; frame counter (adds 1 every frame) (2 bytes)
v_framebyte:	equ v_framecount+1; low byte for frame counter
v_debugitem:	equ $FFFF8E06	; debug item currently selected (NOT the object number of the item)
v_debuguse:	equ $FFFF8E08	; debug mode use & routine counter (when Sonic is a ring/item) (2 bytes)
v_debugxspeed:	equ $FFFF8E0A	; debug mode - horizontal speed
v_debugyspeed:	equ $FFFF8E0B	; debug mode - vertical speed
v_vbla_count:	equ $FFFF8E0C	; vertical interrupt counter (adds 1 every VBlank) (4 bytes)
v_vbla_word:	equ v_vbla_count+2 ; low word for vertical interrupt counter (2 bytes)
v_vbla_byte:	equ v_vbla_word+1	; low byte for vertical interrupt counter
v_zone:		equ $FFFF8E10	; current zone number
v_act:		equ $FFFF8E11	; current act number
v_lives:		equ $FFFF8E12	; number of lives
health:		equ $FFFF8E14	; health remaining
v_lastspecial:	equ $FFFF8E16	; last special stage number
v_continues:	equ $FFFF8E18	; number of continues
v_lifecount:	equ $FFFF8E1B	; lives counter value (for actual number, see "v_lives")
f_lifecount:	equ $FFFF8E1C	; lives counter update flag
f_ringcount:	equ $FFFF8E1D	; ring counter update flag
f_scorecount:	equ $FFFF8E1F	; score counter update flag
v_rings:		equ $FFFF8E20	; rings (2 bytes)
v_ringbyte:	equ v_rings+1	; low byte for rings
v_time:		equ $FFFF8E22	; time (4 bytes)
v_timemin:	equ $FFFF8E23	; time - minutes
v_timesec:	equ $FFFF8E24	; time - seconds
v_timecent:	equ $FFFF8E25	; time - centiseconds
v_score:		equ $FFFF8E26	; score (4 bytes)
v_shoes:		equ $FFFF8E2E	; speed shoes status (00 = no; 01 = yes)
v_lastlamp:	equ $FFFF8E30	; number of the last lamppost you hit
v_lamp_xpos:	equ v_lastlamp+2	; x-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_ypos:	equ v_lastlamp+4	; y-axis for Sonic to respawn at lamppost (2 bytes)
v_lamp_rings:	equ v_lastlamp+6	; rings stored at lamppost (2 bytes)
v_lamp_time:	equ v_lastlamp+8	; time stored at lamppost (2 bytes)
v_lamp_dle:	equ v_lastlamp+$C	; dynamic level event routine counter at lamppost
v_lamp_limitbtm:	equ v_lastlamp+$E	; level bottom boundary at lamppost (2 bytes)
v_lamp_scrx:	equ v_lastlamp+$10 ; x-axis screen at lamppost (2 bytes)
v_lamp_scry:	equ v_lastlamp+$12 ; y-axis screen at lamppost (2 bytes)

v_lamp_wtrpos:	equ v_lastlamp+$20 ; water position at lamppost (2 bytes)
v_lamp_wtrrout:	equ v_lastlamp+$22 ; water routine at lamppost
v_lamp_wtrstat:	equ v_lastlamp+$23 ; water state at lamppost
v_lamp_lives:	equ v_lastlamp+$24 ; lives counter at lamppost
v_emeralds:	equ $FFFF8E57	; number of chaos emeralds
v_oscillate:	equ $FFFF8E5E	; values which oscillate - for swinging platforms, et al ($42 bytes)
v_ani0_time:	equ $FFFF8EC0	; synchronised sprite animation 0 - time until next frame (used for synchronised animations)
v_ani0_frame:	equ $FFFF8EC1	; synchronised sprite animation 0 - current frame
v_ani1_time:	equ $FFFF8EC2	; synchronised sprite animation 1 - time until next frame
v_ani1_frame:	equ $FFFF8EC3	; synchronised sprite animation 1 - current frame
v_ani2_time:	equ $FFFF8EC4	; synchronised sprite animation 2 - time until next frame
v_ani2_frame:	equ $FFFF8EC5	; synchronised sprite animation 2 - current frame
v_ani3_time:	equ $FFFF8EC6	; synchronised sprite animation 3 - time until next frame
v_ani3_frame:	equ $FFFF8EC7	; synchronised sprite animation 3 - current frame
v_ani3_buf:	equ $FFFF8EC8	; synchronised sprite animation 3 - info buffer (2 bytes)
v_limittopdb:	equ $FFFF8EF0	; level upper boundary, buffered for debug mode (2 bytes)
v_limitbtmdb:	equ $FFFF8EF2	; level bottom boundary, buffered for debug mode (2 bytes)

v_screenposx_dup:	equ $FFFF8F10	; screen position x (duplicate) (2 bytes)
v_screenposy_dup:	equ $FFFF8F14	; screen position y (duplicate) (2 bytes)
v_bgscreenposx_dup:	equ $FFFF8F18	; background screen position x (duplicate) (2 bytes)
v_bgscreenposy_dup:	equ $FFFF8F1C	; background screen position y (duplicate) (2 bytes)
v_bg2screenposx_dup:	equ $FFFF8F20	; 2 bytes
v_bg2screenposy_dup:	equ $FFFF8F24	; 2 bytes
v_bg3screenposx_dup:	equ $FFFF8F28	; 2 bytes
v_bg3screenposy_dup:	equ $FFFF8F2C	; 2 bytes
v_fg_scroll_flags_dup:	equ $FFFF8F30
v_bg1_scroll_flags_dup:	equ $FFFF8F32
v_bg2_scroll_flags_dup:	equ $FFFF8F34
v_bg3_scroll_flags_dup:	equ $FFFF8F36

v_levseldelay:	equ $FFFF8F80	; level select - time until change when up/down is held (2 bytes)
v_levselitem:	equ $FFFF8F82	; level select - item selected (2 bytes)
v_levselsound:	equ $FFFF8F84	; level select - sound selected (2 bytes)

v_cheatbutton:	equ $FFFF8FA0
v_cheatbutton2:	equ $FFFF8FA1
v_cheatactive:	equ $FFFF8FA2

v_buildhud:	equ $FFFF8FA8
v_buildrings:	equ $FFFF8FAC
v_levelchunks:	equ $FFFF8FB0
v_palindex:	equ $FFFF8FB4
v_objindex:	equ $FFFF8FB8
v_plcindex:	equ $FFFF8FBC

v_scorecopy:	equ $FFFF8FC0	; score, duplicate (4 bytes)
v_scorelife:	equ $FFFF8FC0	; points required for an extra life (4 bytes) (JP1 only)
v_colladdr1:	equ $FFFF8FD0	; (4 bytes)
v_colladdr2:	equ $FFFF8FD4	; (4 bytes)
v_top_solid_bit:	equ $FFFF8FD8
v_lrb_solid_bit:	equ $FFFF8FD9
f_levselcheat:	equ $FFFF8FE0	; level select cheat flag
f_slomocheat:	equ $FFFF8FE1	; slow motion & frame advance cheat flag
f_debugcheat:	equ $FFFF8FE2	; debug mode cheat flag
f_creditscheat:	equ $FFFF8FE3	; hidden credits & press start cheat flag
v_title_dcount:	equ $FFFF8FE4	; number of times the d-pad is pressed on title screen (2 bytes)
v_title_ccount:	equ $FFFF8FE6	; number of times C is pressed on title screen (2 bytes)

f_demo:		equ $FFFF8FF0	; demo mode flag (0 = no; 1 = yes; $8001 = ending) (2 bytes)
v_demonum:	equ $FFFF8FF2	; demo level number (not the same as the level number) (2 bytes)
v_creditsnum:	equ $FFFF8FF4	; credits index number (2 bytes)
v_megadrive:	equ $FFFF8FF8	; Megadrive machine type
f_debugmode:	equ $FFFF8FFA	; debug mode flag (sometimes 2 bytes)

	rsset	$FFFF9000
bossFlag		rs.b	1
gameOverFlag		rs.b	1
			rs.b	6

levelLayout		rs.b	$FF8

Ring_Positions		rs.w	$200
Ring_consumption_table	rs.w	$40

Ring_start_addr_ROM	rs.l	1
Ring_end_addr_ROM	rs.l	1
Ring_start_addr_RAM	rs.w	1
Rings_manager_routine	rs.b	1

superFlag		rs.b	1
superTransform		rs.b	1
superRingTimer		rs.b	1
superPalIndex		rs.l	1

levelStarted		rs.b	1
levelEnded		rs.b	1
secretBoss		rs.b	1

tireLeak		rs.b	1
tirePressure		rs.w	1

effectFlags		rs.b	1
effectTriggers		rs.b	1
effectWaterPal		rs.w	$40
effectPalette		rs.w	$40
raveTimer		rs.w	1
raveDelay		rs.w	1
raveMusic		rs.b	1
			rs.b	1
raveColors		rs.l	1
lsdTimer		rs.w	1
lsdDelay		rs.w	1
lsdColors		rs.l	1
lsdSine			rs.l	1
lsdVScroll		rs.l	$50

v_pcyc_num		rs.w	1
v_pcyc_time		rs.w	1
v_pcyc_num2		rs.w	1
v_pcyc_time2		rs.w	1

warpX			rs.w	1
warpY			rs.w	1

v_objstate		rs.b	$102

LSD_MODE		EQU	0
RAVE_MODE		EQU	1
