* @ValidationCode : Mjo3NzY4Nzk1MTpDcDEyNTI6MTY4MTE4OTM5NjAwMDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 11 Apr 2023 10:33:16
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
SUBROUTINE REDO.B.CYCLE.CUS.AGE.LOAD
*--------------------------------------------------------------------------------
* Description: Subroutine to perform the initialisation of the batch job
* Programmer: M.MURALI (Temenos Application Management)
* Creation Date: 02 Jul 09
*--------------------------------------------------------------------------------
* Modification History:
* Date                  who                   Reference              
* 11-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.CUSTOMER.DOB = 'F.CUSTOMER.DOB'
    F.CUSTOMER.DOB = ''
    CALL OPF(FN.CUSTOMER.DOB, F.CUSTOMER.DOB)

    CALL GET.LOC.REF('CUSTOMER', 'L.CU.AGE', Y.LR.CU.AGE.POS)


RETURN
*--------------------------------------------------------------------------------
END
*--------------------------------------------------------------------------------
