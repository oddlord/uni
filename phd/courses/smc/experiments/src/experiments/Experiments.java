package experiments;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.nio.file.StandardOpenOption;

public class Experiments {
	private static final StandardOpenOption CREATE = StandardOpenOption.CREATE;
	private static final StandardOpenOption TRUNC = StandardOpenOption.TRUNCATE_EXISTING;
	private static final StandardOpenOption APP = StandardOpenOption.APPEND;

	public static void main(String[] args) throws IOException, InterruptedException {
		String plotsPath = "src/plots/";
		String dataPath = plotsPath + "data/";

		String header = "# stockDrugs order\n";

		System.out.println("Experiments started");
		for (int n = 0; n <= 40; n = n + 10) {
			System.out.println("\tExperiment N=" + n + " started");
			Path dat = Paths.get(dataPath + "n" + n + ".dat");
			Files.write(dat, header.getBytes(), CREATE, TRUNC);
			for (int sd = 0; sd <= 40; sd++) {
				System.out.print("\t\tstockDrugs=" + sd + " started...");
				int orderAmount = Utils.runPrism(sd, n);
				Files.write(dat, (sd + " " + orderAmount + "\n").getBytes(), APP);
				System.out.println(" done!");
			}
			System.out.println("\tExperiment N=" + n + " finished");
		}
		System.out.println("Experiments finished");
	}
}
