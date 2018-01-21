private void ieSelectionChanged(int i) {
	if (tmp >= 0) {
		aColor[tmp] = getResource("aColor");
	}
	aColor[i] = getResource("currentMinimumColor");
	tmp = i;
	aDrawer.startStep(step++);
	aDrawer.draw(aIndex, aColor, getResource("ieSelectionChanged"));
	pseudocodeDrawerUtility.draw("", new int[] { 6, 7 });
	aDrawer.endStep();
}