* @ValidationCode : Mjo3NzY4Nzk1MTpDcDEyNTI6MTY4NDg1NDM4NDc0MjpJVFNTOi0xOi0xOjE5ODoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:24
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : 198
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
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
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
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
