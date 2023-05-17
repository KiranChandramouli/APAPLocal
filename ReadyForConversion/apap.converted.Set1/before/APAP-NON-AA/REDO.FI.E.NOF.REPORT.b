*--------------------------------------------------------------------------------------------------------
* <Rating>-82</Rating>
****---------------------------------------------------------------------------------------------------
  SUBROUTINE REDO.FI.E.NOF.REPORT(DATREP)
*
*** Subroutine Type : ENQUIRY ROUTINE
* Attached to     : REDO.FI.E.DATREP.
* Attached as     : NOFILE ROUTINE.
* Primary Purpose : To return data to the enquiry.
*
* Incoming:
* ---------
*
*
* Outgoing:
* ---------
* DATREP - data returned to the enquiry
*
* Error Variables:
* ----------------
*
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Juan Pablo Armas - TAM Latin America
* Date            : Oct 26, 2010
* 8th September 2014 - Chnages done as per request by Mari Rosa  - Ega
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.FI.CONTROL
$INSERT I_F.REDO.INTERFACE.ACT.DETAILS
$INSERT I_F.TSA.SERVICE
$INSERT I_F.REDO.INTERFACE.PARAM


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS

  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
*
  Y.FI.CONTROL = Y.ID.INT:'.':Y.NRO.LOTE

  CALL F.READ(FN.REDO.FI.CONTROL,Y.FI.CONTROL,R.REDO.FI.CONTROL,F.REDO.FI.CONTROL,YRFC.ERROR)
  IF R.REDO.FI.CONTROL THEN
    GOSUB GET.DATA.DETAILS
  END ELSE
    ENQ.ERROR<-1>="NO EXISTE INFORMACION EN REDO.FI.CONTROL"
  END


  RETURN
*-----------------------------------------------------------------------------------*
GET.DATA.DETAILS:
*================
*

  Y.FEC.PROC = R.REDO.FI.CONTROL<REDO.FI.CON.PROC.DATE>
  Y.NOM.ARCH = R.REDO.FI.CONTROL<REDO.FI.CON.FILE.NAME>

  Y.PROC     = R.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORD.PROC>
  Y.PROC.AMT = R.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC>
  Y.PROC     = FMT(Y.PROC,"R,#15")
  Y.PROC.AMT = FMT(Y.PROC.AMT,"R2,#15")

  Y.OK       = R.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.OK>
  Y.OK.AMT   = R.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.OK>
  Y.OK       = FMT(Y.OK,"R,#15")
  Y.OK.AMT   = FMT(Y.OK.AMT,"R2,#15")

  Y.FAIL     = R.REDO.FI.CONTROL<REDO.FI.CON.TOT.RECORDS.FAIL>
  Y.FAIL.AMT = R.REDO.FI.CONTROL<REDO.FI.CON.AMOUNT.PROC.FAIL>
  Y.FAIL     = FMT(Y.FAIL,"R,#15")
  Y.FAIL.AMT = FMT(Y.FAIL.AMT,"R2,#15")
  GOSUB GET.TOTALS
  GOSUB STORE.INFORMATION

  Y.INT.CNT = 1
  Y.TXN.COUNT = DCOUNT(R.REDO.FI.CONTROL<REDO.FI.CON.ACCOUNT.NUMBER>,VM)
  LOOP
  WHILE Y.INT.CNT LE Y.TXN.COUNT
    Y.ACCOUNT.NUMBER =  R.REDO.FI.CONTROL<REDO.FI.CON.ACCOUNT.NUMBER,Y.INT.CNT>
    Y.CUSTOMER.NUMBER=  R.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NUMBER,Y.INT.CNT>
    Y.CUSTOMER.NAME  =  R.REDO.FI.CONTROL<REDO.FI.CON.CUSTOMER.NAME,Y.INT.CNT>
    Y.TXN.AMOUNT     =  R.REDO.FI.CONTROL<REDO.FI.CON.TXN.AMOUNT,Y.INT.CNT>
    Y.TXN.STATUS     =  R.REDO.FI.CONTROL<REDO.FI.CON.TXN.STATUS,Y.INT.CNT>
    Y.DESCRIPTION    =  R.REDO.FI.CONTROL<REDO.FI.CON.DESCRIPTION,Y.INT.CNT>
    Y.FT.REFERENCE   =  R.REDO.FI.CONTROL<REDO.FI.CON.FT.REFERENCE,Y.INT.CNT>
    Y.VAR.AUX = Y.INT.CNT:'*':Y.ACCOUNT.NUMBER:'*':Y.CUSTOMER.NUMBER:'*':Y.CUSTOMER.NAME:'*':Y.TXN.AMOUNT:'*':Y.TXN.STATUS:'*':Y.DESCRIPTION:'*':Y.FT.REFERENCE
    DATREP<-1> = Y.VAR.AUX
    Y.INT.CNT++
  REPEAT

  RETURN
