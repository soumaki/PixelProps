# Variáveis do Módulo
SYS_PROP_MANUFACTURER=`grep_prop ro.product.system.manufacturer`
MOD_PROP_MANUFACTURER=`grep_prop ro.product.system.manufacturer $MODPATH/system.prop`
MOD_PROP_MODEL=`grep_prop ro.product.model $MODPATH/system.prop`
MOD_PROP_PRODUCT=`grep_prop ro.build.product $MODPATH/system.prop | tr '[:lower:]' '[:upper:]'`
MOD_PROP_VERSION=`grep_prop ro.build.version.release $MODPATH/system.prop`
MOD_PROP_SECURITYPATCH=`grep_prop ro.build.version.security_patch $MODPATH/system.prop`
MOD_PROP_VERSIONCODE=`date -d $MOD_PROP_SECURITYPATCH '+%y%m%d'`
MOD_PROP_MONTH=`date -d $MOD_PROP_SECURITYPATCH '+%B'`
MOD_PROP_YEAR=`date -d $MOD_PROP_SECURITYPATCH '+%Y'`

# Cabeçalho
ui_print "- Installing, $MOD_PROP_MODEL ($MOD_PROP_PRODUCT) Prop - $MOD_PROP_MONTH $MOD_PROP_YEAR"

# Verifica se o SDK é compatível
MOD_API=`grep_prop ro.build.version.sdk $MODPATH/system.prop | grep -ohE '[0-9]{2}'`

# Vida que segue
if [ $SYS_PROP_MANUFACTURER == $MOD_PROP_MANUFACTURER ]; then
  ui_print "- MANUFACTURER=$SYS_PROP_MANUFACTURER, rodando no modo não seguro"
else
  sed -i 's/^ro.product.system.manufacturer/# ro.product.system.manufacturer/' $MODPATH/system.prop
  ui_print "- MANUFACTURER=$SYS_PROP_MANUFACTURER, rodando no modo seguro"
fi

# Verifique se a API do aparelho está correta para evitar bootloop
if [ $API -gt $MOD_API ]; then
  ui_print "- SDK=$API, rodando no modo não seguro"
else
  sed -i 's/^ro.build.version.sdk/# ro.build.version.sdk/' $MODPATH/system.prop
  ui_print "- SDK=$API, rodando no modo seguro"
fi

# Esta linha remove os comentários dos arquivos e os substitui, adicionando então uma nova linha no final
# Scripts
for i in $(find $MODPATH -type f -name "*.sh" -o -name "*.prop" -o -name "*.rule"); do
  [ -f $i ] && { sed -i -e "/^#/d" -e "/^ *$/d" $i; [ "$(tail -1 $i)" ] && echo "" >> $i; } || continue
done

# Print footer message
ui_print "Done"
ui_print "Reboot is required"
ui_print "Enjoy your Pixel"