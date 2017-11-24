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

	private static final String PLOTS_PATH = "src/plots/";

	private static void sdNExperiment() throws IOException, InterruptedException {
		String experimentPath = PLOTS_PATH + "sd_n";
		String dataPath = experimentPath + "data/";

		String header = "# stockDrugs order\n";
		int costStorage = 5;

		System.out.println("Experiments SD/N started");
		for (int n = 0; n <= 40; n = n + 10) {
			System.out.println("\tExperiment N=" + n + " started");
			Path dat = Paths.get(dataPath + "n" + n + ".dat");
			Files.write(dat, header.getBytes(), CREATE, TRUNC);
			for (int sd = 0; sd <= 40; sd++) {
				System.out.print("\t\tstockDrugs=" + sd + " started...");
				int orderAmount = Utils.runPrism(costStorage, sd, n);
				Files.write(dat, (sd + " " + orderAmount + "\n").getBytes(), APP);
				System.out.println(" done!");
			}
			System.out.println("\tExperiment N=" + n + " finished");
		}
		System.out.println("Experiments SD/N finished");
	}

	private static void sdCostStorageExperiment(int maxCS) throws IOException, InterruptedException {
		String experimentPath = PLOTS_PATH + "sd_costStorage_0-" + maxCS + "/";
		String dataPath = experimentPath + "data/";

		String header = "# stockDrugs order\n";
		int n = 20;

		System.out.println("Experiments SD/costStorage(0-" + maxCS + ") started");
		for (int costStorage = 0; costStorage <= maxCS; costStorage = costStorage + (maxCS / 4)) {
			System.out.println("\tExperiment costStorage=" + costStorage + " started");
			Path dat = Paths.get(dataPath + "costStorage" + costStorage + ".dat");
			Files.write(dat, header.getBytes(), CREATE, TRUNC);
			for (int sd = 0; sd <= 40; sd++) {
				System.out.print("\t\tstockDrugs=" + sd + " started...");
				int orderAmount = Utils.runPrism(costStorage, sd, n);
				Files.write(dat, (sd + " " + orderAmount + "\n").getBytes(), APP);
				System.out.println(" done! OptimalOrder=" + orderAmount);
			}
			System.out.println("\tExperiment costStorage=" + costStorage + " finished");
		}
		System.out.println("Experiments SD/costStorage(0-" + maxCS + ") finished");
	}

	public static void main(String[] args) throws IOException, InterruptedException {
		sdNExperiment();
		sdCostStorageExperiment(20);
		sdCostStorageExperiment(40);
	}
}
