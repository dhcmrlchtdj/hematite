# SVG table

---

http://stackoverflow.com/questions/6987005/create-a-table-in-svg
https://developer.mozilla.org/en-US/docs/Web/SVG/Element/foreignObject
http://svg-whiz.com/svg/table.svg

---

一种是 `foreignObject`，用起来比较熟悉……

```svg
<svg xmlns="http://www.w3.org/2000/svg">
	<foreignObject x="0" y="0" width="100" height="100">
		<body xmlns="http://www.w3.org/1999/xhtml">
			<table>
			<!-- ... -->
			</table>
		</body>
	</foreignObject>
</svg>
```

不过要在 chrome 下展示，要套个 html 的外壳

```html
<!DOCTYPE html>
<html>
	<body>
		<svg xmlns="http://www.w3.org/2000/svg">
			<foreignObject x="0" y="0" width="100" height="100">
				<body xmlns="http://www.w3.org/1999/xhtml">
					<table>
					<!-- ... -->
					</table>
				</body>
			</foreignObject>
		</svg>
	</body>
</html>
```

---

一种是直接画 svg，如果有比较好的库，应该也行。
不太懂 SVG，不趟这浑水了……
