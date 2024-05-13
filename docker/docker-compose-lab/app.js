const appName = process.env.APP_NAME || "UNKNOWN";
const environment = process.env.ENVIRONMENT || "UNKNOWN";

console.log(`Running ${appName} in ${environment} environment.`);
