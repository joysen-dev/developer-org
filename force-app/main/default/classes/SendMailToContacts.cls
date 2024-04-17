public with sharing class SendMailToContacts {
    public SendMailToContacts() {}

    @InvocableMethod(label='Send Mail To Selected Contacts' description='Sending mail to all the unique Emials Selected From Flow' category='Custom Apex')
    public static List<Boolean> sendMail(List<Parameter> inputs){
        Boolean isSent;

        List<String> emails = new List<String>(inputs[0].mails);
        List<Contact> contacts = new List<Contact>(inputs[0].contacts);

        // Making Map Start //
        Map<String, Contact> emailToContactMap = new Map<String, Contact>();
        for (Contact contact : contacts) {
            if (emails.contains(contact.Email)) {
                emailToContactMap.put(contact.Email, contact);
            }
        }
        System.debug('emailToContactMap : ' + emailToContactMap);
        // Making Map End //

        // Define an Email object array to hold multiple emial object
        Messaging.SingleEmailMessage[] messages = new List<Messaging.SingleEmailMessage>();
        
        for(String mail : emailToContactMap.keySet()){
            // Define an Email object
            Messaging.SingleEmailMessage message = new Messaging.SingleEmailMessage();

            message.setTargetObjectId(emailToContactMap.get(mail).Id);
            message.setSenderDisplayName('Salesforce Marketing Team'); 
            message.setReplyTo('joysendev.official@gmail.com');
            message.setUseSignature(false); 
            message.setBccSender(false); 
            message.setSaveAsActivity(false); 
            EmailTemplate emailTemplate = [Select Id,Subject,Description,HtmlValue,DeveloperName,Body from EmailTemplate where name = 'Send Mail to Contacts Related to Account'];
            message.setTemplateID(emailTemplate.Id); 
            message.setWhatId(emailToContactMap.get(mail).AccountId); //This is important for the merge fields in template to work
            message.toAddresses = new String[] {mail};

            messages.add(message);
        }
        // Sending Mails
        Messaging.SendEmailResult[] results = Messaging.sendEmail(messages);
            
        if (results[0].success) {
            System.debug('The email was sent successfully.');
            isSent = true;
        } else {
            System.debug('The email failed to send: ' +  results[0].errors[0].message);
            isSent = false;
        }

        System.debug('hello');
        return new List<Boolean> {isSent};
    }

    public class Parameter{
        @InvocableVariable(label = 'Selected Unique Mails')
        public List<String> mails;
        @InvocableVariable(label = 'Selected Contacts')
        public List<Contact> contacts;
    }
}