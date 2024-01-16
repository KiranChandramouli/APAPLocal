* @ValidationCode : Mjo4OTE3NTc2MjU6Q3AxMjUyOjE3MDUwNjgxOTA3NDA6SVRTUzE6LTE6LTE6MDowOmZhbHNlOk4vQTpSMjJfU1A1LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:33:10
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS1
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R22_SP5.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.LAPAP
*-----------------------------------------------------------------------------
* <Rating>169</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.BLD.CL.AZ.CUST.RT(ENQ.DATA)
**===========================================================================================================================================
*** Modification history
*--------------------------
*   DATE          WHO                 REFERENCE               DESCRIPTION
*   12-01-2024    Santosh        R22 MANUAL CONVERSION       BP removed
**===========================================================================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.CUST.PRD.LIST
    $INSERT I_F.AZ.ACCOUNT
*----------------------------------------------------------------
*BUILD.ROUTINE for ENQUIRY>L.APAP.ENQ.AC.API
*This rtn, when just the cust. number is specified on the selection criteria
*it search all account from the specified customer plus its joint holder accs.
*By: J.Q. on Aug 18, 2023.
*----------------------------------------------------------------
    GOSUB INIT
    IF Y.CUSTOMER NE '' AND Y.ACCS EQ '' THEN
        GOSUB FETCH.DATA
        GOSUB SET.DATA
    END

RETURN
INIT:
    LOCATE 'CUSTOMER' IN ENQ.DATA<2,1> SETTING POS ELSE NULL
    Y.CUSTOMER = ENQ.DATA<4,POS>

    LOCATE '@ID' IN ENQ.DATA<2,1> SETTING POS.ACC ELSE NULL
    Y.ACCS = ENQ.DATA<4,POS.ACC>

    FN.PRDLIST = "FBNK.REDO.CUST.PRD.LIST"
    FV.PRDLIST = ""
    CALL OPF(FN.PRDLIST, FV.PRDLIST)


    FN.AC.HIS = 'F.AZ.ACCOUNT$HIS'
    F.AC.HIS = ''
    CALL OPF(FN.AC.HIS,F.AC.HIS)


*DEBUG
RETURN

FETCH.DATA:

    CALL F.READ(FN.PRDLIST,Y.CUSTOMER,R.PRDLIST,FV.PRDLIST,PRDLIST.ERR)
    IF (R.PRDLIST) THEN
        Y.ACC.L = R.PRDLIST<PRD.PRODUCT.ID>
        Y.ACC.S = R.PRDLIST<PRD.PRD.STATUS>
        Y.ACC.TOC =  R.PRDLIST<PRD.TYPE.OF.CUST>

        Y.CNT = DCOUNT(Y.ACC.L,@VM)
        FOR A = 1 TO Y.CNT STEP 1
            CALL EB.READ.HISTORY.REC(F.AC.HIS,Y.ACC.L<1,A>,HIST.REC,YERROR)
            Y.RECORD.STATUS  = HIST.REC<AZ.RECORD.STATUS>
            Y.CURR.NO = HIST.REC<AZ.CURR.NO>

            IF Y.RECORD.STATUS EQ "MAT" THEN
                Y.ALL.ACCOUNTS<-1> =  Y.ACC.L<1,A>  : ';' : Y.CURR.NO
            END

        NEXT A
    END

RETURN

SET.DATA:
    IF Y.ALL.ACCOUNTS THEN
        Y.ACC.FILTER = Y.ALL.ACCOUNTS
        CHANGE @FM TO ' ' IN Y.ACC.FILTER
*If we are here, then replace CUSTOMER Field values, for ACCOUNT @ID values. with this selection criteria will only have account values and customer gets erased.
        ENQ.DATA<4,POS> = Y.ACC.FILTER
        ENQ.DATA<3,POS> = 'EQ'
        ENQ.DATA<2,POS> = '@ID'

    END


*DEBUG
RETURN

END
