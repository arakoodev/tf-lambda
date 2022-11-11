exports.handler = async (event) => {
  const prefix = event.requestContext.domainPrefix;

   // Example of a redirect
  if (prefix === "cabana")  {
      const response = {
          statusCode: 301,
          headers: {
              Location: 'http://codingcabana.com/'
          }
      };
      return response;
  }
  
  // Returns your slug + a message back to the requestor
  return {
      slugToUse: prefix,
      lol: "this is a demo!"
  };
};