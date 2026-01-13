export const handler = async (event = {}) => {
  const name = event?.name ?? event?.queryStringParameters?.name;

  if (!name) {
    return {
      statusCode: 400,
      body: JSON.stringify({ message: "Missing 'name' parameter" }),
    };
  }

  const processedName = `processed_${name}`;

  return {
    statusCode: 200,
    body: JSON.stringify(`Hello, ${processedName}`),
  };
};
