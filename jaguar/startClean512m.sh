export PLC_HOME=$(pwd)
export HOME_PLC=$(pwd)
rm $HOME_PLC/workspace/.metadata/.plugins/org.eclipse.core.resources/.snap
export PLC_MEUS_PROJETOS=$PLC_HOME/meus_projetos
export MEUS_PROJETOS=$PLC_HOME/meus_projetos
export PLC_JARS_COMPILE=$PLC_MEUS_PROJETOS/jcompany_apoio/compile
export CATALINA_HOME=$PLC_HOME/servers/tomcat
export ECLIPSE_HOME=$PLC_HOME/eclipse
export JMETER_HOME=$HOME_PLC/jcompanyqa/jakarta-jmeter
export MVN=$PLC_HOME/ferramentas/maven
export JAVA_HOME=$PLC_HOME/java
export PATH=$JAVA_HOME/bin:$PATH
export JAVA_OPTS=-Dfile.encoding=ISO8859_1
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
$ECLIPSE_HOME/eclipse -clean -data $PLC_HOME/workspace -os linux -ws gtk -vmargs -Xms512m -Xmx512m -XX:MaxPermSize=256m $JAVA_OPTS
