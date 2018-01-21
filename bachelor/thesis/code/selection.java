Array<I> a;
private int i, indiceMinimo, j, n;
private I minimo;
VisualSelectionSort vss;

private void selectionSort() {
	vss.init();
	vss.ieStart();
	for (i = 0; i < n; i++) {
		minimo = a.elementAt(i);
		indiceMinimo = i;
		vss.ieSelectionStarted(i);
		for (j = i + 1; j < n; j++) {
			if (a.elementAt(j).isLessThan(minimo)) {
				minimo = a.elementAt(j);
				indiceMinimo = j;
				vss.ieSelectionChanged(j);
			}
		}
		vss.ieSwapToBeDone();
		a.setAt(a.elementAt(i), indiceMinimo);
		a.setAt(minimo, i);
		vss.ieSwapDone(i);
	}
	vss.ieEnd();
}