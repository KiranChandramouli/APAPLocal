* @ValidationCode : MjotOTc4NDAyMTMzOkNwMTI1MjoxNzA0NzkzMjAyMTU0OjMzM3N1Oi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 09 Jan 2024 15:10:02
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
*18/01/2024         Suresh                 R22 UTILITY AUTO CONVERSION   CALL routine Modified
*-------------------------------------------------------------
*-------------------------------------------------------------
    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_F.CHEQUE.ISSUE
    $INSERT I_F.REDO.H.SOLICITUD.CK
    $INSERT I_F.REDO.H.CHEQ.CHANGE.PARAM
    $INSERT I_REDO.CHANGE.CHEQ.STATUS.COMMON
    $USING EB.LocalReferences


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
*    CALL GET.LOC.REF(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS)
    EB.LocalReferences.GetLocRef(LOC.REF.APPLICATION,LOC.REF.FIELDS,LOC.REF.POS);* R22 UTILITY AUTO CONVERSION


    POS.L.SOLICITUDCKID=LOC.REF.POS<1,1>

 
RETURN


*-------------------------------------------------------------------
END
