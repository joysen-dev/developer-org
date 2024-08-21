global class HourlyScheduler implements Schedulable {
    global void execute(SchedulableContext ctx) {
        // Your logic here
        System.debug('Hourly scheduler executed at: ' + Datetime.now());
    }
}