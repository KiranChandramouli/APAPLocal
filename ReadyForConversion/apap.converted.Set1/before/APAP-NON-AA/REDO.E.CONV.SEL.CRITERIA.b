*-----------------------------------------------------------------------------
* <Rating>-50</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.E.CONV.SEL.CRITERIA
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Developed By      : Temenos Application Management
*Program   Name    : REDO.E.CONV.SEL.CRITERIA
*--------------------------------------------------------------------------------------------------------
*Description       :  REDO.E.CONV.SEL.CRITERIA is a conversion routine attached to the enquiries
*                     the routine fetches the value from O.DATA delimited with stars and formats them according to the selection criteria and returns
*                     the value back to O.DATA
*In  Parameter     : N/A
*Out Parameter     : N/A
*Files  Used       : N/A
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*      Date          Who             Reference                 Description
*     ------         -----           -------------            -------------
*    14 Sep 2010   MD Preethi      ODR-2010-03-0131 16      Initial creation
*
*********************************************************************************************************

  INSERT I_COMMON
  INSERT I_EQUATE
  INSERT I_ENQUIRY.COMMON

*MAIN.PARA:
***********
  GOSUB PROCESS.PARA
  RETURN

PROCESS.PARA:
**************

  Y.CRITERIA = ''
  Y.OPEN.DATE = FIELD(O.DATA,'*',1,1)
  Y.AGENCY = FIELD(O.DATA,'*',2,1)
  Y.APPL.DATE = FIELD(O.DATA,'*',3,1)
  Y.CLIENT = FIELD(O.DATA,'*',4,1)

  IF Y.OPEN.DATE THEN
    VAR.DATE = 20:Y.OPEN.DATE[1,6]
    GOSUB CHECK.DATE
    VAR.TIME1 = Y.OPEN.DATE[7,2]
    VAR.TIME2 = Y.OPEN.DATE[9,2]
    VAR.TIME = VAR.TIME1:":":VAR.TIME2
    VAR.DATE.TIME = VAR.DATE:" ":VAR.TIME
    Y.CRITERIA = "Fecha Apertura Prist - ":VAR.DATE.TIME:" "
  END
  IF Y.AGENCY THEN
    Y.CRITERIA<-1>= "Agencia del Pristamo - ":Y.AGENCY:" "
  END
  IF Y.APPL.DATE THEN
    VAR.DATE = Y.APPL.DATE
    GOSUB CHECK.DATE
    Y.CRITERIA<-1>= "Fecha Aplicacion - ":VAR.DATE:" "
  END
  IF Y.CLIENT THEN
    Y.CRITERIA<-1>= "Cliente - ":Y.CLIENT
  END
  IF NOT(Y.CRITERIA) THEN
    Y.CRITERIA = 'ALL'
  END
  CHANGE FM TO "," IN Y.CRITERIA
  O.DATA = Y.CRITERIA
  RETURN
*--------------------------------------------------------
CHECK.DATE:
*--------------------------------------------------------

  TEMP.COMI = COMI ; TEMP.N1=N1 ; TEMP.T1 = T1
  COMI= VAR.DATE ; N1=8 ; T1=".D"
  CALL IN2D(N1,T1)
  VAR.DATE = V$DISPLAY
  COMI = TEMP.COMI ; N1 = TEMP.N1 ; T1 = TEMP.T1
  RETURN
*--------------------------------------------
END
