*-----------------------------------------------------------------------------
* <Rating>10</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.VAL.LETTER.ACCT
***********************************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: H GANESH
* PROGRAM NAME: REDO.VAL.LETTER.ACCT
* ODR NO      : ODR-2009-10-0838
*----------------------------------------------------------------------
*DESCRIPTION: This is the Validation Routine for REDO.LETTER.ISSUE to
*CHECK THE CUSTOMER ACCOUNT IS ACTIVE OR NOT

*IN PARAMETER:  NA
*OUT PARAMETER: NA
*LINKED WITH: REDO.LETTER.ISSUE
*----------------------------------------------------------------------
* Modification History :
*-----------------------
*DATE           WHO           REFERENCE         DESCRIPTION
*08.06.2010    RIYAS          PACS00072842   INITIAL CREATION
*----------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.ACCOUNT
$INSERT I_F.REDO.LETTER.ISSUE
  GOSUB INIT
  GOSUB OPENFILES
  GOSUB LOCAL.REF
  GOSUB PROCESS
  RETURN
*----------------------------------------------------------------------
INIT:
*----------------------------------------------------------------------
  FN.ACCOUNT='F.ACCOUNT'
  F.ACCOUNT=''
  RETURN
*----------------------------------------------------------------------
OPENFILES:
*----------------------------------------------------------------------
  CALL OPF(FN.ACCOUNT,F.ACCOUNT)
  RETURN
*----------------------------------------------------------------------
LOCAL.REF:
*----------------------------------------------------------------------
  LOC.REF.APPLICATION="ACCOUNT"
  LOC.REF.FIELDS='L.AC.STATUS1'
  LOC.REF.POS=''
  CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
  RETURN
*----------------------------------------------------------------------
PROCESS:
*----------------------------------------------------------------------


  POS.L.AC.STATUS1=LOC.REF.POS<1,1>
  Y.PRODUCTS=R.NEW(REDO.LET.ISS.PRODUCTS)
  T.TOT.COUNT=DCOUNT(Y.PRODUCTS,VM)
  Y.CNT=1
  LOOP
  WHILE Y.CNT LE T.TOT.COUNT
    Y.ACC.ID=R.NEW(REDO.LET.ISS.PRODUCTS)<1,Y.CNT>
    CALL F.READ(FN.ACCOUNT,Y.ACC.ID,R.ACCOUNT,F.ACCOUNT,CUS.ERR)
    Y.STATUS = R.ACCOUNT<AC.LOCAL.REF,POS.L.AC.STATUS1>
    IF Y.ACC.ID THEN
      IF Y.STATUS THEN
        IF Y.STATUS NE 'ACTIVE' THEN
          AF=REDO.LET.ISS.PRODUCTS
          AV=Y.CNT
          ETEXT="EB-ACCOUNT.STATUS"
          CALL STORE.END.ERROR
        END
      END
    END
    Y.CNT = Y.CNT + 1
  REPEAT
  RETURN
END
