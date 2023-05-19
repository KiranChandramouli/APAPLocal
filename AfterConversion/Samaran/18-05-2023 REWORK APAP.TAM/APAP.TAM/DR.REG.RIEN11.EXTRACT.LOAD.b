* @ValidationCode : MjotMTAxNzA5ODY5MzpDcDEyNTI6MTY4NDQwNTU2MjYyNTpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 18 May 2023 15:56:02
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : samar
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE DR.REG.RIEN11.EXTRACT.LOAD
*-----------------------------------------------------------------------------
* Company Name   : APAP
* Developed By   :
* Program Name   : DR.REG.RIEN11.TXN.EXTRACT
* Date           : 10-June-2013
*-----------------------------------------------------------------------------
* Description:
*------------
* This multi-thread job is meant for to extact the tranactions made over 1000 by individual Customer daily.
*-----------------------------------------------------------------------------
*
* Modification History :
* ----------------------
*   Date       Author              Modification Description
*  08/07/2014  Ashokkumar            PACS00312712 - Updated selection criteria and field length
* Date                  who                   Reference
* 24-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION -$INSERT T24.BP TO $INSERT AND $INCLUDE REGREP.BP TO $INSERT AND $INCLUDE LAPAP.BP TO $INSERT AND FM TO @FM AND VM TO @VM AND SM TO @SM
* 24-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-----------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_BATCH.FILES
    $INSERT I_F.DATES
    $INSERT I_F.TRANSACTION
    $INSERT I_DR.REG.RIEN11.EXTRACT.COMMON
    $INSERT I_F.DR.REG.RIEN11.PARAM

    GOSUB OPEN.FILES
    GOSUB INIT.PARA
RETURN

OPEN.FILES:
***********

    FN.STMT.ENTRY = 'F.STMT.ENTRY'  ; F.STMT.ENTRY = ''
    CALL OPF(FN.STMT.ENTRY, F.STMT.ENTRY)

    FN.ACCT.ENT.LWORK.DAY = 'F.ACCT.ENT.LWORK.DAY'  ; F.ACCT.ENT.LWORK.DAY = ""
    CALL OPF(FN.ACCT.ENT.LWORK.DAY, F.ACCT.ENT.LWORK.DAY)

    FN.DR.REG.RIEN11.PARAM = 'F.DR.REG.RIEN11.PARAM'   ; F.DR.REG.RIEN11.PARAM = ''
    CALL OPF(FN.DR.REG.RIEN11.PARAM, F.DR.REG.RIEN11.PARAM)

    FN.DR.REG.RIEN11.WORKFILE = 'F.DR.REG.RIEN11.WORKFILE'; FV.DR.REG.RIEN11.WORKFILE = ''
    CALL OPF(FN.DR.REG.RIEN11.WORKFILE,FV.DR.REG.RIEN11.WORKFILE)

    FN.DR.REG.RIEN11.WORKFILE.FCY = 'F.DR.REG.RIEN11.WORKFILE.FCY'; FV.DR.REG.RIEN11.WORKFILE.FCY = ''
    CALL OPF(FN.DR.REG.RIEN11.WORKFILE.FCY,FV.DR.REG.RIEN11.WORKFILE.FCY)

    FN.REDO.AZACC.DESC = 'F.REDO.AZACC.DESC'; F.REDO.AZACC.DESC = ''
    CALL OPF(FN.REDO.AZACC.DESC,F.REDO.AZACC.DESC)

    FN.ACCOUNT = 'F.ACCOUNT'; F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.CUSTOMER = 'F.CUSTOMER'; F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER,F.CUSTOMER)

    FN.TRANSACTION = 'F.TRANSACTION'; F.TRANSACTION = ''
    CALL OPF(FN.TRANSACTION,F.TRANSACTION)

    FN.EB.CONTRACT.BALANCES = 'F.EB.CONTRACT.BALANCES'; F.EB.CONTRACT.BALANCES = ''
    CALL OPF(FN.EB.CONTRACT.BALANCES,F.EB.CONTRACT.BALANCES)

    FN.RE.STAT.REP.LINE = 'F.RE.STAT.REP.LINE'; F.RE.STAT.REP.LINE = ''
    CALL OPF(FN.RE.STAT.REP.LINE,F.RE.STAT.REP.LINE)
RETURN
*-------------------------------------------------------------------
INIT.PARA:
**********
    R.DR.REG.RIEN11.PARAM = ''; DR.REG.RIEN11.PARAM.ERR = ''
    CALL CACHE.READ(FN.DR.REG.RIEN11.PARAM, "SYSTEM", R.DR.REG.RIEN11.PARAM, DR.REG.RIEN11.PARAM.ERR)
    LAST.WRK.DATE = R.DATES(EB.DAT.LAST.WORKING.DAY)
    IF R.DR.REG.RIEN11.PARAM THEN
        FLD.DEL = R.DR.REG.RIEN11.PARAM<DR.RIEN11.PARAM.FLD.DELIM>
        CATEG.LST.VAL = R.DR.REG.RIEN11.PARAM<DR.RIEN11.PARAM.CATEGORY>
        Y.FIELD.NME.ARR = R.DR.REG.RIEN11.PARAM<DR.RIEN11.PARAM.FIELD.NAME>
        Y.FIELD.VAL.ARR = R.DR.REG.RIEN11.PARAM<DR.RIEN11.PARAM.FIELD.VALUE>
        Y.DISP.TEXT.ARR = R.DR.REG.RIEN11.PARAM<DR.RIEN11.PARAM.DISPLAY.VALUE>
    END

    LOCATE "CURRENCY" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCCY.POS THEN
        Y.TXNCCY.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCCY.POS>
        Y.TXNCCY.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNCCY.POS>
    END
    Y.TXNCCY.VAL.ARR = CHANGE(Y.TXNCCY.VAL.ARR,@SM,@VM)
    Y.TXNCCY.DIS.ARR = CHANGE(Y.TXNCCY.DIS.ARR,@SM,@VM)

    LOCATE "TRANSACTION.CODE" IN Y.FIELD.NME.ARR<1,1> SETTING TXNCDE.POS THEN
        Y.TXNCDE.VAL.ARR = Y.FIELD.VAL.ARR<1,TXNCDE.POS>
        Y.TXNCDE.DIS.ARR = Y.DISP.TEXT.ARR<1,TXNCDE.POS>
    END
    Y.TXNCDE.VAL.ARR = CHANGE(Y.TXNCDE.VAL.ARR,@SM,@VM)
    Y.TXNCDE.DIS.ARR = CHANGE(Y.TXNCDE.DIS.ARR,@SM,@VM)
*
    L.APP = 'CUSTOMER':@FM:'TRANSACTION'
    L.FLD = 'L.CU.CIDENT':@VM:'L.CU.RNC':@VM:'L.CU.TIPO.CL':@VM:'L.CU.PASS.NAT':@VM:'L.APAP.INDUSTRY':@FM:'COL.TXN.CODE'
    L.POS = ''
    CALL MULTI.GET.LOC.REF(L.APP,L.FLD,L.POS)
    L.CU.CIDENT.POS = L.POS<1,1>
    L.CU.RNC.POS = L.POS<1,2>
    L.CU.TIPO.CL.POS = L.POS<1,3>
    L.CU.FOREIGN.POS = L.POS<1,4>
    Y.APAP.INDUS.POS = L.POS<1,5>
    L.TXN.CODE.POS = L.POS<2,1>
RETURN

END
