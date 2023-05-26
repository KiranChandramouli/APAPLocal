* @ValidationCode : MjoxNzM4MDE0NDY6Q3AxMjUyOjE2ODQ4NTQ0MDYzMTA6SVRTUzotMTotMTotNzoxOmZhbHNlOk4vQTpSMjFfQU1SLjA6LTE6LTE=
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:46
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : -7
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.CHANGE.CHEQ.STATUS.SELECT
***********************************************************
*----------------------------------------------------------
* COMPANY NAME : APAP
* DEVELOPED BY : HARISH.Y
* PROGRAM NAME : REDO.CHANGE.CHEQ.STATUS.SELECT
*----------------------------------------------------------
* DESCRIPTION : It will be required to create REDO.CHANGE.CHEQ.STATUS.SELECT
* as a SELECT routine for BATCH

*------------------------------------------------------------

*    LINKED WITH : REDO.CHANGE.CHEQ.STATUS
*    IN PARAMETER: NONE
*    OUT PARAMETER: NONE
* Modification History :
*-----------------------
*DATE             WHO         REFERENCE         DESCRIPTION
*03.04.2010      HARISH.Y     ODR-2009-12-0275  INITIAL CREATION
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

    GOSUB PERFORM.SELECT
RETURN

*-------------------------------------------------------------
PERFORM.SELECT:
*-------------------------------------------------------------

    SEL.CMD = "SELECT ":FN.REDO.H.SOLICITUD.CK :" WITH CHEQUE.STATUS EQ 40"
    CALL EB.READLIST(SEL.CMD,SEL.LIST,'',NO.OF.REC,CK.ERR)
    CALL BATCH.BUILD.LIST('', SEL.LIST)
RETURN
END
