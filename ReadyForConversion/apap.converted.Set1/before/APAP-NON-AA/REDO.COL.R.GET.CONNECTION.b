*-----------------------------------------------------------------------------
* <Rating>-109</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.COL.R.GET.CONNECTION(Y.RID.ID, R.REDO.INTERFACE.PARAM, Y.CONNECTION.STRING)
*-----------------------------------------------------------------------------
* This routine  have to give the formated connection string
* Receive the record REDO.INTERFACE.PARAM TO SEARCH connection values
* @author mgudino@temenos.com
* @stereotype subroutine
* @package TAM.BP
*
* Parameters:
*               R.REDO.INTERFACE.PARAM (in)      Interface Parameters
*               Y.CONNECTION.STRING    (out)     Connection in expected Java Format
*                                                1 : (1) url connection, (2) db user, (3) password, (4) data Base (SQL_SERVER, ORACLE, etc)
* -----------------------------------------------------------------------------
* History Changes
*       2010-10-25 : Changes logic, and give a return value
*-----------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT JBC.h
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_F.REDO.INTERFACE.SMAIL
$INSERT I_REDO.COL.COMMON


*-----------------------------------------------------------------------------

  GOSUB INITIALISE
  IF E NE '' THEN
    RETURN
  END
  GOSUB PROCESS

  RETURN

*-----------------------------------------------------------------------------
PROCESS:
*-----------------------------------------------------------------------------

  typeConfig = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.TYPE.CONFIG>
  typeData   = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.DATA.CONFIG>
* Total connections define
  Y.TOTAL = DCOUNT(typeConfig, @VM)
* Oracle Config
  Y.CONFIG = typeConfig<1,1>
  IF Y.CONFIG NE "ORACLE" THEN
    E = "ERROR CONFIG CONNECTION MUST BE ORACLE"
    RETURN
  END

  Y.CONNECTION.STRING = ''
  IF Y.DB.LOAD.BALANCE EQ 'NO' THEN
    Y.CONFIG.VALUES = CHANGE(typeData<1,1>, ",", FM)

    Y.CONNECTION.STRING := "jdbc:oracle:thin:@" : Y.CONFIG.VALUES<1> : ":"
    Y.CONNECTION.STRING := Y.CONFIG.VALUES<2> : ":"
    Y.CONNECTION.STRING := Y.DB.SERVICE.NAME
  END ELSE
    Y.CONNECTION.STRING := "jdbc:oracle:thin:@(DESCRIPTION=(LOAD_BALANCE=on)"
    FOR I = 1 TO Y.TOTAL
      IF Y.CONFIG EQ "ORACLE" THEN
        Y.CONFIG.VALUES = CHANGE(typeData<1,I>, ",", FM)
        Y.CONNECTION.STRING := "(ADDRESS=(PROTOCOL=TCP)(HOST=":Y.CONFIG.VALUES<1>:")"
        Y.CONNECTION.STRING := "(PORT=":Y.CONFIG.VALUES<2>:"))"
      END
    NEXT I
    Y.CONNECTION.STRING := "(CONNECT_DATA=(SERVICE_NAME=":Y.DB.SERVICE.NAME:")))"
  END

  Y.CONNECTION.STRING := FM :Y.DB.USER: FM :Y.DB.PASSWORD: FM : "ORACLE"

*      CRT Y.CONNECTION.STRING
  RETURN

*-----------------------------------------------------------------------------
INITIALISE:
*-----------------------------------------------------------------------------
  Y.CONNECTION.STRING = ''

* Read the connection values from the parameters
  Y.CONN.VAL.LIST = ""
  Y.CONN.VAL.LIST<-1> = "DB.USER"
  Y.CONN.VAL.LIST<-1> = "DB.PASSWORD"
  Y.CONN.VAL.LIST<-1> = "DB.SERVICE.NAME"
  Y.CONN.VAL.LIST<-1> = "DB.LOAD.BALANCE"
  Y.DB.USER = ""
  Y.DB.PASSWORD = ""
  Y.DB.SERVICE.NAME = ""
  Y.DB.LOAD.BALANCE = ""
  fieldParamType = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
  fieldParamValue = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>

  YERR= ''
  CALL CACHE.READ('F.REDO.COL.DB.CONNECTION', Y.RID.ID, R.REDO.COL.DB.CONNECTION, YERR)
  IF YERR NE '' THEN
    E = "RECORD WITH ID & WAS NOT FOUND ON & " : YERR
    E<2> = Y.RID.ID : VM : "F.REDO.COL.DB.CONNECTION"
    RETURN
  END


  LOOP
    REMOVE Y.CONN.VAL.ID FROM Y.CONN.VAL.LIST SETTING Y.CONN.VAL.MARK
  WHILE Y.CONN.VAL.ID : Y.CONN.VAL.MARK
    paramType = Y.CONN.VAL.ID
    GOSUB GET.PARAM.TYPE.VALUE
    BEGIN CASE
    CASE Y.CONN.VAL.ID EQ "DB.USER"
      Y.DB.USER = R.REDO.COL.DB.CONNECTION<1>
      Y.DB.USER = DECRYPT( Y.DB.USER,K_ENCRYPT_KEY,JBASE_CRYPT_3DES_BASE64)
    CASE Y.CONN.VAL.ID EQ "DB.PASSWORD"
      Y.DB.PASSWORD = R.REDO.COL.DB.CONNECTION<2>
      Y.DB.PASSWORD = DECRYPT( Y.DB.PASSWORD,K_ENCRYPT_KEY,JBASE_CRYPT_3DES_BASE64)
    CASE Y.CONN.VAL.ID EQ "DB.SERVICE.NAME"
      Y.DB.SERVICE.NAME = paramValue
    CASE Y.CONN.VAL.ID EQ "DB.LOAD.BALANCE"
      Y.DB.LOAD.BALANCE = paramValue
      IF paramValue EQ '' THEN
        Y.DB.LOAD.BALANCE = 'NO'
      END
    END CASE
    IF paramType MATCHES "DB.USER" : VM : "DB.PASSWORD" : VM : "DB.SERVICE.NAME" THEN
      IF paramValue EQ '' THEN
        E = "Parameter Type & is required. "
        E<2> = paramType
      END
    END
  REPEAT

  RETURN

*** <region name= getParamTypeValue>
*** paramType  (in)  to search
*** paramValue (out) value found
*** valueNo    (out) position of the value
*-----------------------------------------------------------------------------
GET.PARAM.TYPE.VALUE:
*-----------------------------------------------------------------------------

  valueNo = 0
  paramValue = ""
  LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
    paramValue = fieldParamValue<1, valueNo>
  END ELSE
    valueNo = 0
  END
  RETURN


*-----------------------------------------------------------------------------
*** </region>

END
