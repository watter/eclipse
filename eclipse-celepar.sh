
#leslie@ecelepar16853:~$ echo $A
#WORKA
#leslie@ecelepar16853:~$ echo ${A,,[A-Z]}
#worka



export WORKSPACE_LOC="/home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/workspace/"
export ENCODING="ISO-8859-1"


export ECLIPSEDIR="/home/desenv/eclipse"
# troca o workspace recente pela sugestão do workspace com o nome do usuário
sed "s@RECENT_WORKSPACES=.*@RECENT_WORKSPACES=${WORKSPACE_LOC}@" -i ${ECLIPSEDIR}/configuration/.settings/org.eclipse.ui.ide.prefs


# Configuração da máquina virtual java a ser utilizada 


ORACLE_JAVA=""
if [ -d "/usr/lib/jvm/oracle-java6/jdk" ] ; then
  ORACLE_JAVA="/usr/lib/jvm/oracle-java6/jdk"
  export JAVA_HOME=$ORACLE_JAVA
fi
SUN_JAVA=""
if [ -d "/usr/lib/jvm/java-6-sun" ] ; then
 SUN_JAVA="/usr/lib/jvm/java-6-sun"
 export JAVA_HOME=$SUN_JAVA
fi
if [ -z $ORACLE_JAVA ] && [ -z $SUN_JAVA ] ; then
        export JAVA_HOME=$PLC_HOME/java
fi



if [ -d "/usr/lib/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/jni"
fi
if [ -d "/usr/lib/i386-linux-gnu/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/i386-linux-gnu/jni"
fi
if [ -d "/usr/lib/x86_64-linux-gnu/jni/" ] ; then
		JAVA_JNI="-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni/"

fi

export JAVA_JNI
export JAVA_ENCODING_OPTS="-Dfile.encoding=${ENCODING} -Dsun.jnu.encoding=${ENCODING}"
export JAVA_OPTS="${JAVA_ENCODING_OPTS} ${JAVA_JNI}"

export PATH=$JAVA_HOME/bin:$PATH


## start 768 -- jaguar -- utf8 


export ENCODING="UTF-8"
#!/bin/bash
cd /home/desenv/jaguar
export PLC_HOME=$(pwd)
export HOME_PLC=$(pwd)
export PLC_MEUS_PROJETOS=$PLC_HOME/meus_projetos
export MEUS_PROJETOS=$PLC_HOME/meus_projetos
export PLC_JARS_COMPILE=$PLC_MEUS_PROJETOS/jcompany_apoio/compile
export CATALINA_HOME=$PLC_HOME/servers/tomcat
export ECLIPSE_HOME=$PLC_HOME/eclipse
export JMETER_HOME=$HOME_PLC/jcompanyqa/jakarta-jmeter
export MVN=$PLC_HOME/ferramentas/maven


# remove arquivo que causa problema de mensagem em branco caso o arquivo exista
if [ -e ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap ]; then
        rm ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap
fi


export JCP_JBOSS_HOME=$PLC_HOME/servers/jboss
export JCP_JBOSS5_HOME=$PLC_HOME/servers/jboss5
echo INICIANDO ECLIPSE
echo JAVA_HOME=$JAVA_HOME
echo PLC_HOME=$PLC_HOME
echo PLC_MEUS_PROJETOS=$PLC_MEUS_PROJETOS
echo MEUS_PROJETOS=$MEUS_PROJETOS
echo CATALINA_HOME=$CATALINA_HOME
echo ECLIPSE_HOME=$ECLIPSE_HOME
echo MVN=$MVN
$ECLIPSE_HOME/eclipse -os linux -ws gtk -vmargs -Xms768m -Xmx768m -XX:MaxPermSize=256m $JAVA_OPTS
