package main

import (
	"github.com/go-faker/faker/v4"
        "fmt"
        "github.com/aws/aws-lambda-go/lambda"
)

type MyEvent struct {
        Name string `json:"What is your name?"`
        Age int     `json:"How old are you?"`
}

type MyResponse struct {
        Message string `json:"Answer:"`
}

func HandleLambdaEvent(event MyEvent) (MyResponse, error) {
	fmt.Println(faker.FirstName())
	fmt.Println(faker.LastName())
	fmt.Println(faker.Phonenumber())
	fmt.Println(faker.Word())

        return MyResponse{Message: fmt.Sprintf("%s is %d years old!", event.Name, event.Age)}, nil
}

func main() {
        lambda.Start(HandleLambdaEvent)
}
