#!/bin/bash

#set -x 

export ECLIPSE_LATIN1="/home/desenv/bin/eclipse"
export ECLIPSE_UTF8="/home/desenv/bin/jaguar/eclipse"
export HOME_BIN="/home/desenv/bin"
export HOME_SERVERS="/home/desenv/servers"

# independente da seleção de eclipse, iremos utilizar o maven dentro de $HOME_BIN/ferramentas/maven (3.0)
export MVN=$HOME_BIN/ferramentas/maven

export DIALOG=/usr/bin/zenity
export USUARIO=$USER

export ECLIPSE_LATIN1="/home/desenv/bin/eclipse"
export ECLIPSE_UTF8="/home/desenv/bin/jaguar/eclipse"

export PLC_WORKSPACE="/home/desenv/bin/jaguar/workspace"

export JAGUAR_HOME="/home/desenv/bin/jaguar"
export PLC_HOME=$JAGUAR_HOME
export HOME_PLC=$JAGUAR_HOME
export PLC_MEUS_PROJETOS=$PLC_HOME/meus_projetos
export MEUS_PROJETOS=$PLC_HOME/meus_projetos
export PLC_JARS_COMPILE=$PLC_MEUS_PROJETOS/jcompany_apoio/compile
export JMETER_HOME=$HOME_PLC/jcompanyqa/jakarta-jmeter
export JCP_JBOSS_HOME=$HOME_SERVERS/jboss
export JCP_JBOSS5_HOME=$HOME_SERVERS/jboss5


