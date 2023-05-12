* @ValidationCode : MjotMTA5NzMyNDc2NjpDcDEyNTI6MTY4MzExNTQzNDQ5ODpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 03 May 2023 17:33:54
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : N/A
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
*-----------------------------------------------------------------------------------
* Modification History:
*DATE                 WHO                  REFERENCE                     DESCRIPTION
*06/04/2023      CONVERSION TOOL     AUTO R22 CODE CONVERSION            F.READ TO CACHE.READ, F.COMMISSION.TYPE TO R.COMMISSION.TYPE,VM TO @VM
*06/04/2023         SURESH           MANUAL R22 CODE CONVERSION           CALL Rtn format modified
*-----------------------------------------------------------------------------------
SUBROUTINE REDO.FT.DEF.COMM.CHG
*
*------------------------------------------------------------------------
*
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.ACCOUNT
    $INSERT I_F.CUSTOMER.CHARGE
    $INSERT I_F.FUNDS.TRANSFER
    $INSERT I_F.COMPANY
    $INSERT I_F.CURRENCY
    $INSERT I_F.CUSTOMER
    $INSERT I_F.FT.APPL.DEFAULT
    $INSERT I_F.FT.GROUP.CONDITION
    $INSERT I_F.FT.TXN.TYPE.CONDITION
    $INSERT I_F.AGENCY
    $INSERT I_F.FT.COMMISSION.TYPE
    $INSERT I_F.FT.CHARGE.TYPE
    $INSERT I_F.FTCOM
    $INSERT I_F.CORR.BANK.CHARGES         ;* EN_10001649 S/E
    $USING APAP.REDOVER
*
*-----------------------------------------------------------------------
*
*
** Initialise variables
*

    IF MESSAGE EQ "VAL" THEN
        RETURN
    END
    CALC.AMT = ""     ;* Commission calculated
    TYPE = ""
    FN.COMMISSION.TYPE='F.FT.COMMISSION.TYPE'
    F.COMMISSION.TYPE=''
    CALL OPF(FN.COMMISSION.TYPE,F.COMMISSION.TYPE)

    APP='FT.COMMISSION.TYPE'
    Y.FIELDS='L.FT4.TX.CMM.FL'
    CALL MULTI.GET.LOC.REF(APP,Y.FIELDS,POS)


    COM.CHG = "COM"   ;* Commission
    TYPE = "COM"
    IF R.TXN.TYPE(FT6.COMM.TYPES) NE "" THEN        ;* CI_10010536 S/E
        NO.OF.TYPES = COUNT(R.TXN.TYPE(FT6.COMM.TYPES),@VM) + (R.TXN.TYPE(FT6.COMM.TYPES) NE "")
        FOR AV = 1 TO NO.OF.TYPES
            MIN.MAX = ""
            COMM.PERCENT = "" ; CALC.AMT = ""
            CHARGECCY = LCCY
            COMM.TYPE = R.TXN.TYPE(FT6.COMM.TYPES)<1,AV>
            GOSUB SET.UP.COND.PERCENT
            GOSUB BUILD.UP.LIST     ;* Store details for call
        NEXT AV
    END
    COMI=(COMI-COND.DATA.CHG<1>-COND.DATA.TAX<1>)/((COND.DATA.CHG<2>/100)+(COND.DATA.TAX<2>/100)+1)
*CALL APAP.REDOVER.REDO.V.FT.CALC.COMM ;*MANUAL R22 CODE CONVERSION
    CALL APAP.REDOVER.redoVFtCalcComm()
RETURN
*
*------------------------------------------------------------------------
SET.UP.COND.PERCENT:
*===================
    CALC.AMT    =''
    COMM.PERCENT=''
    CALL CACHE.READ(FN.COMMISSION.TYPE, COMM.TYPE, R.COMMISSION.TYPE, ERR)
    IF NOT(ERR) THEN
        Y.CM.TAX.TYPE=R.COMMISSION.TYPE<FT4.LOCAL.REF><1,POS>
        CALC.AMT    =R.COMMISSION.TYPE<FT4.FLAT.AMT>
        COMM.PERCENT=R.COMMISSION.TYPE<FT4.PERCENTAGE>
    END
RETURN
*
*-----------------------------------------------------------------------
BUILD.UP.LIST:
*============
*
    IF Y.CM.TAX.TYPE NE 'T' THEN
        IF CALC.AMT NE "" THEN
            COND.DATA.CHG<1>+=CALC.AMT
        END ELSE
            COND.DATA.CHG<2>+=COMM.PERCENT
        END
    END
    ELSE
        IF CALC.AMT NE "" THEN
            COND.DATA.TAX<1>+=CALC.AMT
        END ELSE
            COND.DATA.TAX<2>+=COMM.PERCENT
        END
    END
RETURN
END
