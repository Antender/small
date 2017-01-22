package main

import (
	"asm"
	"asm/ports"
	"bufio"
	"os"
	"unicode"
)

var lookahead rune // Lookahead Character
var reader *bufio.Reader = bufio.NewReader(os.Stdin)

// Read New Character From Input Stream
func getChar() {
	lookahead, _, _ = reader.ReadRune()
}

// Report an Error

func error(s string) {
	println()
	println("Error: " + s + ".")
}

// Report Error and Halt

func abort(s string) {
	error(s)
	os.Exit(1)
}

// Report What Was Expected

func expected(s string) {
	abort(s + " Expected")
}

// Match a Specific Input Character

func match(x rune) {
	if lookahead == x {
		getChar()
	} else {
		expected("\"" + string(x) + "\"")
	}
}

// Get an Identifier

func getName() rune {
	if !unicode.IsLetter(lookahead) {
		expected("Name")
	}
	temp := lookahead
	getChar()
	return temp
}

// Get a Number

func getNum() rune {
	if !unicode.IsDigit(lookahead) {
		expected("Integer")
	}
	temp := lookahead
	getChar()
	return temp
}

// Initialize
func genPrintNumber() {
	asm.DUP()
	asm.LIT(-1)
	asm.GT_JUMP(asm.Position + 19)
	asm.LIT(45)
	ports.CHARACTER_GENERATOR()
	asm.LIT(-1)
	asm.XOR()
	asm.INC()
	asm.LIT(0)
	asm.PUSH()
	loopStart := asm.Position
	asm.LIT(10)
	asm.DIVMOD()
	asm.POP()
	asm.INC()
	asm.PUSH()
	asm.INC()
	asm.LOOP(loopStart)
	asm.POP()
	loopStart = asm.Position
	asm.PUSH()
	asm.LIT(48)
	asm.ADD()
	ports.CHARACTER_GENERATOR()
	asm.POP()
	asm.LOOP(loopStart)
}

func main() {
	asm.Init()
	getChar()
	expression()
	genPrintNumber()
	ports.EXIT_VM()
	asm.End()
}

func factor() {
	if lookahead == '(' {
		match('(')
		expression()
		match(')')
	} else {
		asm.LIT(int32(getNum()) - 48)
	}
}

func isAddop() bool {
	return (lookahead == '+') || (lookahead == '-')
}

func expression() {
	if isAddop() {
		asm.LIT(0)
	} else {
		term()
	}
	for isAddop() {
		switch lookahead {
		case '+':
			{
				add()
			}
		case '-':
			{
				substract()
			}
		default:
			{
				expected("Addop")
			}
		}
	}
}

func add() {
	match('+')
	term()
	asm.ADD()
}

func substract() {
	match('-')
	term()
	asm.SUBSTRACT()
}

func multiply() {
	match('*')
	factor()
	asm.MULTIPLY()
}

func divide() {
	match('/')
	factor()
	asm.DIVMOD()
	asm.DROP()
}

func term() {
	factor()
	for (lookahead == '*') || (lookahead == '/') {
		switch lookahead {
		case '*':
			{
				multiply()
			}
		case '/':
			{
				divide()
			}
		default:
			expected("Mulop")
		}
	}
}