*
* =========
GET.TOTALS:
* =========
*
*-------------------------------------
* Armando los totales
*-------------------------------------
  BEGIN CASE
  CASE Y.ID.INT EQ 'BACEN'
*Y.VAR.AUX.END = 'Pago de Inter*eses Inversion*es Banco Central***'
    Y.VAR.AUX.END = 'Pago de Intereses Inversiones Banco Central***'
  CASE Y.ID.INT EQ 'ORANGE'
    Y.VAR.AUX.END = 'Orange Debito Directo****'
  CASE 1
    Y.VAR.AUX.END = 'Interfaces Planas****'
  END CASE
*
  RETURN
*
* ================
STORE.INFORMATION:
* ================
  CALL EB.DATE.FORMAT.DISPLAY(Y.FEC.PROC,Y.FEC.PROC.DISP,'','')
  DATREP<-1> = Y.VAR.AUX.END
*Y.VAR.AUX.END = 'Fecha de Apli*cacion*: ':OCONV(ICONV(Y.FEC.PROC,"D4/E"),"D4"):'****'
  Y.VAR.AUX.END = 'Fecha de Aplicacion*: ':Y.FEC.PROC.DISP:'****'
  DATREP<-1> = Y.VAR.AUX.END
*Y.VAR.AUX.END = 'Nombre del ar*chivo procesado*':': ':Y.NOM.ARCH:'****'
  Y.VAR.AUX.END = 'Nombre del archivo procesado*':': ':Y.NOM.ARCH:'****'
  DATREP<-1> = Y.VAR.AUX.END
* Ega - S
  CALL F.READ(FN.TSA.SERVICE,"BNK/REDO.FI.INTERFACE",R.TSA.SERVICE,F.TSA.SERVICE,SERVICE.ERR)
  Y.AGENCI = R.TSA.SERVICE<TS.TSM.CO.CODE>
  Y.INPUTTER = R.TSA.SERVICE<TS.TSM.INPUTTER>
  Y.INPUTTER = FIELD(Y.INPUTTER,"_",2,1)
  Y.AUTHORISER = R.TSA.SERVICE<TS.TSM.AUTHORISER>
  Y.AUTHORISER = FIELD(Y.AUTHORISER,"_",2,1)
  Y.FACE.ID = Y.NRO.LOTE[1,4]
  Y.FACE.ID = Y.FACE.ID + "0"
  CALL F.READ(FN.REDO.INTERFACE.PARAM,Y.FACE.ID,R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,INT.ERR)
  Y.NAME = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.NAME>
  Y.PARAM.TYPE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
  Y.PARAM.VALUE = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
  Y.PARAM.VALUE = Y.PARAM.VALUE<1,1>

  CALL INT.ACC(Y.PARAM.VALUE,Y.D.FLG1)
  IF Y.PARAM.VALUE AND Y.D.FLG1 EQ '1' THEN
    Y.METHOD.PAYMENT = "CAJA"
  END ELSE
    Y.METHOD.PAYMENT =  "TRANSFERENCIA"
  END
  Y.METHOD.VALUE = Y.PARAM.VALUE

  Y.VAR.AUX.END = 'Codigo Cliente*':': ':Y.NAME
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Forma de Pago*':': ':Y.METHOD.PAYMENT:'****':      'Cta.Debito*':': ':Y.METHOD.VALUE
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Agencia*':': ':Y.AGENCI:'****':    'Ingresador*':': ':Y.INPUTTER
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Autorizador*':': ':Y.AUTHORISER
  DATREP<-1> = Y.VAR.AUX.END
