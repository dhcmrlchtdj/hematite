# license

---

https://opensource.org/licenses
http://en.swpat.org/wiki/Patent_clauses_in_software_licences
http://en.swpat.org/wiki/GPLv2_and_patents
http://en.swpat.org/wiki/Implicit_patent_licence
https://www.cncf.io/blog/2017/02/01/cncf-recommends-aslv2/
https://medium.com/@dwalsh.sdlr/react-facebook-and-the-revokable-patent-license-why-its-a-paper-25c40c50b562
https://opensource.stackexchange.com/questions/1881/against-what-does-the-apache-2-0-patent-clause-protect

---

最近 react 专利条款的事情闹得沸沸扬扬，也算是学到了一点东西。
原来一直以为 MIT 是最宽松的开源协议了，没意识到代码之外还有专利的问题。
相比之下，apache2 会同时给代码和专利的授权，怼用户来说算是更有保证的协议了。

---

其实 facebook 那个事情根本无解吧。
在 facebook 之类的大公司申请到相关专利的时候，这事情就注定只有悲剧收场了。

假设 facebook 持有 react 相关的专利 X。
看 X 的影响范围，其他类似框架可能全部侵权。
如果改成 MIT，那么 react 本身可能也侵权。
即使是之前的 BSD+patent，照样存在风险。
（唯一的办法就是自己也持有一堆专利，然后和 facebook 互怼？

---

## patent

---

- implicit patent licence
    - MIT
    - GPLv2
- explicit patent licence
    - Apache-2
    - MPL-2
    - GPLv3

在使用这些协议的时候，就算默认将专利授权给用户了。
不过 GPLv2 和 MIT 都比较含糊，没下面的协议那么明确。

---

apache2 除了 patent grant，还有 patent retaliation 的条款。
