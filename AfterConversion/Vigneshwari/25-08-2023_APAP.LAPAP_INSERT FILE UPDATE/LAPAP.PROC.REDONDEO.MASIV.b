* @ValidationCode : MjotNzMzMTA4ODAzOkNwMTI1MjoxNjkyOTYyOTAwMzc0OnZpZ25lc2h3YXJpOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 25 Aug 2023 16:58:20
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : vigneshwari
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
    SUBROUTINE LAPAP.PROC.REDONDEO.MASIV(Y.PARAM, Y.USR_CREDENTIALS ,Y.RABBIT.MQ.OUT)
*--------------------------------------------------------------------------------
*PGM Desc.:
*By: J.Q. (APAP) on Feb 16, 2023
*--------------------------------------------------------------------------------
*-----------------------------------------------------------------------------------------------------------------------
*Modification HISTORY:
*DATE	          AUTHOR		 Modification                   DESCRIPTION
*25/08/2023	 VIGNESHWARI	    MANUAL R22 CODE CONVERSION	  NOCHANGE
*25/08/2023	 CONVERSION TOOL    AUTO R22 CODE CONVERSION	   T24.BP is removed in insertfile
*-----------------------------------------------------------------------------------------------------------------------
    $INCLUDE  I_COMMON  ;*AUTO R22 CODE CONVERSION-START- T24.BP IS REMOVED IN INSERT FILE
    $INCLUDE  I_EQUATE
    $INCLUDE  I_GTS.COMMON ;*AUTO R22 CODE CONVERSION-END
    $INCLUDE  I_F.ST.LAPAP.CRC.ROUNDUP.DET ;*AUTO R22 CODE CONVERSION-BP IS REMOVED IN INSERT FILE
    $INCLUDE  I_F.ST.LAPAP.CRC.ROUNDUP  ;*AUTO R22 CODE CONVERSION-BP IS REMOVED IN INSERT FILE

    GOSUB INI
    GOSUB TRANSFORM
    RETURN

INI:
*ENV VARIABLES
    IF PUTENV('OFS_SOURCE=CR.CTA.OFS') THEN NULL
    CALL JF.INITIALISE.CONNECTION


*OPF
    FN.CRC.ROUNDUP = 'FBNK.ST.LAPAP.CRC.ROUNDUP'
    F.CRC.ROUNDUP = ''
    CALL OPF(FN.CRC.ROUNDUP,F.CRC.ROUNDUP)

    FN.CRC.ROUNDUP.DET = 'FBNK.ST.LAPAP.CRC.ROUNDUP.DET'
    F.CRC.ROUNDUP.DET = ''
    CALL OPF(FN.CRC.ROUNDUP.DET,F.CRC.ROUNDUP.DET)
    RETURN

TRANSFORM:
    IF TRIM(Y.PARAM, " ", "R") = ""  THEN
        Y.ERROR<1> = 1
        Y.ERROR<2> = "BLANK MESSAGE"
        RETURN
    END

    CALL L.APAP.JSON.STRINGIFY(Y.PARAM , JSON.REQUEST)
*----------------LOAD DYN FROM JSON ---------------------------
    CALL L.APAP.JSON.TO.DYN.OFS(JSON.REQUEST, Y.DYN.REQUEST.KEY, Y.DYN.REQUEST.VALUE, Y.DYN.REQUEST.TYPE, Y.ERROR)
    IF Y.ERROR<1> = 1 THEN
        RETURN
    END

    Y.PYMT.ID        = Y.DYN.REQUEST.VALUE<1>
    Y.EXEC.DATE      = Y.DYN.REQUEST.VALUE<2>
    Y.TXNS                   = Y.DYN.REQUEST.VALUE<3>

    DATE.STAMP = OCONV(DATE(), 'D4-')
    TIME.STAMP = TIMEDATE()
    DATE.TIME  = DATE.STAMP[9,2]:DATE.STAMP[1,2]:DATE.STAMP[4,2]:TIME.STAMP[1,2]:TIME.STAMP[4,2]
    Y.BATCH.ID = 'RU.':DATE.TIME

    CHANGE ']'  TO @VM IN Y.TXNS
    GOSUB INS.DET
    GOSUB INS.HEAD
    RETURN

INS.DET:
    CANT_OBJECT = DCOUNT(Y.TXNS     , @VM)
    FOR CONTA=1 TO CANT_OBJECT STEP 1
        Y.REGISTER= Y.TXNS<1,CONTA>
        CHANGE ',' TO @FM IN Y.REGISTER
        CHANGE ':' TO @VM IN Y.REGISTER
        Y.TXN.ID.EXT = CHANGE(Y.REGISTER<1,2>,'"','');
        Y.CR.ACCOUNT = CHANGE(Y.REGISTER<2,2>,'"','');
        Y.CR.CCY     = CHANGE(Y.REGISTER<3,2>,'"','');
        Y.CR.AMOUNT  = CHANGE(Y.REGISTER<4,2>,'"','');
        Y.CR.COMMENT = CHANGE(Y.REGISTER<5,2>,'"','');
        CHANGE '}' TO '' IN Y.CR.COMMENT

        Y.REC.ID = Y.BATCH.ID : '.' : CONTA

        R.DET = ''
        R.DET<ST.LAP50.CRC.ROUNDUP.ID> = Y.BATCH.ID
        R.DET<ST.LAP50.CREDIT.ACCOUNT> = Y.CR.ACCOUNT
        R.DET<ST.LAP50.CREDIT.CCY> = Y.CR.CCY
        R.DET<ST.LAP50.CREDIT.AMOUNT> = Y.CR.AMOUNT
        R.DET<ST.LAP50.TRANSACTION.ID> = Y.TXN.ID.EXT
        R.DET<ST.LAP50.COMMENTS> = Y.CR.COMMENT
        R.DET<ST.LAP50.STATUS> = 'PENDING'

        CALL F.WRITE(FN.CRC.ROUNDUP.DET, Y.REC.ID, R.DET)
        CALL JOURNAL.UPDATE('')
    NEXT CONTA
    RETURN

INS.HEAD:
    CHANGE '-' TO '' IN Y.EXEC.DATE
    R.HEAD = ''
    R.HEAD<ST.LAP68.PAYMENT.ID> = Y.PYMT.ID
    R.HEAD<ST.LAP68.EXEC.DATE> = Y.EXEC.DATE
    R.HEAD<ST.LAP68.BATCH.STATUS> = 'PENDING'
    R.HEAD<ST.LAP68.TXNS.QTY> = CONTA

    CALL F.WRITE(FN.CRC.ROUNDUP, Y.BATCH.ID, R.HEAD)
    CALL JOURNAL.UPDATE('')
    RETURN
END
