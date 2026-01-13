export const handler = async (event) => {
  // Simple lambda behind api gateway - GET
  const body = {
    status: "success",
    message: "Hello! Your GET request is successfully retrived",
  };

  const response = {
    statusCode: 200,
    body: JSON.stringify(body),
  };

  return response;
};
