const moment = require('moment');
exports.handler = (event, context, callback) => {

  const date1 = moment(event["queryStringParameters"]["date1"].split('-'));
  const date2 = moment(event["queryStringParameters"]["date2"].split('-'));
//Commented on 15.06.2023 just now 
    const diff = date2.diff(date1, 'days');

  var response = {
     statusCode: 200,
     headers: {
       'Content-Type': 'application/json',
     },
     body: JSON.stringify(
      diff
     ),
   }
  callback(null, response) 
};