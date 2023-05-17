*-----------------------------------------------------------------------------
* <Rating>-64</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.MAIL.FORMAT.GEN(Y.FI.CONTROL,DATREP)
*
* Subroutine Type : ENQUIRY ROUTINE
* Attached to     : REDO.FI.E.DATREP
* Attached as     : NOFILE ROUTINE
* Primary Purpose : To return data to the enquiry
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
*
*-----------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_ENQUIRY.COMMON
$INSERT I_GTS.COMMON
$INSERT I_F.REDO.FI.CONTROL
$INSERT I_F.REDO.INTERFACE.ACT.DETAILS


  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN  ;* Program RETURN
*-----------------------------------------------------------------------------------
PROCESS:
*======
*

  CALL F.READ(FN.REDO.FI.CONTROL,Y.FI.CONTROL,R.REDO.FI.CONTROL,F.REDO.FI.CONTROL,YRFC.ERROR)
  IF R.REDO.FI.CONTROL THEN
    GOSUB GET.DATA.DETAILS
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
    Y.TXN.AMOUNT     =  FMT(R.REDO.FI.CONTROL<REDO.FI.CON.TXN.AMOUNT,Y.INT.CNT>,"R2,#15")
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
  Y.ID.INT = FIELD(Y.FI.CONTROL,'.',1)
  BEGIN CASE
  CASE Y.ID.INT EQ 'BACEN'
    Y.VAR.AUX.END = 'Pago de Inter*eses Inversione*s Banco Central***'
  CASE Y.ID.INT EQ 'ORANGE'
    Y.VAR.AUX.END = 'Orange Debito* Directo****'
  CASE 1
    Y.VAR.AUX.END = 'Interfaces Pl*anas****'
  END CASE
*
  RETURN
*
* ================
STORE.INFORMATION:
* ================
*
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Fecha de Apli*cacion*: ':OCONV(ICONV(Y.FEC.PROC,"D4/E"),"D4"):'****'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Nombre del ar*chivo procesado*':': ':Y.NOM.ARCH:'****'
  DATREP<-1> = Y.VAR.AUX.END

  Y.VAR.AUX.END = '_____________*___________________*______________________*___________________***'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'TOTALES*   Procesados*   Satisfactorios*   Rechazados**'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Total Regs*':Y.PROC:'*':Y.OK:'*':Y.FAIL:'**'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = 'Monto Total*':Y.PROC.AMT:'*':Y.OK.AMT:'*':Y.FAIL.AMT:'**'
  DATREP<-1> = Y.VAR.AUX.END
  Y.VAR.AUX.END = '_____________*___________________*______________________*___________________***'
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

  RETURN  ;* From INITIALISE
*-----------------------------------------------------------------------------------
OPEN.FILES:
*=========
  CALL OPF(FN.REDO.FI.CONTROL,F.REDO.FI.CONTROL)

  RETURN  ;* From OPEN.FILES
*-----------------------------------------------------------------------------------
END
