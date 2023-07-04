* @ValidationCode : MjotMTkxNTY3NjczMDpDcDEyNTI6MTY4NDg1NDQwNTQ0ODpJVFNTOi0xOi0xOjA6MTpmYWxzZTpOL0E6UjIxX0FNUi4wOi0xOi0x
* @ValidationInfo : Timestamp         : 23 May 2023 20:36:45
* @ValidationInfo : Encoding          : Cp1252
* @ValidationInfo : User Name         : ITSS
* @ValidationInfo : Nb tests success  : N/A
* @ValidationInfo : Nb tests failure  : N/A
* @ValidationInfo : Rating            : N/A
* @ValidationInfo : Coverage          : N/A
* @ValidationInfo : Strict flag       : true
* @ValidationInfo : Bypass GateKeeper : false
* @ValidationInfo : Compiler Version  : R21_AMR.0
* @ValidationInfo : Copyright Temenos Headquarters SA 1993-2021. All rights reserved.
$PACKAGE APAP.REDOBATCH
SUBROUTINE REDO.BUILD.VERS.ROU

*Company   Name    :Asociacion Popular de Ahorros y Prestamos
*Developed By      :MARIMUTHU S
*Program   Name    :REDO.BUILD.VERS.ROU
*---------------------------------------------------------------------------------

*DESCRIPTION       : This is conversion routine used in the enquiry REDO.PART.TT.PROCESS.LIST

* ----------------------------------------------------------------------------------
*Modification Details:
*=====================
*   Date               who           Reference            Description
* 10-08-2010        MARIMUTHU S      PACS00094144       Initial Creation
* Date                  who                   Reference              
* 18-04-2023         CONVERSTION TOOL      R22 AUTO CONVERSTION - No Change
* 18-04-2023          ANIL KUMAR B         R22 MANUAL CONVERSTION -NO CHANGES
*-------------------------------------------------------------------------------------

    $INSERT I_COMMON
    $INSERT I_EQUATE
    $INSERT I_ENQUIRY.COMMON
    $INSERT I_F.REDO.REPAY.NEXT.VER.PROCESS

    FN.REDO.REPAY.NEXT.VER.PROCESS = 'F.REDO.REPAY.NEXT.VER.PROCESS'
    F.REDO.REPAY.NEXT.VER.PROCESS = ''


    CALL CACHE.READ(FN.REDO.REPAY.NEXT.VER.PROCESS,'SYSTEM',R.REDO.REPAY.NEXT.VER.PROCESS,ERRR)

    Y.VAL = O.DATA

    Y.VERSIONS = R.REDO.REPAY.NEXT.VER.PROCESS<REP.NX.PAYMENT.VERSION>
    Y.PAYMETN.MET = R.REDO.REPAY.NEXT.VER.PROCESS<REP.NX.PAYMENT.METHOD>

    LOCATE Y.VAL IN Y.PAYMETN.MET<1,1> SETTING POS.PR THEN
        O.DATA = Y.VERSIONS<1,POS.PR>
    END

END
