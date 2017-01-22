package main

import (
	"bytes"
	"encoding/binary"
	"io/ioutil"
)

func main() {
	var num int32
	buf, _ := ioutil.ReadFile("gongaImage")
	buf2 := bytes.NewReader(buf)
	pos := 0
	for buf2.Len() > 0 {
		binary.Read(buf2, binary.LittleEndian, &num)
		print(num)
		print(" ")
		pos += 1
		if pos == 10 {
			pos = 0
			println("")
		}
	}
}
