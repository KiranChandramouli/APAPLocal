* @ValidationCode : MjotMTk3MDQ4NTMwODpDcDEyNTI6MTY4MTI4NzM0MjE3MzpzYW1hcjotMTotMTowOjA6ZmFsc2U6Ti9BOkRFVl8yMDIxMDguMDotMTotMQ==
* @ValidationInfo : Timestamp         : 12 Apr 2023 13:45:42
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
$PACKAGE APAP.REDOVER
SUBROUTINE REDO.V.INP.TAX.AMT
*-----------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* DESCRIPTION : This routine will be executed at Input Level for the Following versions of
* TELLER,CHEQUE.GOVERNMENT.TAX and TELLER,CHEQUE.GOVERNMENT.BENEFICIARY. This Routine is used
* to calculate the Tax Amount based upon the Tax percentage defined in the table CERTIFIED.CHEQUE.PARAMETER
*------------------------------------------------------------------------------------------
*------------------------------------------------------------------------------------------
* * Input / Output
* --------------
* IN     : -NA-
* OUT    : -NA-
* Linked : TELLER
*------------------------------------------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : SUDHARSANAN S
* PROGRAM NAME : REDO.V.INP.TAX.AMT
*------------------------------------------------------------------------------------------
* Modification History :
*-----------------------
* DATE             WHO                REFERENCE                          DESCRIPTION
* 16.03.2010      SUDHARSANAN S     ODR-2009-10-0319                 INITIAL CREATION
*12-04-2023     Conversion Tool     R22 Auto Code conversion        VM TO @VM,F.READ TO CACHE.READ
*12-04-2023      Samaran T          R22 Manual Code conversion          No Changes
* -----------------------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_GTS.COMMON
    $INSERT I_F.TELLER
    $INSERT I_F.CERTIFIED.CHEQUE.PARAMETER
    $INSERT I_F.FT.COMMISSION.TYPE
    GOSUB INIT
    GOSUB PROCESS
RETURN
*-----------------------------------------------------------------------------
INIT:
    FN.TELLER='F.TELLER'
    F.TELLER=''
    CALL OPF(FN.TELLER,F.TELLER)
    FN.FT.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.FT.COMMISSION.TYPE=''
    CALL OPF(FN.FT.COMMISSION.TYPE,F.FT.COMMISSION.TYPE)
    FN.CERTIFIED.CHEQUE.PARAMETER='F.CERTIFIED.CHEQUE.PARAMETER'
    F.CERTIFIED.CHEQUE.PARAMETER=''
    CALL OPF(FN.CERTIFIED.CHEQUE.PARAMETER,F.CERTIFIED.CHEQUE.PARAMETER)
    SEL.CMD=''
    SEL.LIST=''
    NOR=''
    ERR=''
    LREF.APP='TELLER'
    LREF.FIELD='TAX.AMOUNT':@VM:'WAIVE.TAX'
    LREF.POS=''
    CALL MULTI.GET.LOC.REF(LREF.APP,LREF.FIELD,LREF.POS)
    POS.TAX.AMOUNT=LREF.POS<1,1>
    POS.WAIVE.TAX=LREF.POS<1,2>
    CALL CACHE.READ(FN.CERTIFIED.CHEQUE.PARAMETER,ID.COMPANY,R.CERT.CHEQ.PARAM,CERT.ERR)
RETURN
*---------------------------------------------------------------------------------
PROCESS:
*Populate to the tax.amount field
    IF V$FUNCTION EQ 'I' THEN
        BEGIN CASE
            CASE PGM.VERSION EQ ',CHEQUE.GOVERNMENT.TAX'
                LOCATE 'GOVT' IN R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE,1> SETTING POS THEN
                    Y.TAX.KEY = R.CERT.CHEQ.PARAM<CERT.CHEQ.TAX.KEY,POS>
                END
            CASE PGM.VERSION EQ ',CHEQUE.GOVERNMENT.BENEFICIARY'
                LOCATE 'NON.GOVT' IN R.CERT.CHEQ.PARAM<CERT.CHEQ.TYPE,1> SETTING POS THEN
                    Y.TAX.KEY = R.CERT.CHEQ.PARAM<CERT.CHEQ.TAX.KEY,POS>
                END
        END CASE
        CALL CACHE.READ(FN.FT.COMMISSION.TYPE, Y.TAX.KEY, R.FT.COMMISSION.TYPE, FT.COMM.ERR)    ;*R22 AUTO CODE CONVERSION
        LOCATE LCCY IN R.FT.COMMISSION.TYPE<FT4.CURRENCY,1> SETTING POS THEN
            Y.TAX.RATE=R.FT.COMMISSION.TYPE<FT4.PERCENTAGE,POS,1>
        END
        Y.DEBIT.AMOUNT=R.NEW(TT.TE.AMOUNT.LOCAL.1)<1,1>
        Y.TAX.AMOUNT=Y.DEBIT.AMOUNT * (Y.TAX.RATE / 100)
        R.NEW(TT.TE.LOCAL.REF)<1,POS.TAX.AMOUNT>=Y.TAX.AMOUNT
        Y.WAIVE.TAX=R.NEW(TT.TE.LOCAL.REF)<1,POS.WAIVE.TAX>
        IF Y.WAIVE.TAX EQ 'YES' THEN
            CURR.NO=''
            CURR.NO=DCOUNT(R.NEW(TT.TE.OVERRIDE),@VM) + 1
            TEXT='TT.WAIVE.TAX.APPROVAL'
            CALL STORE.OVERRIDE(CURR.NO)
        END
    END
RETURN
*------------------------------------------------------------------------------------
END
