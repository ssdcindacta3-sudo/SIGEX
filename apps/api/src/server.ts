import { createServer } from "node:http";

const server = createServer((_request, response) => {
  response.writeHead(200, { "content-type": "application/json; charset=utf-8" });
  response.end(JSON.stringify({
    service: "SIGEX API",
    status: "ok",
    version: "0.1.0"
  }));
});

const port = Number(process.env.PORT ?? 3000);
server.listen(port, () => {
  console.log(`SIGEX API listening on port ${port}`);
});
