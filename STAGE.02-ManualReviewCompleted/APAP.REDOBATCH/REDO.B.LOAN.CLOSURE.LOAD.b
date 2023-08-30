* @ValidationCode : MjotMTAwNzkwOTYwMDpDcDEyNTI6MTY4MTI3NTQ2MTk0MDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 12 Apr 2023 10:27:41
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
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.B.LOAN.CLOSURE.LOAD
*------------------------------------------------------------------------
* Description: This is a Load routine which will run in COB
* and close the accounts of matured AA contracts
*------------------------------------------------------------------------
* Input Arg: N/A
* Ouput Arg: N/A
*------------------------------------------------------------------------
* Modification History :
*------------------------------------------------------------------------
* DATE WHO REFERENCE DESCRIPTION
* 05-JAN-2012 H GANESH PACS00174524 - B.43 Initial Draft
* Date                  who                   Reference              
* 12-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 12-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*------------------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.LOAN.CLOSURE.COMMON
    $INSERT I_F.REDO.CUSTOMER.ARRANGEMENT

    GOSUB PROCESS
RETURN
*------------------------------------------------------------------------
PROCESS:
*------------------------------------------------------------------------

    FN.REDO.CONCAT.AA.CLOSURE.DAYS = 'F.REDO.CONCAT.AA.CLOSURE.DAYS'
    F.REDO.CONCAT.AA.CLOSURE.DAYS = ''
    CALL OPF(FN.REDO.CONCAT.AA.CLOSURE.DAYS,F.REDO.CONCAT.AA.CLOSURE.DAYS)

    FN.ACCOUNT = 'F.ACCOUNT'
    F.ACCOUNT = ''
    CALL OPF(FN.ACCOUNT,F.ACCOUNT)

    FN.REDO.CUSTOMER.ARRANGEMENT = 'F.REDO.CUSTOMER.ARRANGEMENT'
    F.REDO.CUSTOMER.ARRANGEMENT = ''
    CALL OPF(FN.REDO.CUSTOMER.ARRANGEMENT,F.REDO.CUSTOMER.ARRANGEMENT)

    FN.APAP.H.INSURANCE.DETAILS = 'F.APAP.H.INSURANCE.DETAILS'
    F.APAP.H.INSURANCE.DETAILS = ''
    CALL OPF(FN.APAP.H.INSURANCE.DETAILS,F.APAP.H.INSURANCE.DETAILS)

    LOC.REF.APPLICATION="AA.PRD.DES.CHARGE"
    LOC.REF.FIELDS='POL.NUMBER'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)

    POS.POL.NUMBER = LOC.REF.POS<1,1>

RETURN
END
