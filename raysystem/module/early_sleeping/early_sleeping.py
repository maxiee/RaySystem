from datetime import datetime
import random

def early_sleeping__gen_date():
    """get the date today in Chinese"""
    weekdays = ['一', '二', '三', '四', '五', '六', '日']
    
    now = datetime.now()
    weekday = weekdays[now.weekday()]
    
    return f"今天是 {now.month}月{now.day}日 星期{weekday}"

def early_sleeping__stoic_question():
    questions = [
        "今天你是否被一些不受你控制的事情困扰？请记住，我们只能控制自己的态度和反应。",
        "如果今天是你生命的最后一天，你最想完成什么？",
        "今天你是否在追求真正重要的事情，还是被琐事分散了注意力？",
        "你今天的行动是否符合你的核心价值观？",
        "如果有人像你对待自己那样对待你的朋友，你会作何感想？",
        "今天的困境中，什么是你能够控制的，什么是无法控制的？",
        "你的幸福是否依赖于外部环境，而不是你的内在？",
        "今天的挫折如何帮助你成长？",
        "你是否在用理性还是情绪来回应今天的挑战？"
    ]
    return random.choice(questions)

def early_sleeping_gen_diary():
    str = ''
    str += early_sleeping__gen_date() + '\n'
    str += '''
我有晚睡的坏习惯，我想请你帮助我改掉这个坏习惯，实现早睡早起。我为什么要早起？有两个核心原因：

1. 早上是我和孩子唯一的时间交集，我想早起陪伴孩子，这对孩子的成长和我和孩子之间的关系都是非常有益的。
2. 我的身体状况不是很好，如果再晚睡下去，我的身体会出大问题。

但是我有很多愁绪，阻止我入睡。接下来，我会列出阻止我入睡的原因，希望你能帮我解决这些问题。

## 阻止我入睡的原因

## 每日斯多葛
''' + early_sleeping__stoic_question() + '''

以上就是我今晚的愁绪，希望你能帮我解决这些问题，让我早睡早起，谢谢你！
'''
    return str