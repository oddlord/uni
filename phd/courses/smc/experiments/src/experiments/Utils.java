package experiments;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Paths;
import java.util.List;

public class Utils {
	private static void deleteFile(String path) {
		File file = new File(path);

		if (!file.delete()) {
			System.out.println("Failed to delete the file");
		}
	}

	private static String readFileLine(String path, int lineIndex) throws IOException {
		List<String> allLines = Files.readAllLines(Paths.get(path));
		return allLines.get(lineIndex);
	}

	private static String OS = System.getProperty("os.name").toLowerCase();

	public static boolean isUnix() {
		return (OS.indexOf("nix") >= 0 || OS.indexOf("nux") >= 0 || OS.indexOf("aix") > 0);
	}

	public static boolean isMac() {
		return (OS.indexOf("mac") >= 0);
	}

	public static boolean isWindows() {
		return (OS.indexOf("win") >= 0);
	}

	public static void gnuPlot(String outputFolder, String gnuName) throws IOException {
		Runtime rt = Runtime.getRuntime();

		String gnuFile = gnuName + ".gnu";

		String command;
		if (isMac()) {
			command = "/usr/local/bin/gnuplot " + outputFolder + gnuFile;
		} else if (isUnix()) {
			command = "gnuplot " + outputFolder + gnuFile;
		} else if (isWindows()) {
			command = "\"C:\\Program Files (x86)\\gnuplot\\bin\\gnuplot\" " + outputFolder + gnuFile;
		} else {
			throw new RuntimeException("Unsupported operative system!");
		}

		Process exec = rt.exec(command);
		try {
			exec.waitFor();
			System.out.println("Plot written in " + gnuName + ".pdf");
		} catch (InterruptedException e) {
			System.out.println("gnuplot error!");
			e.printStackTrace();
		}
	}

	public static int runPrism(int initialSD, int initialN) throws IOException, InterruptedException {
		Runtime rt = Runtime.getRuntime();

		String experimentsPath = "src/experiments/";
		String modelPath = experimentsPath + "ward_mdp.sm";
		String advTraPath = experimentsPath + "adv.tra";
		String advStaPath = experimentsPath + "adv.sta";
		String advLabPath = experimentsPath + "adv.lab";

		String command = "\"C:\\Program Files\\prism-4.3.1\\bin\\prism.bat\" " + modelPath
				+ " -pf \"R{\\\"totalCost\\\"}min=? [ F day=3 ]\"" + " -exportadvmdp " + advTraPath + " -exportstates "
				+ advStaPath + " -exportlabels " + advLabPath + " -const initialSD=" + initialSD + ",initialN="
				+ initialN;

		Process exec = rt.exec(command);
		exec.waitFor();

		String initLabLine = readFileLine(advLabPath, 1);
		int initLab = Integer.parseInt(initLabLine.split(":")[0]);

		String orderLabel = "";
		List<String> traLines = Files.readAllLines(Paths.get(advTraPath));
		for (String line : traLines) {
			String[] elements = line.split(" ");
			if (initLab == Integer.parseInt(elements[0])) {
				orderLabel = elements[4];
				break;
			}
		}

		int orderAmount;
		if (orderLabel.equals("noOrder")) {
			orderAmount = 0;
		} else {
			orderAmount = Integer.parseInt(orderLabel.replace("order", ""));
		}

		deleteFile(advTraPath);
		deleteFile(advStaPath);
		deleteFile(advLabPath);

		return orderAmount;
	}
}
