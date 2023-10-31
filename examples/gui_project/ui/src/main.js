const countBtn = document.getElementById('counter');
const count = countBtn.querySelector('span');
countBtn.addEventListener('click', async () => {
	// Calls a V function that takes an argument and returns a Value.
	const res = await window.increment(Number(count.textContent));
	count.textContent = res;
});
