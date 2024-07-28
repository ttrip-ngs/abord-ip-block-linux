# 簡単な計算機プログラム

def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

def multiply(a, b):
    return a * b

def divide(a, b):
    if b != 0:
        return a / b
    else:
        return "エラー: ゼロで割ることはできません"

# メイン処理
print("簡単な計算機へようこそ！")
num1 = float(input("最初の数字を入力してください: "))
num2 = float(input("2番目の数字を入力してください: "))

print(f"足し算: {add(num1, num2)}")
print(f"引き算: {subtract(num1, num2)}")
print(f"掛け算: {multiply(num1, num2)}")
print(f"割り算: {divide(num1, num2)}")
