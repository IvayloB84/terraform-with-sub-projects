console.log('Loading function');

exports.handler = async (event, context) => {
    //console.log.1 ('Received event:', JSON.stringify(event, null, 2));
    console.log('value1 =', event.key1);
    console.log('value2 =', event.key2);     
    console.log('value3 =', event.key3);
    return event.key1;  //Echo back the first key value
    // throw new Error('New update of the lambda layer with function new +');
};