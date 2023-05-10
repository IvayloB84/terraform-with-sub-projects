const AWS = require('aws-sdk');
AWS.config.update({ region: 'us-west-2' });

exports.handler = async (event, context) => {
    console.log(JSON.stringify(event))
    
    return "Nice or not.....?"
};