* Ega - E

*Y.VAR.AUX.END = '_____________*___________________*______________________*___________________***'
  Y.VAR.AUX.END = '__________________________*___________________*______________________*___________________*______________________***'

  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'TOTALES*   Procesados*   Satisfactorios*   Rechazados**'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Total Regs*':Y.PROC:'*':Y.OK:'*':Y.FAIL:'**'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Monto Total*':Y.PROC.AMT:'*':Y.OK.AMT:'*':Y.FAIL.AMT:'**'
  DATREP<-1> = Y.VAR.AUX.END
*Y.VAR.AUX.END = '_____________*___________________*______________________*___________________***'
  Y.VAR.AUX.END = '__________________________*___________________*______________________*___________________*______________________***'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.FIRST = '******'
  DATREP<-1> = Y.VAR.AUX.FIRST
  Y.VAR.AUX.FIRST = 'Num Registro*Numero Cuenta*Codigo Cliente*Nombre Cliente*-999*Estatus*Descripcion*FT Asociada'
  DATREP<-1> = Y.VAR.AUX.FIRST
  Y.VAR.AUX.FIRST = '******'
  DATREP<-1> = Y.VAR.AUX.FIRST
*

  RETURN
*
*-----------------------------------------------------------------------------------*
INITIALISE:
*=========
* Variables
  PROCESS.GOAHEAD = 1

* Punteros
  FN.REDO.FI.CONTROL = 'F.REDO.FI.CONTROL'
  F.REDO.FI.CONTROL  = ''

  FN.TSA.SERVICE = "F.TSA.SERVICE"
  F.TSA.SERVICE = ""
  CALL OPF(FN.TSA.SERVICE,F.TSA.SERVICE)
  R.TSA.SERVICE = ""

  FN.REDO.INTERFACE.PARAM = "F.REDO.INTERFACE.PARAM"
  F.REDO.INTERFACE.PARAM = ""
  CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
  R.REDO.INTERFACE.PARAM = ""
*
  RETURN  ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.REDO.FI.CONTROL,F.REDO.FI.CONTROL)

  RETURN  ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
CHECK.PRELIM.CONDITIONS:
*======================
*
  LOOP.CNT = 1 ;     MAX.LOOPS = 2
  LOOP
  WHILE LOOP.CNT LE MAX.LOOPS AND PROCESS.GOAHEAD DO
    BEGIN CASE
    CASE LOOP.CNT EQ 1
*
*  Recupera los valores de los parametros de entrada
*  ID.INT = ID Interface
      LOCATE 'ID.INT' IN D.FIELDS<1> SETTING Y.ID.INT.POS THEN
        Y.ID.INT = D.RANGE.AND.VALUE<Y.ID.INT.POS>
      END ELSE
        PROCESS.GOAHEAD = 0
        ENQ.ERROR<-1>="FALTA ID DE INTERFACE"
      END

    CASE LOOP.CNT EQ 2
*  NRO.LOTE = Numero de Lote del archivo
      LOCATE 'NRO.LOTE' IN D.FIELDS<1> SETTING Y.NRO.LOTE.POS THEN
        Y.NRO.LOTE = D.RANGE.AND.VALUE<Y.NRO.LOTE.POS>
      END ELSE
        PROCESS.GOAHEAD = 0
        ENQ.ERROR<-1>="FALTA NUMERO DE LOTE"
      END

    END CASE
    LOOP.CNT +=1
  REPEAT
*
  RETURN  ;* From CHECK.PRELIM.CONDITIONS
*-----------------------------------------------------------------------------------

END
