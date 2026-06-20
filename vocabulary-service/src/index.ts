import express from "express";

const app = express();

app.use(express.json());

app.post("/expressions", (req, res) => {
    console.log(req.body);
    console.log("Received expression:");
    console.dir(req.body, { depth: null });

    res.status(201).json({
        success: true,
    });
});


app.listen(3000, () => {
    console.log("Server listening on port 3000");
});