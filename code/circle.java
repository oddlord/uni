private static void drawCircle(double topLeftX, double topLeftY, double width, double height, String color, String font, double lineThickness, String value) throws IOException {

	updateLineWidth(lineThickness);
	updateStrokeStyle("000000");
	updateFillStyle(color);
	bw.write("\t\t\t\tctx.beginPath();\n"
			+ "\t\t\t\tctx.arc(" + (topLeftX + width / 2) + ", " + (topLeftY + height / 2) + ", " + width / 2 + ", 0, 2*Math.PI, false);\n"
			+ "\t\t\t\tctx.fill();\n"
			+ "\t\t\t\tctx.stroke();\n");

	if (color.equals("000000")) {
		updateFillStyle("FFFFFF");
	} else {
		updateFillStyle("000000");
	}
	updateTextAlign("center");
	updateTextBaseline("middle");
	updateFont(font);
	scaleAndDrawText(value, font, width, height, (topLeftX + width / 2),
			(topLeftY + height / 2));

	bw.write("\t\t\t\tctx.closePath();\n");
	updateDimensions(false, (topLeftX + width / 2), (topLeftY + height / 2));
}