Example 2:

1. 先執行以下指令, 會準備好 ncyu-2021-ex2 資料夾

```
cd $HOME
bash <(curl -s https://raw.githubusercontent.com/jrjang/ncyu-2021/ex2/scripts/ex2-pre.sh) GITHUB_ACCOUNT
```

2. 切到 ncyu-2021-ex2 資料夾下. 依據 data/0001-ex2.patch 做相對應的修改

3. 完成並commit後, 在 ncyu-2021-ex2 資料夾下, 執行以下指令

```
bash <(curl -s https://raw.githubusercontent.com/jrjang/ncyu-2021/ex2/scripts/ex2-test.sh) GITHUB_ACCOUNT
```
