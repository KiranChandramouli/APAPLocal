*-----------------------------------------------------------------------------
* <Rating>-67</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FI.RIP.PLANILLA.INP.RTN
*-----------------------------------------------------------------------------
* Subroutine Type : Subroutine
* Attached to     : VERSION  REDO.INTERFACE.PARAM,PLANILLA
* Attached as     : Subroutine
* Primary Purpose : Validate that the internal account to debit and incoming transaction are mutually exclusive
*
* Incoming:
* ---------
*
* Outgoing:
* ---------
*
* Error Variables:
* ----------------
*
*-----------------------------------------------------------------------------------
* Modification History:
*
* Development for : Asociacion Popular de Ahorros y Prestamos
* Development by  : Ana Noriega - TAM Latin America
* Date            : Nov 23, 2010
*
*-----------------------------------------------------------------------------------

$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.TSA.SERVICE
*
$INSERT I_F.REDO.INTERFACE.PARAM

*
*************************************************************************
*

  GOSUB INITIALISE
  GOSUB OPEN.FILES
  GOSUB CHECK.PRELIM.CONDITIONS
  IF PROCESS.GOAHEAD THEN
    GOSUB PROCESS
  END
*
  RETURN
*
* ======
PROCESS:
* ======
*
*  Principal Process
*


  IF Y.VAL.DEB.ACC THEN
    CALL F.READ(FN.ACCOUNT,Y.VAL.DEB.ACC,R.ACCOUNT,F.ACCOUNT,Y.ERR)
    IF Y.ERR THEN
      AF = REDO.INT.PARAM.PARAM.VALUE
      ETEXT = "EB-Account.Doesnot.Exist.&":FM:Y.VAL.DEB.ACC
      CALL  STORE.END.ERROR
    END
  END


  IF ID.NEW NE 'PLANILLA' THEN
    GOSUB CHECK.PATH.FILES
  END

  IF Y.RIP.NEW.CONTROL NE Y.RIP.OLD.CONTROL AND NOT(ETEXT) THEN
    NEW.TASK = "QUERY REDO.FI.E.PLANILLA.MAIN"
    CALL EB.SET.NEW.TASK(NEW.TASK)
  END

  RETURN

* ==============
CHECK.PATH.FILES:
* ==============

  FI.FILE.GEN.ID = ID.NEW
  PLANILLA.ID = 'PLANILLA'
  CALL F.READ(FN.REDO.INTERFACE.PARAM,PLANILLA.ID,R.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM,RIP.ERR)
  RIP.PLANILLA.PARAM     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.TYPE>
  RIP.PLANILLA.VALUE     = R.REDO.INTERFACE.PARAM<REDO.INT.PARAM.PARAM.VALUE>
  FI.SEND.PATH = ''
  FILE.SEND.ID   = "PATH.SEND"          ;* Directory path to store the process file
  WPARAM.POS = 1
  LOCATE FILE.SEND.ID IN RIP.PLANILLA.PARAM<1,WPARAM.POS> SETTING PARAM.POS THEN
    FI.SEND.PATH  = RIP.PLANILLA.VALUE<1,PARAM.POS>
    FI.SEND.PATH = FI.SEND.PATH:"/":FI.FILE.GEN.ID
  END

  OPEN FI.SEND.PATH ELSE
    X.CMD = "CREATE.FILE ":FI.SEND.PATH:" TYPE=UD"
    EXECUTE X.CMD
  END


  Y.SEL.CMD = "SELECT " : FI.SEND.PATH
  CALL EB.READLIST(Y.SEL.CMD,FILE.GEN.LIST,"",NO.OF.REC,YER.SEL)
  IF NO.OF.REC GT 0 THEN
    AF = REDO.INT.PARAM.SERVICE.CONTROL
    ETEXT = 'EB-REDO.PLANILLA.FILE.GENERATED'
    CALL STORE.END.ERROR
  END

  RETURN
*
* =======
GET.DATA:
* =======
*
*   Get value to param: Internal Debit Account
*
  Y.PARAM.POS = 1
  LOCATE Y.PARAM.DEB.ACC IN Y.RIP.PARAM<1,Y.PARAM.POS> SETTING PARAM.POS THEN
    Y.VAL.DEB.ACC = Y.RIP.VALUE<1,PARAM.POS>
    AV = PARAM.POS
  END
*
*   Get value to param: Validate with Transaction
*
  RETURN
*
* =========
INITIALISE:
* =========
*
*  Inicialise Variables
*
  PROCESS.GOAHEAD            = 1

*
  FN.ACCOUNT                 = "F.ACCOUNT"
  F.ACCOUNT                  = ""

  FN.REDO.INTERFACE.PARAM    = "F.REDO.INTERFACE.PARAM"
  F.REDO.INTERFACE.PARAM     = ""

*
  Y.RIP.PARAM                    = R.NEW(REDO.INT.PARAM.PARAM.TYPE)
  Y.RIP.VALUE                    = R.NEW(REDO.INT.PARAM.PARAM.VALUE)
  Y.RIP.NEW.CONTROL              = R.NEW(REDO.INT.PARAM.SERVICE.CONTROL)
  Y.RIP.OLD.CONTROL              = R.OLD(REDO.INT.PARAM.SERVICE.CONTROL)
*
  Y.PARAM.DEB.ACC            = "CTA.INTER"
*
  Y.VAL.DEB.ACC              = ""
*
*  Set variables with values to validate
*
  GOSUB GET.DATA
*
  RETURN
*
* =========
OPEN.FILES:
* =========
*
*  OPEN FILES

  CALL OPF(FN.REDO.INTERFACE.PARAM,F.REDO.INTERFACE.PARAM)
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)

  RETURN
*
* ======================
CHECK.PRELIM.CONDITIONS:
* ======================
*
  IF Y.VAL.DEB.ACC EQ "" AND ID.NEW NE 'PLANILLA' THEN
    AF = REDO.INT.PARAM.PARAM.VALUE
    ETEXT = "EB-Need.To.Input.DebAcc"
    CALL  STORE.END.ERROR
  END

  RETURN
*
END
