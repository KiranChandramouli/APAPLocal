* @ValidationCode : MjoxNDY2MDU3Nzc1OkNwMTI1MjoxNjg0MjIyODMyMjI4OklUU1M6LTE6LTE6MTg2OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 16 May 2023 13:10:32
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 186
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------------
*Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*21/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION       FM TO @FM, VM TO @VM, I TO I.VAR
*21/04/2023         SURESH           MANUAL R22 CODE CONVERSION           NOCHANGE
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FT.AA.OD.SUP

* Client : APAP
* Description: The BEFORE.AUTH.RTN routine attached to verison 'FUNDS.TRANSFER,REDO.REV.TXN' for removing the unauth overdraft for Loan Accounts
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.ACCOUNT

    IF V$FUNCTION NE 'A' THEN
        RETURN
    END


    GOSUB INIT
    GOSUB PROCESS
RETURN

INIT:
*****
    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)
RETURN

PROCESS:
********
    YCR.ACCT = ''; YDB.ACCT = ''
    YCR.ACCT = R.NEW(FT.CREDIT.ACCT.NO)
    YDB.ACCT = R.NEW(FT.DEBIT.ACCT.NO)

    IF ISDIGIT(YDB.ACCT) THEN
        RETURN
    END

    ERR.ACCOUNT = ''; R.ACCOUNT = ''
    CALL F.READ(FN.ACCOUNT,YCR.ACCT,R.ACCOUNT,F.ACCOUNT,ERR.ACCOUNT)
    YARR.ID = R.ACCOUNT<AC.ARRANGEMENT.ID>
    IF YARR.ID [1,2] NE 'AA' THEN
        RETURN
    END

    YARRY.OVERRIDE = ''; YOVERRIDE = ''
    IF R.NEW(FT.OVERRIDE) NE '' THEN
        YOVERRIDE = R.NEW(FT.OVERRIDE)
        FINDSTR 'ACCT.UNAUTH.OD' IN YOVERRIDE<1> SETTING YFM,YSM,YVM ELSE
            RETURN
        END
        YOD.CNT = 0; YOD.CNT = DCOUNT(YOVERRIDE,@VM)
        FOR I.VAR = 1 TO YOD.CNT;*AUTO R22 CODE CONVERSION
            YOVERRIDE.CNT = YOVERRIDE<1,I.VAR>
            IF YOVERRIDE.CNT[1,14] EQ 'ACCT.UNAUTH.OD' THEN
                CONTINUE
            END
            YARRY.OVERRIDE<-1> = YOVERRIDE.CNT

        NEXT I.VAR ;*AUTO R22 CODE CONVERSION

        IF YARRY.OVERRIDE THEN
            CHANGE @FM TO @VM IN YARRY.OVERRIDE
            R.NEW(FT.OVERRIDE) = YARRY.OVERRIDE
        END

    END
RETURN

END
