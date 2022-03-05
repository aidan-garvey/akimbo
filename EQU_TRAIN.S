CIN_TRAIN_TIMER = $FF1C00
CIN_TRAIN_VEL = $FF1C04     ; velocity of train
CIN_BACK_VEL = $FF1C06      ; velocity of background
; offsets in BUFF_PLANE for top-left of each
; train car (add $80 to jump a whole row)
BUFF_TRAINCAR_1 = BUFF_PLANE+$C00
BUFF_TRAINCAR_2 = BUFF_PLANE+$C20
BUFF_TRAINCAR_3 = BUFF_PLANE+$C40
BUFF_TRAINCAR_4 = BUFF_PLANE+$C60

TRAIN_MAXSPEED = 32
BACK_MAXSPEED = 32
