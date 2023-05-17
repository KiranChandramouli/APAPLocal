*-----------------------------------------------------------------------------
*-----------------------------------------------------------------------------
* <Rating>-46</Rating>
*-----------------------------------------------------------------------------
  SUBROUTINE REDO.B.GEN.ACH.OUT.FILE.SELECT
********************************************************
* COMPANY NAME: ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* DEVELOPED BY: Swaminathan.S.R
* PROGRAM NAME: REDO.B.GEN.ACH.OUT.FILE.SELECT
*------------------------------------------------------------------------------
*DESCRIPTION:This is a Multi threaded Select Routine Which is used to select
*a list of ids of FT transactions to be processed
*-------------------------------------------------------------------------------
*IN PARAMETER: NONE
*OUT PARAMETER: NONE
*LINKED WITH: REDO.B.GEN.ACH.OUT.FILE
*-----------------------
* Modification History :
*-----------------------
*DATE             WHO                    REFERENCE            DESCRIPTION
*1-SEP-2010    Swaminathan.S.R          ODR-2009-12-0290    INITIAL CREATION
*12-APR-2013   Karthik Sundararajan     PERF-CHANGE
*-------------------------------------------------------------------------------
$INSERT I_COMMON
$INSERT I_EQUATE
$INSERT I_REDO.B.GEN.ACH.OUT.FILE.COMMON
$INSERT I_GTS.COMMON
$INSERT I_BATCH.FILES
$INSERT I_F.FUNDS.TRANSFER
$INSERT I_F.REDO.ACH.DATE
$INSERT I_F.REDO.INTERFACE.PARAM
$INSERT I_F.REDO.ACH.PARAM
$INSERT I_F.REDO.ACH.PROCESS
$INSERT I_F.REDO.ACH.PROCESS.DET
$INSERT I_F.USER
$INSERT I_F.LOCKING
*---------------------------------------------------------------------------------

  Y.SEL.LIST.FT = ''
  Y.SEL.ID = ''
  Y.ACH.DATE.ID = TODAY

*PERF-CHANGE - .SELECT is processed by a Single agent & No Write is performed F.READU replaced by F.READ
*CALL F.READU(FN.REDO.DUP.ACH.DATE,Y.ACH.DATE.ID,R.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE,REDO.DUP.ACH.DATE.ERR,'')

  CALL F.READ(FN.REDO.DUP.ACH.DATE,Y.ACH.DATE.ID,R.REDO.DUP.ACH.DATE,F.REDO.DUP.ACH.DATE,REDO.DUP.ACH.DATE.ERR)
  IF R.REDO.DUP.ACH.DATE NE '' THEN
    GOSUB MAIN.PROC
  END
*c.22 update part removed as part of performance improvement-Prabhu N
  RETURN
*-------------------------------------------------------------------------------------
**********
MAIN.PROC:
**********
*!* PERF-CHANGE-Start

**This loop for flitering the FT records - avoided by checking these conditions in record routine 'REDO.B.GEN.ACH.OUT.FILE'

*    SEL.FT.ID = R.REDO.DUP.ACH.DATE
*    Y.FT.COUNT = DCOUNT(SEL.FT.ID,FM)
*    Y.CNT = 1
*    LOOP
*    WHILE Y.CNT LE Y.FT.COUNT
*        Y.FT.TXN = SEL.FT.ID<Y.CNT>
*        Y.FT.TXN = TRIM(Y.FT.TXN)
*        IF Y.CNT LE Y.FT.COUNT THEN
*            GOSUB FT.LIVE
*            IF FLAG.FT EQ '' THEN
*                GOSUB FT.HIS
*            END
*            FLAG.FT = ''
*            GOSUB FINAL.ARRAY.LIST
*        END
*        Y.CNT = Y.CNT + 1
*    REPEAT
*    Y.TOTAL = DCOUNT(Y.SEL.LIST.FT,FM)
*    CALL BATCH.BUILD.LIST('',Y.SEL.LIST.FT)
  CALL BATCH.BUILD.LIST('',R.REDO.DUP.ACH.DATE)
*Contains FT Ids alone

*!* PERF-CHANGE-End


  RETURN
*--------------------------------------------------------------------------------------
**********
*FT.LIVE:
**********

*    CALL F.READ(FN.FUNDS.TRANSFER,Y.FT.TXN,R.FUNDS.TRANSFER,F.FUNDS.TRANSFER,Y.ERR.FT)
*    IF R.FUNDS.TRANSFER THEN
*        FLAG.FT = '1'
*        Y.TRAN.TYPE = R.FUNDS.TRANSFER<FT.TRANSACTION.TYPE>
*        Y.RECORD.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
*        IF Y.RECORD.STATUS NE 'REVE' THEN
*            Y.SEL.ID = Y.TRAN.TYPE:"-":Y.FT.TXN
*        END
*    END
*    RETURN
*-----------------------------------------------------------------------------------------
********
*FT.HIS:
********

*    CALL EB.READ.HISTORY.REC(F.FUNDS.TRANSFER.HIS,Y.FT.TXN,R.FUNDS.TRANSFER.HIS,Y.ERR.FTHIS)
*    IF R.FUNDS.TRANSFER.HIS THEN
*        Y.TRAN.TYPE = R.FUNDS.TRANSFER.HIS<FT.TRANSACTION.TYPE>
*        Y.RECORD.STATUS = R.FUNDS.TRANSFER<FT.RECORD.STATUS>
*        IF Y.RECORD.STATUS NE 'REVE' THEN
*            Y.SEL.ID = Y.TRAN.TYPE:"-":Y.FT.TXN
*        END
*    END
*    RETURN
*---------------------------------------------------------------------------------------------
*****************
*FINAL.ARRAY.LIST:
*****************
*    IF Y.SEL.ID NE '' THEN
*        IF Y.SEL.LIST.FT EQ '' THEN
*            Y.SEL.LIST.FT = Y.SEL.ID
*        END ELSE
*            Y.SEL.LIST.FT<-1> = Y.SEL.ID
*        END
*    END
*    RETURN
*---------------------------------------------------------------------------------------------
END
