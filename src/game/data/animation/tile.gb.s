; animations
; - target tile in vram
; - animation delay in frames
; - animation frame indexes from animation buffer

; Water Top
DB $f0,$03, $00,$01,$02,$03, $00,$00

; Water Bottom
DB $f1,$03, $04,$05,$06,$07, $00,$00

; Waterfall
DB $f2,$03, $08,$09,$0a,$0b, $00,$00
DB $f3,$03, $0c,$0d,$0e,$0f, $00,$00

; Lava Top
DB $f4,$04, $10,$11,$12,$13, $00,$00
DB $f5,$04, $14,$15,$16,$17, $00,$00

; Torch
DB $f6,$04, $18,$19,$1a,$1b, $00,$00

; Waterfall
DB $f7,$03, $1c,$1d,$1e,$1f, $00,$00

; Lava Bottom
DB $f8,$04, $20,$21,$22,$23, $00,$00
DB $f9,$04, $24,$25,$26,$27, $00,$00

; Electricity
DB $fa,$00, $28,$29,$2a,$2b, $00,$00
