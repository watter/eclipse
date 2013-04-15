#!/bin/bash

export ECLIPSE_LATIN1="/home/desenv/bin/eclipse"
export ECLIPSE_UTF8="/home/desenv/bin/jaguar/eclipse"
export HOME_BIN="/home/desenv/bin"
export HOME_SERVERS="/home/desenv/servers"

# independente da seleção de eclipse, iremos utilizar o maven dentro de $HOME_BIN/ferramentas/maven (3.0)
export MVN=$HOME_BIN/ferramentas/maven

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


function escolhe_codificacao() {
zenity  --list  --text "Qual a <b>Codificação de Caracteres</b> que seu projeto irá usar/usa?" --radiolist  --column "Opção" --column "Codificação" TRUE "UTF-8"  FALSE "ISO-8859-1" >/tmp/checklist.tmp.$$ 2>&1

retval=$?
choice=`cat /tmp/checklist.tmp.$$`
rm -f /tmp/checklist.tmp.$$
case $retval in
  0)
		eval $1=$choice
        return 0
        ;;
  1)
		escolhe_codificacao
        ;;
  255)
		escolhe_codificacao
        ;;
esac
return 0;
}

# Uso da função
# leslieh@ecelepar14743:/home/desenv$ COD=''
# leslieh@ecelepar14743:/home/desenv$ escolhe_codificacao COD
# leslieh@ecelepar14743:/home/desenv$ echo $COD
# UTF-8

ENCODING=''
escolhe_codificacao ENCODING


function escolhe_server(){
zenity  --list  --text "Escolha a <b>Versão do Servidor</b> que seu projeto irá usar:" --radiolist  --column "Opção" --column "Versão" TRUE JBoss7  FALSE JBoss4.2.3 FALSE JBoss4.0.5  FALSE Tomcat >/tmp/checklist.tmp.$$ 2>&1

retval=$?
choice=`cat /tmp/checklist.tmp.$$`
rm -f /tmp/checklist.tmp.$$
case $retval in
  0)
		eval $1=$choice
        return 0
        ;;
  1)
		escolhe_server
        ;;
  255)
 		escolhe_server
        ;;
esac
return 0;
}

JBOSS_HOME=''
VERSAOJBOSS=''
escolhe_server VERSAOJBOSS

# seção de configurações dos servidores a serem utilizados - só é liberado 1 tomcat
if [ "$VERSAOJBOSS"x == "JBoss7"x  ]; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss7"
elif [ "$VERSAOJBOSS"x == "JBoss4.2.3"x  ] ; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss4.2.3"
elif [ "$VERSAOJBOSS"x == "JBoss4.0.5"x  ] ; then 
	JBOSS_HOME="${HOME_SERVERS}/jboss4.0.5"
elif [ "$VERSAOJBOSS"x == "Tomcat"x  ] ; then 
	export CATALINA_HOME=$HOME_SERVERS/tomcat
fi

if [ -n $JBOSS_HOME ] ; then  # -n = true if non-zero
	export JBOSS_HOME
fi

if [ "$ENCODING"x == "ISO-8859-1"x ] ; then
    ECLIPSEDIR=${ECLIPSE_LATIN1}
else
    ECLIPSEDIR=${ECLIPSE_UTF8}
fi

export ECLIPSEDIR

# após selecionado o eclipse correto, atribua o eclipse_home ao diretorio
export ECLIPSE_HOME=$ECLIPSEDIR


USUARIO=$USER



### limpeza e verificação dos detalhes do workspace

export WORKSPACE_LOC="/home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/workspace/"
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


zenity --info --text "Utilizando configurações para o usuário <b> $USUARIO.</b> \n\
Usando Máquina virtual Java - $JAVA_HOME \n\
Usando Codificação - $ENCODING \n\
Eclipse HOME em - $ECLIPSE_HOME \n\
Maven em - $MVN \n\
Servidor de Aplicação - $VERSAOJBOSS \n\
em $JBOSS_HOME $CATALINA_HOME \n\
Usando <b>Workspace</b> em $WORKSPACE_LOC \n"


exit

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
