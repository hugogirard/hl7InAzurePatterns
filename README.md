## Call Soap Service

You can use this payload to call the SOAP Service

```
<?xml version="1.0" encoding="utf-8"?>
<Envelope xmlns="http://schemas.xmlsoap.org/soap/envelope/">
    <Body>
        <ReceiveHL7Message xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns="http://tempuri.org/">
        <hl7Message>
            <Message xmlns="http://schemas.datacontract.org/2004/07/">Message1</Message>
        </hl7Message>
        </ReceiveHL7Message>
    </Body>
</Envelope>
```