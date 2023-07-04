* @ValidationCode : MjotMTMxMDYxNjk5ODpDcDEyNTI6MTY4Mzg5MjY0NzU0NjpJVFNTMTotMTotMTowOjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 May 2023 17:27:27
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.INP.CCY.POSN.UPD.NEW
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.INP.CCY.POSN.UPD.NEW
*--------------------------------------------------------------------------------------------------------
*Description       : This routine will update the F.REDO.FX.CCY.POSN with only ID's, the actual record will
*                    be written through a onlise service. This is done to avoid locking issuePACS00809542.
**In Parameter     :  N/A
*Out Parameter     :  N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date            Who                 Reference                    Description
*  ------          ------              -------------                -------------
* 23-Dec-2019      Nanda               PACS00809542          To update F.REDO.FX.CCY.POSN only with ID.
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*11/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION             NOCHANGE
*11/04/2023         SURESH           MANUAL R22 CODE CONVERSION           CALL Rtn format modified
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FX.CCY.POSN
    GOSUB INIT
    IF Y.PERF.FLAG ELSE
        GOSUB PROCESS
    END
RETURN

INIT:
    Y.PERF.FLAG = ''
    REDO.FX.CCY.POSN.ID = ''
    BEGIN CASE

        CASE (APPLICATION EQ 'TELLER')

            Y.REC.STAT = R.NEW(TT.TE.RECORD.STATUS)
            Y.PERF.DCCY = R.NEW(TT.TE.CURRENCY.1)
            Y.PERF.CCCY = R.NEW(TT.TE.CURRENCY.2)

        CASE (APPLICATION EQ 'FUNDS.TRANSFER')

            Y.REC.STAT = R.NEW(FT.RECORD.STATUS)
            Y.PERF.DCCY = R.NEW(FT.DEBIT.CURRENCY)
            Y.PERF.CCCY = R.NEW(FT.CREDIT.CURRENCY)

        CASE (APPLICATION EQ 'FOREX')

            Y.REC.STAT = R.NEW(FX.RECORD.STATUS)
            Y.PERF.DCCY = R.NEW(FX.CURRENCY.SOLD)
            Y.PERF.CCCY = R.NEW(FX.CURRENCY.BOUGHT)

    END CASE

    IF Y.PERF.DCCY EQ LCCY AND Y.PERF.CCCY EQ LCCY THEN
        Y.PERF.FLAG = '1'
    END

    REDO.FX.CCY.POSN.ID = TODAY:'.':ID.NEW:'.':'1'
    FN.REDO.FX.CCY.POSN='F.REDO.FX.CCY.POSN'
    F.REDO.FX.CCY.POSN=''
    R.REDO.FX.CCY.POSN=''

    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)
RETURN


PROCESS:
    IF (V$FUNCTION EQ 'D' AND Y.REC.STAT EQ 'INAU') OR (V$FUNCTION EQ 'R' AND Y.REC.STAT EQ '') OR (V$FUNCTION EQ 'D' AND Y.REC.STAT EQ 'RNAU') THEN
*       CALL APAP.TAM.REDO.TXN.INP.CCY.POSN.UPD  ;* Record will not be available when deleted from INAU, so online service will not have a r.new to use.
* For delete/reversal cases call the original rtn.
        CALL APAP.TAM.redoTxnInpCcyPosnUpd ;*MANUAL R22 CODE CONVERSION
        RETURN
    END

    CALL F.READU(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,POS.ERR,'')
    CALL F.WRITE(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID,R.REDO.FX.CCY.POSN)
RETURN

END
