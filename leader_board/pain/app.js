
//The URL to which we will send the request
const url = 'http://127.0.0.1:5000/board/';

const getData = async () => {
    //Perform a GET request to the url
    try {
        const response = await fetch(url, {"Content-Type":"application/json"})
        return response.data

    }
    catch (error) {
        //When unsuccessful, print the error.
        console.log(error);
    }
    // This code is always executed, independent of whether the request succeeds or fails.
};

const load = async () => {
	const data = await getData()
	console.log(data)
}