package ssin

import (
	"bufio"
	"fmt"
	"log"
	"os"
	"os/exec"
	"strings"
	)
	
func main() {
	file, err := os.Open(os.Args[1])
	if err != nil {
		log.Fatal(err)
		}
	defer file.Close()
	
	scanner := bufio.NewScanner(file)
	
	var i int = 1
	for scanner.Scan(){
		fmt.Printf("%d: " + scanner.Text() + " -- ", i)
		out, _ := exec.Command("ping", scanner.Text(), "-c 5", "-i 3", "-w 10").Output()
		if (strings.Contains(string(out), "TTL")) {
			fmt.Println("It's alive.\n")
			}
			else {
			fmt.Println("It's down.\n")
			}
			i = i + 1
			}
	if err := scanner.Err(); err != nil {
		log.Fatal(err)
		}
	}