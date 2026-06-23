import express from "express";

import expressionsRoutes
from "./routes/expressions.routes.js";

import { initializedDatabase }
from "./db/init.js";

initializedDatabase();

const app = express();

app.use(express.json());

app.use(
    "/expressions",
    expressionsRoutes
);

app.listen(3000, () => {
    console.log(
        "Server listening on port 3000"
    );
});