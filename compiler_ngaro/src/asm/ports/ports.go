package ports

import (
	"asm"
)

// 5 cells
func SetPort(value int32, port int32) {
	asm.LIT(value)
	asm.LIT(port)
	asm.OUT()
}

// 3 cells
func GetPort(port int32) {
	asm.LIT(port)
	asm.IN()
}

// 14 cells
func SetWaitRead(value int32, port int32) {
	SetPort(value, port)
	EVENT_WAIT()
	GetPort(port)
}

// 6 cells
func EVENT_WAIT() {
	SetPort(0, 0)
	asm.WAIT()
}

func KEYBOARD_READ() {
	SetWaitRead(1, 1)
}

// 11 cells
func CHARACTER_GENERATOR() {
	SetPort(1, 2)
	EVENT_WAIT()
}

func SCREEN_CLEAR() {
	asm.LIT(-1)
	CHARACTER_GENERATOR()
}

func UPDATE_VIDEO() {
	SetPort(0, 3)
}

func SAVE_IMAGE() {
	SetPort(1, 4)
	EVENT_WAIT()
}

// takes adress of filename string
func INCLUDE_FILE() {
	SetPort(2, 4)
	EVENT_WAIT()
}

const (
	Reading = iota
	Writing
	Append
	Modification
)

// takes adress of filename string, mode
func OPEN_FILE() {
	SetWaitRead(-1, 4)
	// returns handle, zero == fail
}

// takes handle
func READ_BYTE() {
	SetWaitRead(-2, 4)
	// returns byte
}

// takes byte, handle
func WRITE_BYTE() {
	SetWaitRead(-3, 4)
	// returns flag == 1 if success
}

// takes handle
func CLOSE_FILE() {
	SetWaitRead(-4, 4)
	// returns 0 if success
}

// takes handle
func TELL_FILE() {
	SetWaitRead(-5, 4)
	// returns current position
}

// takes offset, handle
func SEEK_FILE() {
	SetWaitRead(-6, 4)
	// returns flag
}

// takes handle
func FILE_SIZE() {
	SetWaitRead(-7, 4)
	// returns file size
}

// takes adress to filename string
func DELETE_FILE() {
	SetWaitRead(-8, 4)
	// returns flag, -1 - deleted, 0 failed
}

func CHECK_MEMORY_SIZE() {
	SetWaitRead(-1, 5)
}

func CHECK_CANVAS() {
	SetWaitRead(-2, 5)
}

func CHECK_CANVAS_WIDTH() {
	SetWaitRead(-3, 5)
}

func CHECK_CANVAS_HEIGHT() {
	SetWaitRead(-4, 5)
}

func CHECK_DATA_DEPTH() {
	SetWaitRead(-5, 5)
}

func CHECK_ADRESS_DEPTH() {
	SetWaitRead(-6, 5)
}

func CHECK_MOUSE() {
	SetWaitRead(-7, 5)
}

func CHECK_TIME() {
	SetWaitRead(-8, 5)
}

func EXIT_VM() {
	SetPort(-9, 5)
}

// takes adress of buffer, adress of query string
func GET_ENVVAR() {
	SetWaitRead(-10, 5)
}

func CHECK_CONSOLE_WIDTH() {
	SetWaitRead(-11, 5)
}

func CHECK_CONSOLE_HEIGTH() {
	SetWaitRead(-12, 5)
}

func CHECK_BITNESS() {
	SetWaitRead(-13, 5)
	// 0 - 32 bit
}

func CHECK_ENDIANESS() {
	SetWaitRead(-14, 5)
	// 0 - Little Endian, 1 - Big Endian
}

func CHECK_ENHANCED_TEXT_CONSOLE() {
	SetWaitRead(-15, 5)
}

func CHECK_DATA_MAX_DEPTH() {
	SetWaitRead(-16, 5)
}

func CHECK_ADRESS_MAX_DEPTH() {
	SetWaitRead(-17, 5)
}

const (
	Black = iota
	DarkBlue
	DarkGreen
	DarkCyan
	DarkRed
	Purple
	Brown
	DarkGray
	Gray
	Blue
	Green
	Cyan
	Red
	Magenta
	Yellow
	White
)

// takes color
func SET_COLOR() {
	SetPort(1, 6)
}

// takes y, x
func DRAW_PIXEL() {
	SetPort(2, 6)
}

// takes width, height, y, x
func DRAW_RECTANGLE() {
	SetPort(3, 6)
}

// takes width, height, y, x
func DRAW_FILLED_RECTANGLE() {
	SetPort(4, 6)
}

// takes height, y, x
func DRAW_VERTICAL_LINE() {
	SetPort(5, 6)
}

// takes width, y, x
func DRAW_HORIZONTAL_LINE() {
	SetPort(6, 6)
}

// takes diameter, y, x
func DRAW_CIRCLE() {
	SetPort(7, 6)
}

// takes diameter, y, x
func DRAW_FILLED_CIRCLE() {
	SetPort(8, 6)
}

func MOUSE_COORDINATES() {
	SetPort(1, 7)
	EVENT_WAIT()
	//Pushes X,Y on data stack
}

func MOUSE_PRESSED() {
	SetPort(2, 7)
	//Pushes 0 if false, nonzero if true
}

// takes column, row
func CONSOLE_MOVE() {
	SetPort(1, 8)
}

// takes color
func CONSOLE_FOREGROUND_COLOR() {
	SetPort(2, 8)
}

// takes color
func CONSOLE_BACKGROUND_COLOR() {
	SetPort(3, 8)
}
