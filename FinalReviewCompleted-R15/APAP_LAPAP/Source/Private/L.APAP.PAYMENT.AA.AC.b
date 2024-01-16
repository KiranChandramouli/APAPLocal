* @ValidationCode : MjoxODMxNjQxODM1OkNwMTI1MjoxNzA1MDY4MTE5ODM3OklUU1MxOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIyX1NQNS4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Jan 2024 19:31:59
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
* <Rating>-10</Rating>
*-----------------------------------------------------------------------------
SUBROUTINE L.APAP.PAYMENT.AA.AC
*--------------------------------------------------------
*Description: This conversion routine is to get the payment method
*             for a loan in overview screen.
*--------------------------------------------------------
**===========================================================================================================================================
*** Modification history
*--------------------------
*   DATE          WHO                 REFERENCE               DESCRIPTION
*   12-01-2024    Santosh        R22 MANUAL CONVERSION       BP removed
**===========================================================================================================================================
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.AA.PAYMENT.SCHEDULE

    GOSUB PROCESS
RETURN
*--------------------------------------------------------
PROCESS:
*--------------------------------------------------------


    Y.ARR.ID = O.DATA

    LOC.REF.APPLICATION   = "AA.PRD.DES.PAYMENT.SCHEDULE"
    LOC.REF.FIELDS        = 'L.AA.DEBT.AC'
    LOC.REF.POS           = ''
    CALL MULTI.GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    POS.L.AA.PAY.METHD    = LOC.REF.POS<1,1>

    EFF.DATE   = ''
    PROP.CLASS ='PAYMENT.SCHEDULE'
    PROPERTY   = ''
    R.CONDITION= ''
    ERR.MSG    = ''
    CALL REDO.CRR.GET.CONDITIONS(Y.ARR.ID,EFF.DATE,PROP.CLASS,PROPERTY,R.CONDITION,ERR.MSG)
    O.DATA  = R.CONDITION<AA.PS.LOCAL.REF,POS.L.AA.PAY.METHD>
RETURN
*------------------------------------------

END
