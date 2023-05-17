*-----------------------------------------------------------------------------
* <Rating>-30</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.V.VAL.NCF.ISSUE.TXN
*------------
*DESCRIPTION:
*------------
* This routine is used to create a Template named REDO.L.NCF.ISSUE
*

*--------------
* Input/Output:
*--------------
* IN  : -NA-
* OUT : -NA-

*--------------
* Dependencies:
*---------------
* CALLS : -NA-
* CALLED BY : -NA-

*------------------
* Revision History:
*------------------
*   Date               who           Reference            Description
* 23-JAN-2010         Prabhu N       PACS00169424         Initial Creation
* ----------------------------------------------------------------------------
* <region name= Inserts>
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_F.REDO.L.NCF.ISSUE
$INSERT I_Table


  Y.TXN.ID = R.NEW(NCF.IS.TXN.REFERENCE)
  Y.AVAIL=1

  GOSUB INIT
  GOSUB PROCESS.LIVE.READ

  IF NOT(Y.AVAIL) THEN
    ETEXT='EB-NO.RECORD'
    CALL STORE.END.ERROR
  END

  RETURN
*-------
INIT:
*-------
  FN.FUNDS.TRANSFER='F.FUNDS.TRANSFER'
  F.FUNDS.TRANSFER =''
  CALL OPF(FN.FUNDS.TRANSFER,F.FUNDS.TRANSFER)

  FN.FUNDS.TRANSFER$HIS='F.FUNDS.TRANSFER$HIS'
  F.FUNDS.TRANSFER$HIS=''
  CALL OPF(FN.FUNDS.TRANSFER$HIS,F.FUNDS.TRANSFER$HIS)

  FN.TELLER='F.TELLER'
  F.TELLER =''
  CALL OPF(FN.TELLER,F.TELLER)

  FN.TELLER$HIS='F.TELLER$HIS'
  F.TELLER$HIS=''
  CALL OPF(FN.TELLER$HIS,F.TELLER$HIS)

  FN.DATA.CAPTURE='F.DATA.CAPTURE'
  F.DATA.CAPTURE =''
  CALL OPF(FN.DATA.CAPTURE,F.DATA.CAPTURE)

  FN.DATA.CAPTURE$HIS='F.DATA.CAPTURE$HIS'
  F.DATA.CAPTURE$HIS =''
  CALL OPF(FN.DATA.CAPTURE$HIS,F.DATA.CAPTURE$HIS)

  RETURN
*----------------
PROCESS.LIVE.READ:
*----------------
  Y.ERR=''
  CALL F.READ(FN.FUNDS.TRANSFER,Y.TXN.ID,R.RECORD,F.FUNDS.TRANSFER,Y.ERR)
  IF Y.ERR THEN
    Y.ERR=''
    CALL F.READ(FN.TELLER,Y.TXN.ID,R.RECORD,F.TELLER,Y.ERR)
    IF Y.ERR THEN
      Y.ERR=''
      CALL F.READ(FN.DATA.CAPTURE,Y.TXN.ID,R.RECORD,F.DATA.CAPTURE,Y.ERR)
      IF Y.ERR THEN
        GOSUB PROCESS.HIST.READ
      END
    END
  END
  RETURN

*----------------
PROCESS.HIST.READ:
*----------------
  CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER$HIS,Y.TXN.ID,R.RECORD,Y.ER)
  IF Y.ER THEN
    Y.ER=''
    CALL EB.READ.HISTORY.REC(F.TELLER$HIS,Y.TXN.ID,R.RECORD,Y.ER)
    IF Y.ER THEN
      Y.ER=''
      CALL EB.READ.HISTORY.REC(F.DATA.CAPTURE$HIS,Y.TXN.ID,R.RECORD,Y.ER)
      IF Y.ER THEN
        Y.AVAIL=''
      END
    END
  END
  RETURN
END
