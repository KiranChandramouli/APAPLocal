* @ValidationCode : MjotMTE5MjE3OTQzNzpDcDEyNTI6MTcwNTA2ODE1MDc1NzpJVFNTMTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMl9TUDUuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:32:30
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
* <Rating>159</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE LAPAP.BLD.ACC.CUST.RT(ENQ.DATA)
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
*DEBUG
RETURN

FETCH.DATA:
    Y.ALL.ACCOUNTS = ''
    Y.SEL.CMD = 'SELECT FBNK.ACCOUNT WITH CUSTOMER EQ ':Y.CUSTOMER:' AND CATEGORY GE 6000 AND CATEGORY LE 6599 AND CATEGORY NE 6013 6014 6015 6016 6017 6018 6019 6020'
    ACCOUNT.LIST = ''
    LIST.NAME = ''
    SELECTED = ''
    Y.RET1 = ''
    CALL EB.READLIST(Y.SEL.CMD,ACCOUNT.LIST,LIST.NAME,SELECTED,Y.RET1)
    Y.ALL.ACCOUNTS = ACCOUNT.LIST

    GOSUB GET.JOINT.ACCS
RETURN

GET.JOINT.ACCS:
    CALL F.READ(FN.PRDLIST,Y.CUSTOMER,R.PRDLIST,FV.PRDLIST,PRDLIST.ERR)
    IF (R.PRDLIST) THEN
        Y.ACC.L = R.PRDLIST<PRD.PRODUCT.ID>
        Y.ACC.S = R.PRDLIST<PRD.PRD.STATUS>
        Y.ACC.TOC =  R.PRDLIST<PRD.TYPE.OF.CUST>

        Y.CNT = DCOUNT(Y.ACC.L,@VM)
        FOR A = 1 TO Y.CNT STEP 1
            IF Y.ACC.S<1,A> EQ 'ACTIVE' AND Y.ACC.TOC<1,A> NE 'CUSTOMER' THEN
                Y.ALL.ACCOUNTS<-1> = Y.ACC.L<1,A>
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

*ENQ.DATA<4,POS> = ''
*ENQ.DATA<3,POS> = ''
*ENQ.DATA<2,POS> = ''
    END

*DEBUG
RETURN

END
