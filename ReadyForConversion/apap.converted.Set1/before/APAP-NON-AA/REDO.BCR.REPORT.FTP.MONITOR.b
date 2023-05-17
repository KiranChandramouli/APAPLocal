*-----------------------------------------------------------------------------
* <Rating>-54</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.BCR.REPORT.FTP.MONITOR(REGISTERS.LIST)
*-----------------------------------------------------------------------------
* <doc>
*
* FIELDS for  REDO.BCR.REPORT.FTP.MONITOR application NOFILE, return all registers
* begin with BCR and send method FTP
* This Routine gets the list of files exits in the path indicate from all BCR registers
*
* author: mgudino@temenos.com
*
* </doc>
*-----------------------------------------------------------------------------
* Modification History :
*
* 29/10/2010 - C.21 Buro de Credito
*
*-----------------------------------------------------------------------------
*** <region name= Header>
*** <desc>Inserts and control logic</desc>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_F.REDO.INTERFACE.PARAM

  GOSUB INIT
  GOSUB OPENFILES
  GOSUB PROCESS

  RETURN
*--------------------------------------
INIT:
*--------------------------------------

*REDO.INTERFACE.PARAM
  F.RIP = ''
  FN.RIP = 'F.REDO.INTERFACE.PARAM'
  Y.ICON.FOUND = '../plaf/images/default/redlight.gif'
  Y.ICON.NOT.FOUND = ''       ;*'../plaf/images/default/greenlight.gif'

  Y.CONST = '*'

  RETURN
*--------------------------------------
OPENFILES:

  CALL OPF(FN.RIP,F.RIP)

  RETURN
*--------------------------------------
PROCESS:


  Y.SEL.CMD = "SELECT " :FN.RIP:" WITH @ID LIKE BCR... AND SEND.METHOD EQ FTP"
*"SELECT I_F.REDO.INTERFACE.PARAM  WITH @ID LIKE BCR... AND SEND.METHOD EQ FTP"
  CALL EB.READLIST(Y.SEL.CMD,Y.RIP.LIST,'',NO.OF.REC,RET.CODE)
  LOOP
    REMOVE Y.RIP.ID FROM Y.RIP.LIST SETTING Y.POS
  WHILE Y.RIP.ID:Y.POS
    R.RIP = ''
    CA.ERR = ''
    CALL F.READ(FN.RIP,Y.RIP.ID,R.RIP,F.RIP,CA.ERR)
    IF CA.ERR NE '' THEN
      CALL OCOMO(CA.ERR : " RECORD.NOT.FOUND " : Y.RIP.ID)
      RETURN
    END
* GET ftpListenerPath value
    paramType = 'FTP.LISTENER.PATH'
    fieldParamType = R.RIP<REDO.INT.PARAM.PARAM.TYPE>
    fieldParamValue = R.RIP<REDO.INT.PARAM.PARAM.VALUE>
    fileName = ''
    ftpListenerPath = ''
    valueNo = 0
    ftpListenerPath = ""
    LOCATE paramType IN fieldParamType<1,1> SETTING valueNo THEN
      ftpListenerPath = fieldParamValue<1, valueNo>
    END ELSE
      valueNo = 0
    END

* If a wrong parameter then try with the next record
    IF valueNo EQ 0 THEN
      REGISTERS.LIST<-1> = Y.RIP.ID : Y.CONST : "FTP.LISTENER.PATH Param Type is missed. Check Parameters" : Y.CONST : ""
      CONTINUE
    END

*GETS THE FILENAME,
    fileName  = R.RIP<REDO.INT.PARAM.FILE.NAME>
    Y.RETURN = Y.ICON.NOT.FOUND
    F.PROP.FILE = ''

    OPENSEQ ftpListenerPath, fileName TO F.PROP.FILE THEN
      Y.RETURN  = Y.ICON.FOUND
      REGISTERS.LIST<-1>=Y.RIP.ID:Y.CONST:R.RIP<REDO.INT.PARAM.DESCRIPTION>:Y.CONST:Y.RETURN
    END

  REPEAT


  RETURN
*--------------------------------------
END
