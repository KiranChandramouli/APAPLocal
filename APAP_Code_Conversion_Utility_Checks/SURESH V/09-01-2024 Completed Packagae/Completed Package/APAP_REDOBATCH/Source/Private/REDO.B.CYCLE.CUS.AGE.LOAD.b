* @ValidationCode : MjotMTAxMzc0MzcxMDpDcDEyNTI6MTcwMzU3NjM1ODk4NzozMzNzdTotMTotMTowOjA6ZmFsc2U6Ti9BOlIyMV9BTVIuMDotMTotMQ==
* @ValidationInfo : Timestamp         : 26 Dec 2023 13:09:18
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : 333su
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
* 11-04-2023        �CONVERSTION TOOL   �  R22 AUTO CONVERSTION - No Change
* 11-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*26/12/2023         Suresh                R22 Manual Conversion    CALL routine modified
*--------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_REDO.B.CYCLE.CUS.AGE.COMMON
    
    $USING EB.LocalReferences ;*R22 Manual Conversion

    FN.CUSTOMER = 'F.CUSTOMER'
    F.CUSTOMER = ''
    CALL OPF(FN.CUSTOMER, F.CUSTOMER)

    FN.CUSTOMER.DOB = 'F.CUSTOMER.DOB'
    F.CUSTOMER.DOB = ''
    CALL OPF(FN.CUSTOMER.DOB, F.CUSTOMER.DOB)

*    CALL GET.LOC.REF('CUSTOMER', 'L.CU.AGE', Y.LR.CU.AGE.POS)
    EB.LocalReferences.GetLocRef('CUSTOMER', 'L.CU.AGE', Y.LR.CU.AGE.POS) ;*R22 Manual Conversion


RETURN
*--------------------------------------------------------------------------------
END
*--------------------------------------------------------------------------------
