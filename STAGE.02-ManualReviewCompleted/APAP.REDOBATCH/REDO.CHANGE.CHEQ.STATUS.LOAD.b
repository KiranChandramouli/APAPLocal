* @ValidationCode : Mjo4NzQ0MzMzNjpDcDEyNTI6MTY4MTc5NTYxNDEyMDpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 18 Apr 2023 10:56:54
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
SUBROUTINE REDO.CHANGE.CHEQ.STATUS.LOAD
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.CHANGE.CHEQ.STATUS.LOAD
*----------------------------------------------------------
* DESCRIPTION : It will be required to create REDO.CHANGE.CHEQ.STATUS.LOAD
* as a LOAD routine for BATCH

*------------------------------------------------------------

* LINKED WITH : REDO.CHANGE.CHEQ.STATUS
* IN PARAMETER: NONE
* OUT PARAMETER: NONE

* Modification History :
*-----------------------
*DATE WHO REFERENCE DESCRIPTION
*03.04.2010 HARISH.Y ODR-2009-12-0275 INITIAL CREATION
*Modification
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------
*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CHEQUE.ISSUE
    $INSERT I_F.REDO.H.SOLICITUD.CK
    $INSERT I_F.REDO.H.CHEQ.CHANGE.PARAM
    $INSERT I_REDO.CHANGE.CHEQ.STATUS.COMMON


    GOSUB INIT
RETURN

*-------------------------------------------------------------
INIT:
*-------------------------------------------------------------
    FN.REDO.H.SOLICITUD.CK = 'F.REDO.H.SOLICITUD.CK'
    F.REDO.H.SOLICITUD.CK = ''
    CALL OPF(FN.REDO.H.SOLICITUD.CK,F.REDO.H.SOLICITUD.CK)

    FN.CHEQUE.ISSUE = 'F.CHEQUE.ISSUE'
    F.CHEQUE.ISSUE = ''
    CALL OPF(FN.CHEQUE.ISSUE,F.CHEQUE.ISSUE)

    FN.REDO.H.CHEQ.CHANGE.PARAM = 'F.REDO.H.CHEQ.CHANGE.PARAM'
    F.REDO.H.CHEQ.CHANGE.PARAM = ''
    CALL OPF(FN.REDO.H.CHEQ.CHANGE.PARAM,F.REDO.H.CHEQ.CHANGE.PARAM)

    FN.CHEQUE.REGISTER = 'F.CHEQUE.REGISTER'
    F.CHEQUE.REGISTER = ''
    CALL OPF(FN.CHEQUE.REGISTER,F.CHEQUE.REGISTER)

    FN.REDO.CONCAT.CHEQUE.REGISTER = 'F.REDO.CONCAT.CHEQUE.REGISTER'
    F.REDO.CONCAT.CHEQUE.REGISTER = ''
    CALL OPF(FN.REDO.CONCAT.CHEQUE.REGISTER,F.REDO.CONCAT.CHEQUE.REGISTER)

    OFS.ARRAY=''

    LOC.REF.APPLICATION="CHEQUE.ISSUE"
    LOC.REF.FIELDS='L.SOLICITUDCKID'
    LOC.REF.POS=''
    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)


    POS.L.SOLICITUDCKID=LOC.REF.POS<1,1>


RETURN


*-------------------------------------------------------------------
END
