* @ValidationCode : MjotMjg5NzYwODUyOkNwMTI1MjoxNjgyMDczMzgzNjkwOklUU1M6LTE6LTE6Mjg1OjE6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 21 Apr 2023 16:06:23
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 285
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOENQ
SUBROUTINE REDO.ENQ.NOSTRO.AC.FT(Y.OUTPUT)

*-----------------------------------------------------------------------------
*MODIFICATION HISTORY:
*
* DATE              WHO                REFERENCE                 DESCRIPTION
* 17-APR-2023     Conversion tool   R22 Auto conversion   FM TO @FM, VM to @VM, ++ to +=
* 17-APR-2023      Harishvikram C   Manual R22 conversion      No changes
*-----------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_ENQUIRY.COMMON

    GOSUB MAIN
    GOSUB PROCESS
RETURN
********
MAIN:
*******
    FN.NOSTRO.NUM.MNE = 'F.NOSTRO.NUM.MNE'
    F.NOSTRO.NUM.MNE = ''
    CALL OPF(FN.NOSTRO.NUM.MNE,F.NOSTRO.NUM.MNE)


    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

RETURN
*********
PROCESS:
*********

    Y.CUR =  D.RANGE.AND.VALUE<1,1>
    Y.REC.ID = 'NUMBER'

    CALL CACHE.READ(FN.NOSTRO.NUM.MNE, Y.REC.ID, R.NOSTRO.NUM, NUM.ERR) ;*R22 Auto conversion
    CHANGE @VM TO @FM IN R.NOSTRO.NUM
    NOR = DCOUNT(R.NOSTRO.NUM,@FM)
    CNT = 1

    LOOP
    WHILE CNT LE NOR
        Y.ACCT.ID = R.NOSTRO.NUM<CNT>
        CALL F.READ(FN.ACCOUNT,Y.ACCT.ID,R.ACCT,F.ACCOUNT,ACC.ERR)

        VAR.CUR =  R.ACCT<AC.CURRENCY>
        VAR.TITLE = R.ACCT<AC.ACCOUNT.TITLE.1>
        IF Y.CUR EQ VAR.CUR THEN
            Y.OUTPUT<-1> = Y.ACCT.ID:'*':VAR.TITLE:'*':VAR.CUR
        END

        CNT += 1
    REPEAT

RETURN

END
