public with sharing class OrderController {

    @InvocableMethod(label='Send mail to Orders' description='Send mails to related orders.')
    public static void main(List<String> recordId){
        sendMailOnContacts(recordId[0]);
    }


    public static void sendMailOnContacts(String recordId) {
        Contact con = [SELECT Name, Email FROM Contact WHERE Id =: recordId];
        List<Order> orders = [SELECT Id, Status, OrderNumber FROM ORDER WHERE CustomerAuthorizedById =: recordId];
 
        String emailBody = createEmailBody(orders, con.Name);
        System.debug('Contact --> ' + con);
        System.debug('emailBody --> ' + emailBody);

        sendEmail(con.Email, emailBody);
    }
 
    public static String createEmailBody(List<Order> orders, String contactName) {
        String emailBody = '<h1>Hello ' + contactName + '</h1>';
 
        Map<String, List<Order>> ordersByStatus = new Map<String, List<Order>>();
        for (Order order : orders) {
            List<Order> ordersForStatus = ordersByStatus.get(order.Status);
            if (ordersForStatus == null) {
                ordersForStatus = new List<Order>();
                ordersByStatus.put(order.Status, ordersForStatus);
            }
            ordersForStatus.add(order);
        }
 
        Integer sectionCount = 1;
        for (String status : ordersByStatus.keySet()) {
            emailBody += 'The following orders are ' + status + ':\n <br>';
 
            Integer orderCount = 1;
            for (Order order : ordersByStatus.get(status)) {
                emailBody += '' + orderCount + ': ' + order.OrderNumber + '. ' + getOrderLink(order.Id) + '<br>';
                orderCount++;
            }
 
            emailBody += '\n\n<br><br>';
            sectionCount++;
        }
 
        return emailBody;
    }
 
    private static String getOrderLink(Id orderId) {
        return 'https://twinforcesolutions8-dev-ed.develop.lightning.force.com/' + orderId;
    }

    public static Messaging.SingleEmailMessage initEmail(String recipientEmail, String emailBody) {
        EmailTemplate emailTemplate = [SELECT Id, Subject, Description, HtmlValue, DeveloperName, Body FROM EmailTemplate WHERE DeveloperName = 'Order_Details' LIMIT 1];

        Messaging.SingleEmailMessage email = new Messaging.SingleEmailMessage();
        email.setTargetObjectId(UserInfo.getUserId());
        email.setReplyTo('no-reply@tmediasales.com');
        email.setTemplateId(emailTemplate.Id);
        email.setToAddresses(new String[]{recipientEmail});
        email.setUseSignature(false);
        email.setSaveAsActivity(false);
        
        SavePoint sp = Database.setSavePoint();
        Messaging.SendEmailResult[] result = Messaging.sendEmail(new Messaging.SingleEmailMessage[]{email});
        Database.rollback(sp);
        
        System.debug('Email--->' + JSON.serializePretty(email));

        return email;
    }

    private static Messaging.SingleEmailMessage editEmailBody(String recipientEmail, String emailBody) {
        Messaging.SingleEmailMessage email = initEmail(recipientEmail, emailBody);

        String mailHtmlBody = email.getHTMLBody();

        mailHtmlBody = mailHtmlBody.replace('{{emailBody}}', emailBody);

        email.setHtmlBody(mailHtmlBody);
        email.setSubject('You have some Orders');
        
        email.setToAddresses(new List<String>{recipientEmail});

        return email;
    }
    
    public static void sendEmail(String recipientEmail, String emailBody) {
        Messaging.SingleEmailMessage email = editEmailBody(recipientEmail, emailBody);
        
        Messaging.SendEmailResult[] results = Messaging.sendEmail(new List<Messaging.SingleEmailMessage>{email});

        if (results[0].success) {
            System.debug('Email sent successfully.');
        } else {
            System.debug('Email failed to send: ' +  results[0].errors[0].message);
        }
    }

 }