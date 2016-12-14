import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;
import java.util.List;

import au.com.bytecode.opencsv.CSVReader;
import au.com.bytecode.opencsv.CSVWriter;

public class ProcessCSV {

	public static long getAbsolute(String[] row) {
		long absolute;

		absolute = ((Long.parseLong(row[4]) * 60 + Long.parseLong(row[5])) * 60 + Long
				.parseLong(row[6])) * 1000000 + Long.parseLong(row[7]);

		return absolute;
	}

	public static long getFirstMsg(String exp_id, String msg,
			List<String[]> list) {
		long min = Long.MAX_VALUE;
		long min_temp;
		for (String[] row : list) {
			if (row[1].equals(exp_id) && row[9].equals(msg)) {
				min_temp = getAbsolute(row);
				if (min_temp < min)
					min = min_temp;
			}
		}
		return min;
	}

	public static long getFirstAlert(String exp_id, List<String[]> list) {
		long min = Long.MAX_VALUE;
		long min_temp;
		for (String[] row : list) {
			if (row[1].equals(exp_id) && !row[9].equals("PACKET SENT")
					&& !row[9].equals("PACKET RECEIVED")
					&& row[17].equals("IDS")) {
				min_temp = getAbsolute(row);
				if (min_temp < min)
					min = min_temp;
			}
		}
		return min;
	}

	public static long getLastMsg(String exp_id, String msg, List<String[]> list) {
		long max = 0;
		long max_temp;
		for (String[] row : list) {
			if (row[1].equals(exp_id) && row[9].equals(msg)) {
				max_temp = getAbsolute(row);
				if (max_temp > max)
					max = max_temp;
			}
		}
		return max;
	}

	public static void writeExperiment(String exp_id, List<String[]> list,
			CSVWriter writer) {

		String msg = "PACKET SENT";
		long first_sent = getFirstMsg(exp_id, msg, list);

		msg = "PACKET RECEIVED";
		long injection = getFirstMsg(exp_id, msg, list);

		long detection = getFirstAlert(exp_id, list);

		long finished = getLastMsg(exp_id, msg, list);

		long duration = finished - first_sent;

		long detection_time;
		if (detection == Long.MAX_VALUE)
			detection_time = -1;
		else
			detection_time = detection - injection;

		long delay = (injection - first_sent);

		for (String[] row : list) {
			if (row[1].equals(exp_id)) {
				String[] new_row = { row[0], row[1], row[2], row[3], row[4],
						row[5], row[6], row[7], row[8], row[9], row[10],
						row[11], row[12], row[13], row[14], row[15], row[16],
						row[17], String.valueOf(first_sent),
						String.valueOf(injection), String.valueOf(detection),
						String.valueOf(finished), String.valueOf(duration),
						String.valueOf(detection_time), String.valueOf(delay) };
				writer.writeNext(new_row);
			}
		}
	}

	public static void main(String[] args) throws IOException {

		CSVReader csv = new CSVReader(new FileReader(
				"C:\\Users\\Tommy\\Uni\\Progetti & Esercizi\\AQS\\log.csv"),
				';');

		List<String[]> list = csv.readAll();

		csv.close();

		CSVWriter writer = new CSVWriter(new FileWriter(
				"C:\\Users\\Tommy\\Uni\\Progetti & Esercizi\\AQS\\log2.csv"),
				';');

		String[] header = { "ID_ALERT", "EXP_ID", "DAY", "MONTH", "HOUR",
				"MINUTE", "SEC", "MICROSEC", "SID", "MSG", "PROTOCOL",
				"FROM_IP", "FROM_PORT", "TO_IP", "TO_PORT", "FROM_MAC",
				"TO_MAC", "ATT_IDS", "FIRST_SENT", "INJECTION", "DETECTION",
				"FINISHED", "DURATION", "DETECTION_TIME", "DELAY" };
		writer.writeNext(header);

		String exp_id;

		exp_id = "metasploit advance";
		writeExperiment(exp_id, list, writer);

		exp_id = "metasploit default";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap default";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap -A";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --min-rate 100";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --min-rate 300";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --min-rate 500";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --osscan-guess";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap -T2";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap -T3";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap -T4";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap -T5";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --version-all";
		writeExperiment(exp_id, list, writer);

		exp_id = "nmap --version-light";
		writeExperiment(exp_id, list, writer);

		exp_id = "ping -i 0.001";
		writeExperiment(exp_id, list, writer);

		exp_id = "ping -i 0.1";
		writeExperiment(exp_id, list, writer);

		exp_id = "ping -i 0.3";
		writeExperiment(exp_id, list, writer);

		exp_id = "ping -i 0.5";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute -I";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute -N 20";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute -N 30";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute -N 40";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute default";
		writeExperiment(exp_id, list, writer);

		exp_id = "traceroute -T";
		writeExperiment(exp_id, list, writer);

		writer.close();
	}
}