#
# essa função monta uma lista de radiobutton conforme os workspaces presentes dentro da estrutura workspaces/USUARIO/CODIFICACAO/
#
function escolhe_workspace() {
	declare -a OPCOES=()
	for i in /home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/* ; do 
		OPCOES=("${OPCOES[@]}" "FALSE" "$i" ) ; 
	done
	OPCOES[0]="TRUE"
	zenity  --list --width=600 --height=$((${#OPCOES[@]} * 30)) --text "Selecione o <b>workspace</b> a ser utilizado" --radiolist  --column "Op" --column "Workspace"  ${OPCOES[@]} >/tmp/checklist.tmp.$$ 2>&1

# ${#OPCOES[@]} -- número de elementos do array
# ${OPCOES[@]}) -- elementos do array

	retval=$?
	choice=`cat /tmp/checklist.tmp.$$`
	rm -f /tmp/checklist.tmp.$$
	case $retval in
	  0)
			eval $1=$choice
	        return 0
	        ;;
	  1)
	  	# caso seja pressionado esc, usa o workspace padrão
			eval $1="/home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/workspace"
	        ;;
	esac
	return 0;
}


#
# Atribui o -clean para ser usado na linha de cache do eclipse - Sim == limpa - Esc == não
#
function limpa_cache_eclipse() {
zenity --question --text "<b>Limpar Cache Eclipse?</b>" >/tmp/checklist.tmp.$$ 2>&1

retval=$?
choice=`cat /tmp/checklist.tmp.$$`
rm -f /tmp/checklist.tmp.$$
case $retval in
  0)
		# sim 
		eval $1="-clean"
        ;;
  1)
		# não
		eval $1=""
        ;;
esac
return 0;
}

CLEARCACHE=''
limpa_cache_eclipse CLEARCACHE

#
# Atribui o -consolelog na linha de comando do eclipse
#
function log_console_eclipse() {
zenity --question --text "<b>Habilitar log no Console?</b>" >/tmp/checklist.tmp.$$ 2>&1

retval=$?
choice=`cat /tmp/checklist.tmp.$$`
rm -f /tmp/checklist.tmp.$$
case $retval in
  0)
        # sim
        eval $1="-consolelog"
        ;;
  1)
        # não
        eval $1=""
        ;;
esac
return 0;
}

CONSOLELOG=''
log_console_eclipse CONSOLELOG


# Uso da função
# leslieh@ecelepar14743:/home/desenv$ COD=''
# leslieh@ecelepar14743:/home/desenv$ escolhe_codificacao COD
# leslieh@ecelepar14743:/home/desenv$ echo $COD
# UTF-8
#
# lista de escolha de codificação - obrigatória a escolha de um item
#
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
		escolhe_codificacao $1
        ;;
  255)
		escolhe_codificacao $1
        ;;
esac
return 0;
}


ENCODING=''
escolhe_codificacao ENCODING

#
# Escolha de servidor -- escolhe entre os servidores disponíveis - obrigatória escolha
#
function escolhe_server(){
zenity  --list --height=250 --text "Escolha a <b>Versão do Servidor</b> que seu projeto irá usar:" --radiolist  --column "Opção" --column "Versão" TRUE JBoss7  FALSE JBoss4.2.3 FALSE JBoss4.0.5  FALSE Tomcat >/tmp/checklist.tmp.$$ 2>&1

retval=$?
choice=`cat /tmp/checklist.tmp.$$`
rm -f /tmp/checklist.tmp.$$
case $retval in
  0)
		eval $1=$choice
        return 0
        ;;
  1)
		escolhe_server $1
        ;;
  255)
 		escolhe_server $1
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

# opções que serão usadas na inicialização do eclipse

export INSTALL="${ECLIPSEDIR}/"
export STARTUP="${ECLIPSEDIR}/"
export SPLASH="${ECLIPSEDIR}/splash-gic.bmp"


### limpeza e verificação dos detalhes do workspace

WORKSPACE_LOC="/home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/workspace/"
WORKSPACE_DATA=""

# testa se existe o diretório para o workspace corretamente
if ! [ -d $WORKSPACE_LOC ] ; then
	if [ "${ENCODING}"x == "UTF-8"x ]; then
		WORKSPACE_DATA="-data ${WORKSPACE_LOC}"
		# informa o usuário que está "preparando a cópia inicial do workspace"
		cp -rv $PLC_WORKSPACE $WORKSPACE_LOC  | tee > (zenity --progress --pulsate --no-cancel --text "Preparando versão inicial do workspace"  --timeout 1) >/dev/null
	elif [ "${ENCODING}"x == "ISO-8859-1"x]; then
		mkdir -p $WORKSPACE_LOC;
	fi	
fi

# verifica se existe mais de um e cria a janela de opções
WORKS=$(ls /home/desenv/workspaces/${USUARIO,,[A-Z]}/${ENCODING,,[A-Z]}/* -ld1 | wc -l)
if [ $WORKS -gt 1 ] ; then
	CHOSEN_WKS=''
	escolhe_workspace CHOSEN_WKS
	WORKSPACE_LOC=$CHOSEN_WKS
fi 
export WORKSPACE_LOC

# remove arquivo que causa problema de mensagem em branco caso o arquivo exista
if [ -e ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap ]; then
        rm ${WORKSPACE_LOC}/.metadata/.plugins/org.eclipse.core.resources/.snap
fi

# troca o workspace recente pela sugestão do workspace com o nome do usuário
sed "s@RECENT_WORKSPACES=.*@RECENT_WORKSPACES=${WORKSPACE_LOC}@" -i ${ECLIPSEDIR}/configuration/.settings/org.eclipse.ui.ide.prefs


#
# Configuração da máquina virtual java a ser utilizada 
#

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

# If the user has specified a custom JAVA, we check it for validity.
# JAVA defines the virtual machine that Eclipse will use to launch itself.
if [ -n "${JAVA_HOME}" ]; then
        if [ ! -x "${JAVA_HOME}/bin/java" ]; then
                $DIALOG \
                        --error \
                        --title="Could not launch Eclipse Platform" \
                        --text="The custom VM you have chosen is not a valid executable."
                exit 1
        fi
fi

# If we don't have a JAVA_HOME yet, we're doomed.
if [ -z "${JAVA_HOME}" -a ! -n "${JAVACMD}" ]; then
        $DIALOG \
                --error \
                --title="Could not launch Eclipse Platform" \
                --text="A suitable Java Virtual Machine for running the Eclipse Platform could not be located."
        exit 1
fi

# Set JAVACMD from JAVA_HOME
if [ -n "${JAVA_HOME}" -a -z "${JAVACMD}" ]; then
        JAVACMD="$JAVA_HOME/bin/java"
fi


if [ -d "/usr/lib/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/jni"
elif [ -d "/usr/lib/i386-linux-gnu/jni/" ] ; then
        JAVA_JNI="-Djava.library.path=/usr/lib/i386-linux-gnu/jni"
elif [ -d "/usr/lib/x86_64-linux-gnu/jni/" ] ; then
		JAVA_JNI="-Djava.library.path=/usr/lib/x86_64-linux-gnu/jni/"
fi

export JAVA_JNI
export JAVA_ENCODING_OPTS="-Dfile.encoding=${ENCODING} -Dsun.jnu.encoding=${ENCODING} -Dosgi.console.encoding=${ENCODING}"
export JAVA_OPTS="${JAVA_ENCODING_OPTS} ${JAVA_JNI}"
export PATH=$JAVA_HOME/bin:$PATH





#We ask GC to pause the application for no more than 10 milliseconds.
MAXGCPAUSEMILLIS=10 

# página -> http://www.oracle.com/technetwork/java/javase/tech/vmoptions-jsp-140102.html

# -XX:-UseParallelGC 	Use parallel garbage collection for scavenges. 
# -XX:+AggressiveOpts Turn on point performance compiler optimizations that are expected to be default in upcoming releases. (Introduced in 5.0 update 6.)
# -XX:MaxHeapFreeRatio=70 	Maximum percentage of heap free after GC to avoid shrinking.
# -XX:MaxPermSize=64m 	Size of the Permanent Generation.  [5.0 and newer: 64 bit VMs are scaled 30% larger; 1.4 amd64: 96m; 1.3.1 -client: 32m.]
# -XX:+UseStringCache 	Enables caching of commonly allocated strings.
# -XX:+UseCompressedStrings 	Use a byte[] for Strings which can be represented as pure ASCII. (Introduced in Java 6 Update 21 Performance Release) 
# -XX:+OptimizeStringConcat 	Optimize String concatenation operations where possible. (Introduced in Java 6 Update 20)
# -XX:-UseParallelGC 	Use parallel garbage collection for scavenges. 
# -XX:+UseParNewGC - for multiprocessor machines, enables multi threaded young generation collection.

NUMPROC=`cat /proc/cpuinfo | grep processor | wc -l`

if [ $NUMPROC -gt 1 ]; then
	PARGC="-XX:+UseParNewGC"
else
	PARGC=""
fi

# independente do jdk instalado ser sun ou oracle, os nomes são sun-java6-jdk | oracle-java6-jdk

JAVAUPDATE=$(dpkg -l *java6-jdk | grep ^ii |  grep java6  | awk '{print $3}' | cut -f 2 -d . | cut -f 1 -d -)
if [ $JAVAUPDATE -gt 20 ]; then
 STRINGCONCAT="-XX:+OptimizeStringConcat"
else
 STRINGCONCAT=""
fi

XMS=768
XMX=768
MAXPERMSIZE=256


VMARGS=" -Xms${XMS}m -Xmx${XMX}m -XX:MaxPermSize=${MAXPERMSIZE}m -XX:MaxGCPauseMillis=${MAXGCPAUSEMILLIS} -XX:-UseParallelGC ${PARGC} ${STRINGCONCAT} -XX:MaxHeapFreeRatio=70 -XX:CompileCommand=exclude,org/eclipse/core/internal/dtree/DataTreeNode,forwardDeltaWith -XX:CompileCommand=exclude,org/eclipse/jdt/internal/compiler/lookup/ParameterizedMethodBinding,<init> "

echo "================================================================================"
echo "Xms " $XMS
echo "Xmx " $XMX
echo "MaxPermSize " $MAXPERMSIZE
echo "NumProc " $NUMPROC
echo "ParGc " $PARGC
echo "StringConcat " $STRINGCONCAT
echo "Encoding " $ENCODING
echo JAVA_HOME=$JAVA_HOME
echo PLC_HOME=$PLC_HOME
echo PLC_MEUS_PROJETOS=$PLC_MEUS_PROJETOS
echo MEUS_PROJETOS=$MEUS_PROJETOS
echo CATALINA_HOME=$CATALINA_HOME
echo ECLIPSE_HOME=$ECLIPSE_HOME
echo MVN=$MVN
echo "================================================================================"

zenity --info --width 800  --timeout=3 --text "Utilizando configurações para o usuário \n<b> $USUARIO.</b> \n\
Usando Máquina virtual Java \n<b> $JAVA_HOME </b>\n\
Usando Codificação \n<b> $ENCODING </b>\n\
Eclipse HOME em \n<b> $ECLIPSE_HOME </b>\n\
Maven em \n<b> $MVN </b>\n\
Servidor de Aplicação \n<b> $VERSAOJBOSS </b>\n\
<b> $JBOSS_HOME $CATALINA_HOME </b>\n\
Usando <b>Workspace</b> \n<b> $WORKSPACE_LOC </b>\n\
JAVA_JNI \n<b> $JAVA_JNI </b>\n\
JAVA_OPTS \n<b> $JAVA_OPTS </b>\n\
VMARGS \n<b> ${VMARGS/</&lt;/} </b>"

# ${VMARGS/</&lt;/}  substitui < por &lt; por causa da marcação pango


DEB="echo"
DEB=""

# Do the actual launch of Eclipse with the selected VM.
$DEB exec $ECLIPSE_HOME/eclipse -os linux -ws gtk \
-vm "${JAVACMD}" \
-install "${INSTALL}" \
-showSplash "${SPLASH}" \
${CLEARCACHE} \
${CONSOLELOG} \
${WORKSPACE_DATA}\
-Dosgi.locking=none \
-vmargs ${VMARGS} ${JAVA_OPTS}

#
# configurações para o runtime
# http://help.eclipse.org/helios/index.jsp?topic=/org.eclipse.platform.doc.isv/reference/misc/runtime-options.html


# opções úteis

# -clean
# -consolelog
# -showSplash <bitmap>
# -user $HOME
# -vm <path to java vm>
# -ws gtk
# -vmargs [ ]

# use -DpropName=propValue as a VM argument to the Java VM
# eclipse.log.level
#    sets the level used when logging messages to the eclipse log.
#
#        * ERROR - enables logging only ERROR messages.
#        * WARNING - enables logging of ERROR and WARNING messages.
#        * INFO - enables logging of ERROR, WARNING and INFO messages.
#        * ALL - enables logging of all messages (default value)

# osgi.console.encoding
#    if set then the specified value is used as the encoding for the console
#    (see osgi.console). If not set then the value of the file.encoding property
#    is used. If file.encoding is not set then iso8859-1 is used as the default.

# osgi.install.area {-install}
#    the install location of the platform. This
#    setting indicates the location of the basic Eclipse plug-ins and is useful
#    if the Eclipse install is disjoint. See the section on locations for more
#    details.

# Install (-install) {osgi.install.area} [@user.home, @user.dir, filepath, url]

#    An install location is where Eclipse itself is installed. In practice this
#    location is the directory (typically "eclipse") which is the parent of the
#    eclipse.exe being run or the plugins directory containing the
#    org.eclipse.equinox.launcher bundle. This location should be considered
#    read-only to normal users as an install may be shared by many users. It is
#    possible to set the install location and decouple eclipse.exe from the rest
#    of Eclipse.

# osgi.instance.area {-data}
#    the instance data location for this
#    session. Plug-ins use this location to store their data. For example, the
#    Resources plug-in uses this as the default location for projects (aka the
#    workspace). See the section on locations for more details.

# osgi.requiredJavaVersion
#    The minimum java version that is required to launch Eclipse. The default value is "1.4.1".

# osgi.splashLocation
#    the absolute URL location of the splash screen (.bmp file) to to show while
#    starting Eclipse. This property overrides any value set in osgi.splashPath.

# osgi.splashPath
#    a comma separated list of URLs to search for a file called splash.bmp. This
#    property is overriden by any value set in osgi.splashLocation.

#leslie@ecelepar16853:~$ echo $A
#WORKA
#leslie@ecelepar16853:~$ echo ${A,,[A-Z]}
#worka
