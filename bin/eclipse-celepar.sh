
#leslie@ecelepar16853:~$ echo $A
#WORKA
#leslie@ecelepar16853:~$ echo ${A,,[A-Z]}
#worka

export ECLIPSE_LATIN1="/home/desenv/bin/eclipse"
export ECLIPSE_UTF8="/home/desenv/bin/jaguar/eclipse"
export HOME_BIN="/home/desenv/bin"
export HOME_SERVERS="/home/desenv/servers"

# independente da seleção de eclipse, iremos utilizar o maven dentro de $HOME_BIN/ferramentas/maven (3.0)
export MVN=$HOME_BIN/ferramentas/maven

# seção de configurações dos servidores a serem utilizados - só é liberado 1 tomcat
export CATALINA_HOME=$HOME_SERVERS/tomcat

CODIFICACAO=$(zenity  --list  --text "Qual a Codificação de Caracteres que seu projeto irá usar:" --radiolist  --column "Escolha" --column "Codificação" TRUE "UTF-8"  FALSE "ISO-8859-1"); echo $CODIFICACAO

VERSAOJBOSS=$(zenity  --list  --text "Escolha a Versão do Servidor que seu projeto irá usar:" --radiolist  --column "Escolha" --column "Versão" TRUE JBoss7  FALSE JBoss4.2.3 FALSE JBoss4.0.5  FALSE Tomcat); echo $VERSAOJBOSS



JBOSS_HOME=""
if [ "$VERSAOJBOSS"x == "JBoss7"x  ]; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss7"
elif [ "$VERSAOJBOSS"x == "JBoss4.2.3"x  ] ; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss4.2.3"
elif [ "$VERSAOJBOSS"x == "JBoss4.0.5"x  ] ; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss4.0.5"
fi


export WORKSPACE_LOC="/home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/workspace/"
export ENCODING="ISO-8859-1"


if [ "$TIPO_PROJETO"x == "LATIN1"x ] ; then
    ECLIPSEDIR=${ECLIPSE_LATIN1}
else
    ECLIPSEDIR=${ECLIPSE_UTF8}
fi

export ECLIPSEDIR

# após selecionado o eclipse correto, atribua o eclipse_home ao diretorio
export ECLIPSE_HOME=$ECLIPSEDIR



### limpeza e verificação dos detalhes do workspace

# testa se existe o diretório para o workspace corretamente
if ! [ -d $WORKSPACE_LOC ] ; then
		mkdir -p $WORKSPACE_LOC;
fi

# remove arquivo que causa problema de mensagem em branco caso o arquivo exista
if [ -e ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap ]; then
        rm ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap
fi

# troca o workspace recente pela sugestão do workspace com o nome do usuário
sed "s@RECENT_WORKSPACES=.*@RECENT_WORKSPACES=${WORKSPACE_LOC}@" -i ${ECLIPSEDIR}/configuration/.settings/org.eclipse.ui.ide.prefs


export JAGUAR_HOME="/home/desenv/bin/jaguar"
export PLC_HOME=$JAGUAR_HOME


# Configuração da máquina virtual java a ser utilizada 

ORACLE_JAVA=""
SUN_JAVA=""
if [ -d "/usr/lib/jvm/oracle-java6/jdk" ] ; then
  ORACLE_JAVA="/usr/lib/jvm/oracle-java6/jdk"
  export JAVA_HOME=$ORACLE_JAVA
elif [ -d "/usr/lib/jvm/java-6-sun" ] ; then
 SUN_JAVA="/usr/lib/jvm/java-6-sun"
 export JAVA_HOME=$SUN_JAVA
elif [ -z $ORACLE_JAVA ] && [ -z $SUN_JAVA ] ; then
        export JAVA_HOME=$PLC_HOME/java
fi



if [ -d "/usr/lib/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/jni"
elif [ -d "/usr/lib/i386-linux-gnu/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/i386-linux-gnu/jni"
elif [ -d "/usr/lib/x86_64-linux-gnu/jni/" ] ; then
		JAVA_JNI="-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni/"
fi

export JAVA_JNI
export JAVA_ENCODING_OPTS="-Dfile.encoding=${ENCODING} -Dsun.jnu.encoding=${ENCODING}"
export JAVA_OPTS="${JAVA_ENCODING_OPTS} ${JAVA_JNI}"
export PATH=$JAVA_HOME/bin:$PATH


## start 768 -- jaguar -- utf8 


export ENCODING="UTF-8"

export HOME_PLC=$JAGUAR_HOME
export PLC_MEUS_PROJETOS=$PLC_HOME/meus_projetos
export MEUS_PROJETOS=$PLC_HOME/meus_projetos
export PLC_JARS_COMPILE=$PLC_MEUS_PROJETOS/jcompany_apoio/compile
export JMETER_HOME=$HOME_PLC/jcompanyqa/jakarta-jmeter



export JCP_JBOSS_HOME=$HOME_SERVERS/jboss
export JCP_JBOSS5_HOME=$HOME_SERVERS/jboss5


echo JAVA_HOME=$JAVA_HOME
echo PLC_HOME=$PLC_HOME
echo PLC_MEUS_PROJETOS=$PLC_MEUS_PROJETOS
echo MEUS_PROJETOS=$MEUS_PROJETOS
echo CATALINA_HOME=$CATALINA_HOME
echo ECLIPSE_HOME=$ECLIPSE_HOME
echo MVN=$MVN



$ECLIPSE_HOME/eclipse -os linux -ws gtk -vmargs -Xms768m -Xmx768m -XX:MaxPermSize=256m $JAVA_OPTS