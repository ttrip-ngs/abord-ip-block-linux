#!/bin/bash

# スクリプトのファイル所在地にカレントディレクトリを移動
#echo 'test'
cd "$(dirname "$0")" || exit 1

# 設定ファイルから値を読み込む
if [ -f "ip-block.conf" ]; then
  # shellcheck source=ip-block.conf
  source ip-block.conf
else
  echo "警告: ip-block.conf ファイルが見つかりません。"
  exit 1
fi

# IPV4とIPV6の設定値を読み込む
IPV4=${IPV4:-0}
IPV6=${IPV6:-0}
# IPV4_URLとIPV6_URLを読み込む
IPV4_URL=${IPV4_URL:-""}
IPV6_URL=${IPV6_URL:-""}
# IPV4_URLとIPV6_URLの末尾のスラッシュを削除
IPV4_URL=${IPV4_URL%/}
IPV6_URL=${IPV6_URL%/}

# IPV4_COUNTRYとIPV6_COUNTRYの設定値を読み込む
IPV4_COUNTRIES=""
IPV6_COUNTRIES=""

if [ "$IPV4" -eq 1 ]; then
  IPV4_COUNTRIES=${IPV4_COUNTRY:-""}
fi

if [ "$IPV6" -eq 1 ]; then
  IPV6_COUNTRIES=${IPV6_COUNTRY:-""}
fi

# カンマ区切りの国名を配列に変換
IFS=',' read -ra IPV4_COUNTRY_ARRAY <<<"$IPV4_COUNTRIES"
IFS=',' read -ra IPV6_COUNTRY_ARRAY <<<"$IPV6_COUNTRIES"

# IPV4とIPV6の設定を確認
if [ "$IPV4" -eq 1 ] && [ -z "$IPV4_URL" ]; then
  echo "エラー: IPV4が有効ですが、IPV4_URLが設定されていません。"
  exit 1
fi

if [ "$IPV6" -eq 1 ] && [ -z "$IPV6_URL" ]; then
  echo "エラー: IPV6が有効ですが、IPV6_URLが設定されていません。"
  exit 1
fi

# IPV4が有効で国名の要素がない場合はエラー
if [ "$IPV4" -eq 1 ] && [ ${#IPV4_COUNTRY_ARRAY[@]} -eq 0 ]; then
  echo "エラー: IPV4が有効ですが、国名が指定されていません。"
  exit 1
fi

# IPV6が有効で国名の要素がない場合はエラー
if [ "$IPV6" -eq 1 ] && [ ${#IPV6_COUNTRY_ARRAY[@]} -eq 0 ]; then
  echo "エラー: IPV6が有効ですが、国名が指定されていません。"
  exit 1
fi

if [ ! -d "ip-lists" ]; then
  mkdir ip-lists
fi
cd ip-lists || exit 1
# ip-listsディレクトリ内のファイルを全て削除
echo "ip-listsディレクトリ内のファイルを削除しています"
rm -f ./*
echo "削除完了"

# IPV4_COUNTRY_ARRAYでループ
for country in "${IPV4_COUNTRY_ARRAY[@]}"; do
  # countryを小文字に変換
  country=$(echo "$country" | tr '[:upper:]' '[:lower:]')
  echo "IPV4: ${country}の処理を開始します"
  FULL_URL="${IPV4_URL}/${country}-aggregated.zone"
  echo "フルURL: ${FULL_URL}"

  # curlコマンドを実行し、ステータスコードを取得
  HTTP_STATUS=$(curl -s -o "${country}-aggregated.zone" -w "%{http_code}" "${FULL_URL}")

  if [ "$HTTP_STATUS" -ne 200 ]; then
    echo "エラー: ${country}のIPリストのダウンロードに失敗しました。HTTPステータスコード: ${HTTP_STATUS}"
    exit 1
  fi

  echo "${country}のIPリストのダウンロードが完了しました。"
done


FIREWALLD=${FIREWALLD:-0}
if [ "$FIREWALLD" -eq 1 ]; then
  echo "firewalldを使用してブロックします"
  
fi




