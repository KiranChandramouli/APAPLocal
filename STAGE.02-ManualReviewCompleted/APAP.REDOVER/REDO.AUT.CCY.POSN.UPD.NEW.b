* @ValidationCode : MjotMzQzNTYyMzQwOkNwMTI1MjoxNjgwNzE0ODg5ODE1Om11dGh1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 05 Apr 2023 22:44:49
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : muthu
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.AUT.CCY.POSN.UPD.NEW
*********************************************************************************************************
*Company   Name    : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
*Program   Name    : REDO.AUT.CCY.POSN.UPD.NEW
*--------------------------------------------------------------------------------------------------------
*Description       : This routine will update the F.REDO.FX.CCY.POSN with only ID's, the actual record will
*                    be written through a onlise service. This is done to avoid locking issuePACS00809542.
**In Parameter     :  N/A
*Out Parameter     :  N/A
*
*--------------------------------------------------------------------------------------------------------
*Modification Details:
*=====================
*  Date            Who                 Reference                       Description
*  ------          ------              -------------                   -------------
* 23-Dec-2019      Nanda               PACS00809542                  To update F.REDO.FX.CCY.POSN only with ID.
* 05-04-2023       CONVERSION TOOL     AUTO R22 CODE CONVERSION      NO CHANGE
* 05-04-2023       MUTHUKUMAR M        MANUAL R22 CODE CONVERSION    NO CHANGE
*********************************************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FOREX
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.TELLER
    $INSERT I_F.REDO.FX.CCY.POSN
    $INSERT I_EB.EXTERNAL.COMMON
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

    Y.CHANNEL.TYPE = EB.EXTERNAL$CHANNEL
    REDO.FX.CCY.POSN.ID = TODAY:'.':ID.NEW:'.':'2'



    FN.REDO.FX.CCY.POSN='F.REDO.FX.CCY.POSN'
    F.REDO.FX.CCY.POSN=''
    R.REDO.FX.CCY.POSN=''

    CALL OPF(FN.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN)

RETURN


PROCESS:
* For reversals call the original routines from here during the online transaction itself.
* For Input update the tables via the online service.

    IF V$FUNCTION EQ 'R' OR Y.REC.STAT[1,3] EQ 'RNA' THEN
        CALL REDO.V.FX.REF.NUM
        CALL REDO.V.FX.CCY.POS
        CALL REDO.V.AUT.UPD.FX.POS

        RETURN
    END

    IF V$FUNCTION EQ 'I' OR Y.REC.STAT[1,3] EQ 'INA' THEN
        IF Y.CHANNEL.TYPE NE 'INTERNET' THEN
            CALL REDO.VAU.FXTT.DSLIP
        END
    END
    CALL F.READU(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID,R.REDO.FX.CCY.POSN,F.REDO.FX.CCY.POSN,POS.ERR,'')
    CALL F.WRITE(FN.REDO.FX.CCY.POSN,REDO.FX.CCY.POSN.ID,R.REDO.FX.CCY.POSN)
RETURN

END
