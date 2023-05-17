*-----------------------------------------------------------------------------
* <Rating>-20</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.FEE.COLLECT.INP
*--------------------------------------------------------------------------
*Company Name      : APAP Bank
*Developed By      : Temenos Application Management
*Program Name      : REDO.FEE.COLLECT.INP
*Date              : 07.12.2010
*-------------------------------------------------------------------------
* Incoming/Outgoing Parameters
*-------------------------------
* In  : --REC.ID--
* Out : --N/A--
*-----------------------------------------------------------------------------
* Revision History:
* -----------------
* Date                   Name                   Reference               Version
* -------                ----                   ----------              --------
*07/12/2010            H Ganesh             ODR-2010-08-0469       Initial Version
*------------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.FEECOLLECT
$INSERT I_F.REDO.TC1020.REASON.CODE
$INSERT I_F.DATES

  GOSUB OPEN.FILES
  GOSUB PROCESS

  RETURN


*------------------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------------------
  Y.YEAR= R.DATES(EB.DAT.TODAY)[1,4]


  COMI=Y.YEAR:R.NEW(REDO.FEE.EVENT.DATE)


  ETEXT = ""
  CALL IN2D("10","D")

  IF ETEXT THEN

    AF=REDO.FEE.EVENT.DATE
    CALL STORE.END.ERROR

  END

  IF R.NEW(REDO.FEE.SOURCE.BIN) EQ R.NEW(REDO.FEE.DESTINATION.BIN) THEN
    AF=REDO.FEE.DESTINATION.BIN
    ETEXT='EB-BIN.CANNOT.SAME'
    CALL STORE.END.ERROR
  END

*REDO.FEE.EVENT.DATE

*REDO.FEE.SOURCE.AMOUNT
*REASON.CODE.MAX.AMOUNT

  SRC.AMT=R.NEW(REDO.FEE.SOURCE.AMOUNT)

  IF (MAX.AMT NE '' AND MAX.AMT NE 0) THEN

    IF SRC.AMT GT MAX.AMT THEN
      AF = REDO.FEE.SOURCE.AMOUNT
      ETEXT="EB-SRC.AMT.GT.MAX.AMT"
      CALL STORE.END.ERROR
    END

  END

  RETURN

OPEN.FILES:
***********
  REASON.CODE.ID=R.NEW(REDO.FEE.REASON.CODE)

  FN.REDO.TC1020.REASON.CODE='F.REDO.TC1020.REASON.CODE'
  F.REDO.TC1020.REASON.CODE=''
  CALL OPF(FN.REDO.TC1020.REASON.CODE,F.REDO.TC1020.REASON.CODE)

  CALL F.READ(FN.REDO.TC1020.REASON.CODE,REASON.CODE.ID,R.REDO.TC1020.REASON.CODE,F.REDO.TC1020.REASON.CODE,ERR)

  MAX.AMT=R.REDO.TC1020.REASON.CODE<REASON.CODE.MAX.AMOUNT>

  RETURN

END
