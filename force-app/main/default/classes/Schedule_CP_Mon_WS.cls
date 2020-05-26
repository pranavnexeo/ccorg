global class Schedule_CP_Mon_WS implements Schedulable {
    global void execute(SchedulableContext sc) {
		System.enqueueJob(new CP_Mon_Queueable());
    }
}