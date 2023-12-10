; MMIO registers
; Memory-Mapped Input/Output registers
PPUCTRL   = $2000
PPUMASK   = $2001
PPUSTATUS = $2002
PPUADDR   = $2006
PPUDATA   = $2007

.segment "HEADER"
;            EOF
.byte "NES", $1A
.byte 2         ; Number of 16KB PRG-ROM banks
.byte 1         ; Number of 8KB CHR-ROM banks
.byte %00000001 ; Vertical mirroring, no save RAM, no mapper
.byte %00000000 ; No special-case flags set, no mapper
.byte 0         ; No PRG-RAM present
.byte %00000000 ; NTSC format

.segment "CHR"
.res 8 * 1024 ; Fill CHR ROM with zeroes (8 KiB)
; so, all tiles will use the background color (index 0)

.segment "CODE"
.export irq_handler
.proc irq_handler ; 6502 requires this handler
  RTI ; Just exit, we have no use for this handler in this program.
.endproc

.export nmi_handler
.proc nmi_handler ; 6502 requires this handler
  RTI ; Just exit, we have no use for this handler in this program.
.endproc

.export reset_handler
.proc reset_handler ; 6502 requires this handler
  SEI ; Deactivate IRQ (non-NMI interrupts)
  CLD ; Deactivate non-existing decimal mode
  ; NES CPU is a MOS 6502 clone without decimal mode
  LDX #%00000000
  STX PPUCTRL ; PPU is unstable on boot, ignore NMI for now
  STX PPUMASK ; Deactivate PPU drawing, so CPU can safely write to PPU's VRAM
  vblankwait1: ; PPU unstable on boot, wait for vertical blanking
    BIT PPUSTATUS ; Clear the vblank flag and the address latch
    BPL vblankwait1
  vblankwait2: ; PPU still unstable, wait for another vertical blanking
    BIT PPUSTATUS ; Clear the vblank flag and the address latch
    BPL vblankwait2
  ; PPU should be stable enough now

  ; Background color (index 0 of first color palette)
  ; is at PPU's VRAM address 3f00
  ; CPU registers size is 1 byte, but addresses size is 2 bytes
  LDX PPUSTATUS ; Clear address latch,
  ; so the next write to PPUADDR is taken as the VRAM's address high byte
  ; First, we need the high byte of 3f00
  ;                                 ^^
  LDX #$3f
  STX PPUADDR ; (this also sets the address latch,
  ; so the next write to PPUADDR is taken as the VRAM's address low byte)
  ; Then, the low byte of  3f00
  ;                          ^^
  LDX #$00
  STX PPUADDR ; (this also clears the address latch)
  ; Finally, we need the index of a PPU's internal color
  LDA #$29 ; light green in this case
  STA PPUDATA

  ;     BGRsbMmG
  LDA #%00001000
  STA PPUMASK ; Enable background drawing

  forever:
    JMP forever ; Make CPU wait forever, while PPU keeps drawing frames forever
.endproc

.segment "VECTORS" ; 6502 requires this segment
.addr nmi_handler, reset_handler, irq_handler
