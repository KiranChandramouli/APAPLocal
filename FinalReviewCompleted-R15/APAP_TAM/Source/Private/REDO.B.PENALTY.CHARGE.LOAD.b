* @ValidationCode : MjoxMDY1MzEzMjk3OkNwMTI1MjoxNjg0NDkxMDMwMDMzOklUU1M6LTE6LTE6MTA5MToxOmZhbHNlOk4vQTpERVZfMjAyMTA4LjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 19 May 2023 15:40:30
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 1091
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : DEV_202108.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.TAM
SUBROUTINE REDO.B.PENALTY.CHARGE.LOAD
*------------------------------------------------------------------------
* Description: This is a Load-Routine for BATCH>BNK/REDO.B.PENALTY.CHARGE in order
* to raise the penalty charge on Frequency basis.
*
*------------------------------------------------------------------------
* Input Argument : NA
* Out Argument   : NA
* Deals With     : BATCH>BNK/REDO.B.PENALTY.CHARGE
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
*  DATE             WHO                   REFERENCE                          DESCRIPTION
* 07-NOV-2011     H GANESH     ODR-2011-08-0106 CR-PENALTY CHARGE            Initial Draft.
*
* 27-OCT-2017     Edwin Charles D        PACS00622410                        Source balance referred from parent product
** 21-04-2023 R22 Auto Conversion - FM TO @FM, VM to @VM, SM to @SM
** 21-04-2023 Skanda R22 Manual Conversion - No changes
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.PENALTY.CHARGE.COMMON

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------
    FN.AA.ARRANGEMENT = 'F.AA.ARRANGEMENT'
    F.AA.ARRANGEMENT = ''
    CALL OPF(FN.AA.ARRANGEMENT,F.AA.ARRANGEMENT)

    FN.AA.ACCOUNT.DETAILS = 'F.AA.ACCOUNT.DETAILS'
    F.AA.ACCOUNT.DETAILS = ''
    CALL OPF(FN.AA.ACCOUNT.DETAILS,F.AA.ACCOUNT.DETAILS)

    FN.AA.BILL.DETAILS = 'F.AA.BILL.DETAILS'
    F.AA.BILL.DETAILS = ''
    CALL OPF(FN.AA.BILL.DETAILS,F.AA.BILL.DETAILS)

    FN.AA.PRODUCT.CATALOG = 'F.AA.PRODUCT.CATALOG'
    F.AA.PRODUCT.CATALOG = ''
    CALL OPF(FN.AA.PRODUCT.CATALOG,F.AA.PRODUCT.CATALOG)

    FN.AC.BALANCE.TYPE = 'F.AC.BALANCE.TYPE'
    F.AC.BALANCE.TYPE = ''
    CALL OPF(FN.AC.BALANCE.TYPE,F.AC.BALANCE.TYPE)

    FN.REDO.APAP.PROPERTY.PARAM = 'F.REDO.APAP.PROPERTY.PARAM'
    F.REDO.APAP.PROPERTY.PARAM = ''
    CALL OPF(FN.REDO.APAP.PROPERTY.PARAM,F.REDO.APAP.PROPERTY.PARAM)

    FN.REDO.CONCAT.PENALTY.CHARGE = 'F.REDO.CONCAT.PENALTY.CHARGE'
    F.REDO.CONCAT.PENALTY.CHARGE = ''
    CALL OPF(FN.REDO.CONCAT.PENALTY.CHARGE,F.REDO.CONCAT.PENALTY.CHARGE)

    FN.REDO.AA.OFS.FAIL = 'F.REDO.AA.OFS.FAIL'
    F.REDO.AA.OFS.FAIL = ''
    CALL OPF(FN.REDO.AA.OFS.FAIL,F.REDO.AA.OFS.FAIL)

    FN.OFS = 'F.OFS.MESSAGE.QUEUE'
    F.OFS = ''
    CALL OPF(FN.OFS,F.OFS)
* PACS00622410 - Start
    FN.AA.PRODUCT.DESIGNER = 'F.AA.PRODUCT.DESIGNER'
    F.AA.PRODUCT.DESIGNER = ''
    CALL OPF(FN.AA.PRODUCT.DESIGNER, F.AA.PRODUCT.DESIGNER)

    FN.AA.PRODUCT = 'F.AA.PRODUCT'
    F.AA.PRODUCT = ''
    CALL OPF(FN.AA.PRODUCT, F.AA.PRODUCT)
* PACS00622410 - End
    LOC.REF.APPLICATION = "AA.PRD.DES.CHARGE":@FM:"AA.PRD.DES.BALANCE.MAINTENANCE"
    LOC.REF.FIELDS = 'L.PENALTY.FREQ':@FM:'L.BILL.REF':@VM:'L.BILL.AMOUNT'
    LOC.REF.POS = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.PENALTY.FREQ = LOC.REF.POS<1,1>
    POS.L.BILL.REF     = LOC.REF.POS<2,1>
    POS.L.BILL.AMOUNT  = LOC.REF.POS<2,2>

RETURN
END
