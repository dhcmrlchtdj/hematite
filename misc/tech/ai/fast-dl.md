# fast.ai Practical Deep Learning for Coders

http://course.fast.ai
https://github.com/fastai/course-v3
https://github.com/hiromis/notes

---

课程有很多无效的信息，导致我对课程的内容有点怀疑。
比如，强调不需要数学、编程基础，插入一些煽动性的新闻报道。
这些对实际学习都是无用的。
面向无编码基础的观众，又会讲一些很浅显的编码知识，拖慢了进度。

虽然有这些不满，不过，我目前对 DL 没有任何实际的辨别能力。
就几节课，年前几天，先看看吧。
也不是想成为 DL 专家，能简单练练丹就好。

---

## lesson 1

-   识别图片，猫狗
-   用 CNN，一个叫 ResNet 的模型。
-   pytorch 里已经把这个模型训练好了，直接用就行。
    - `learner = create_cnn(data, models.resnet18, metrics=[accuracy])`
    -   有几种度量结果的指标，https://docs.fast.ai/metrics.html#metrics
-   剩下在讲如何炼丹
    -   查看那些内容没匹配上
    -   修改参数让匹配更准确

```python
learn = create_cnn(data, models.resnet50, metrics=error_rate)

#learn.fit_one_cycle(8)

learn.lr_find()
learn.recorder.plot()
learn.fit_one_cycle(3, max_lr=slice(1e-6,1e-4))

learn.save('stage')

interp = ClassificationInterpretation.from_learner(learn)
interp.most_confused(min_val=2)
# interp.plot_confusion_matrix(figsize=(12,12), dpi=60)
```

---


