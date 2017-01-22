package main

import "math/rand"
import "time"
import "fmt"

const numberSize = 4

func makeANumber() []int {
	rand.Seed(int64(time.Now().Nanosecond()))
	return rand.Perm(10)[:numberSize]
}

func bullsCows(number []int, guess []int) (bulls int, cows int) {
	for i := 0; i < numberSize; i++ {
		for j := 0; j < numberSize; j++ {
			if guess[i] == num ber[j] {
				if i == j {
					bulls++
				} else {
					cows++
				}
				break
			}
		}
	}
	return
}

func main() {
	var number = makeANumber()
	var bulls int
	var cows int
	var guess int
	for bulls != numberSize {
		print("Guess the number:")
		fmt.Scanf("%d\n", &guess)
		var buffer [numberSize]int
		for i := 0; i < numberSize; i++ {
			buffer[i] = guess % 10
			guess = guess / 10
		}
		bulls, cows = bullsCows(number, buffer[:])
		println("bulls:", bulls, ",cows:", cows)
	}
}