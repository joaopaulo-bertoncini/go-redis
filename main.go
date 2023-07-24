package main

import (
	"fmt"

	"github.com/go-redis/redis"
)

func main() {
	client := redis.NewClient(&redis.Options{
		Addr:     "localhost:6379",
		Password: "", // no password set
		DB:       0,  // use default DB
	})

	// Ping Redis to check if the connection is working
	_, err := client.Ping().Result()
	if err != nil {
		panic(err)
	}

	// Set a key-value pair
	err = client.Set("mykey", "myvalue", 0).Err()
	if err != nil {
		panic(err)
	}

	// Retrieve a value for a given key
	val, err := client.Get("mykey").Result()
	if err != nil {
		panic(err)
	}
	fmt.Println("mykey", val)
}
