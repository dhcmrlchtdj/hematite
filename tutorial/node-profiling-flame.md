# node profiling flame

---

http://www.ebaytechblog.com/2016/06/15/igniting-node-js-flames/
http://techblog.netflix.com/2014/11/nodejs-in-flames.html
https://nodejs.org/en/docs/guides/simple-profiling/
https://blog.risingstack.com/node-js-war-stories-solving-issues-in-production-2/
http://www.brendangregg.com/FlameGraphs/cpuflamegraphs.html#Node.js
http://www.brendangregg.com/blog/2014-09-17/node-flame-graphs-on-linux.html
https://github.com/node-inspector/v8-profiler
https://github.com/joyent/node-stackvis

---

### profiling

```
$ node --prof app.js
$ node --prof-process isolate-0xnnnnnnnnnnnn-v8.log | less
```

---

### flame graphs

```
$ node --perf_basic_prof_only_functions app.js
$ perf record -F 99 -p `pgrep -n node` -g -- sleep 30
$ perf script > nodestacks
$ stackvis perf flamegraph-d3 < nodestacks > flamegraph.htm
```

---

### chrome profiling

```javascript
const profiler = require('v8-profiler');
profiler.startProfiling('profile-name');

const prof = prof.stopProfiling('profile-name');
prof.export((error, result) => {
    fs.writeFile('prof.json', result, () => {
        prof.delete();
    });
});
```

将得到的 json 倒入 chrome 分析即可
