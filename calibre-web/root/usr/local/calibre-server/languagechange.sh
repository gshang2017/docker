#! /bin/bash

Oldlanguage="`grep "language =" /config/calibre-server/calibre/global.py`"
if [[ ! "$Oldlanguage" =~ "$CALIBRE_SERVER_WEB_LANGUAGE" ]]; then
  ALLLANGUAGE=("af" "am" "ar" "ast" "az" "be" "bg" "bn" "bn_BD" "bn_IN" "br" "bs" "ca" "crh" "cs" "cy" "da" "de" "el" "en_AU" "en_CA" "en_GB" "eo" "es" "es_MX" "et" "eu" "fa" "fi" "fil" "fo" "fr" "fr_CA" "fur" "ga" "gl" "gu" "he" "hi" "hr" "hu" "hy" "id" "is" "it" "ja" "jv" "ka" "km" "kn" "ko" "ku" "lt" "ltg" "lv" "mi" "mk" "ml" "mn" "mr" "ms" "mt" "my" "nb" "nds" "nl" "nn" "nso" "oc" "or" "pa" "pl" "ps" "pt" "pt_BR" "ro" "ru" "rw" "sc" "si" "sk" "sl" "sq" "sr" "sr@latin" "sv" "ta" "te" "th" "ti" "tr" "tt" "ug" "uk" "ur" "uz@Latn" "ve" "vi" "wa" "xh" "yi" "zh_CN" "zh_HK" "zh_TW" "zu")
  if [[ ${ALLLANGUAGE[@]} =~ "$CALIBRE_SERVER_WEB_LANGUAGE" ]]; then
    sed -i 's/'"$Oldlanguage"'/language = u'"'"''"$CALIBRE_SERVER_WEB_LANGUAGE"''"'"'/' /config/calibre-server/calibre/global.py
  fi
fi
