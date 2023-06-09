const moment = require('moment');
exports.handler = (event, context, callback) => {

  const date1 = moment(event["queryStringParameters"]["date1"].split('-'));
  const date2 = moment(event["queryStringParameters"]["date2"].split('-'));
//Commented on 27.06.2023 update
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