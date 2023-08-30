* @ValidationCode : MjotMjA3Mzk5MzQyNjpDcDEyNTI6MTY4MTcxMDE1NDU5MTpJVFNTOi0xOi0xOjA6MDpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 17 Apr 2023 11:12:34
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
SUBROUTINE REDO.BLD.E.REPRINT.TXN(ENQ.DATA)

****************************************************************
*-------------------------------------------------------------------------
* Company Name  : ASOCIACION POPULAR DE AHORROS Y PRESTAMOS
* Developed By  :
* Program Name  : REDO.BLD.E.REPRINT.TXN
*-------------------------------------------------------------------------
* Description:
*
*----------------------------------------------------------
* Linked with: All enquiries with REDO.APAP.H.DEAL.SLIP.QUEUE no as selection field
* In parameter : ENQ.DATA
* out parameter : None
*------------------------------------------------------------------------
* MODIFICATION HISTORY
*--------------------------------------------
***********************************************************************
*DATE                WHO                   REFERENCE         DESCRIPTION
*20-12-2010        S.DHAMU              ODR-2011-01-0103    INITIAL CREATION
*27.1.2011         C.SRIRAMAN           ODR-2011-01-0103    INITIAL CREATION
* Date                  who                   Reference              
* 17-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 17-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
****************************************************************************

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.APAP.H.REPRINT.SEQ

    FN.REDO.APAP.H.REPRINT.SEQ.NAU = 'F.REDO.APAP.H.REPRINT.SEQ$NAU'
    F.REDO.APAP.H.REPRINT.SEQ.NAU = ''
    CALL OPF(FN.REDO.APAP.H.REPRINT.SEQ.NAU,F.REDO.APAP.H.REPRINT.SEQ.NAU)

    CALL F.READ(FN.REDO.APAP.H.REPRINT.SEQ.NAU,ENQ.DATA<4,1>,R.REDO.APAP.H.REPRINT.SEQ,F.REDO.APAP.H.REPRINT.SEQ.NAU,REDO.APAP.H.REPRINT.SEQ.ERR)

    IF R.REDO.APAP.H.REPRINT.SEQ THEN
        ENQ.ERROR = 'REIMPRIMIR REQUIERE AUTORIZACION - ':ENQ.DATA<4,1>
    END

RETURN
